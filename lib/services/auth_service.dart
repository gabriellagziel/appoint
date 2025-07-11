import 'package:appoint/config/environment_config.dart';
import 'package:appoint/models/app_user.dart';
import 'package:appoint/services/error_handling_service.dart';
import 'package:appoint/widgets/social_account_conflict_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {

  /// Constructor that accepts injected dependencies for testing
  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  // Load redirect URI from environment configuration
  static const String redirectUri = EnvironmentConfig.authRedirectUri;

  final FirebaseAuth _firebaseAuth;
  ErrorHandlingService _errorService = ErrorHandlingService();

  Future<User?> currentUser() async => _firebaseAuth.currentUser;

  Stream<AppUser?> authStateChanges() => _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      token = await user.getIdTokenResult(true);
      final claims = token.claims ?? <String, dynamic>{};
      final role = claims['role'] as String? ?? 'personal';
      return AppUser(
        uid: user.uid,
        email: user.email,
        role: role,
        studioId: claims['studioId'] as String?,
        businessProfileId: claims['businessProfileId'] as String?,
      );
    });

  Future<void> signIn(String email, final String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {e) {
      await _handleAuthException(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signInWithGooglePopup() async {
    try {
      googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'redirectUri': redirectUri});
      return await _firebaseAuth.signInWithPopup(googleProvider);
    } on FirebaseAuthException catch (e) {e) {
      await _handleAuthException(e);
      rethrow;
    }
  }

  /// Handle social account conflicts by showing a dialog
  Future<String?> handleSocialAccountConflict(
    BuildContext context,
    FirebaseAuthException error,
  ) async {
    if (!isSocialAccountConflict(error)) {
      return null;
    }

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SocialAccountConflictDialog(
        error: error,
        onLinkAccounts: () => Navigator.of(context).pop('link'),
        onSignInWithExistingMethod: () => Navigator.of(context).pop('existing'),
        onCancel: () => Navigator.of(context).pop('cancel'),
      ),
    );

    return result;
  }

  /// Sign in with Google and handle social account conflicts
  Future<UserCredential?> signInWithGooglePopupWithConflictHandling(
    BuildContext context,
  ) async {
    try {
      return await signInWithGooglePopup();
    } on FirebaseAuthException catch (e) {e) {
      if (isSocialAccountConflict(e)) {
        choice = await handleSocialAccountConflict(context, e);

        switch (choice) {
          case 'link':
            // Handle account linking
            return _handleAccountLinking(e);
          case 'existing':
            // Guide user to sign in with existing method
            return null;
          case 'cancel':
          default:
            return null;
        }
      } else {
        await _handleAuthException(e);
        rethrow;
      }
    }
    return null;
  }

  /// Handle account linking when user chooses to link accounts
  Future<UserCredential?> _handleAccountLinking(
      FirebaseAuthException error,) async {
    try {
      credential = getConflictingCredential(error);
      if (credential != null) {
        // Link the credential to the current user
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null) {
          return await currentUser.linkWithCredential(credential);
        }
      }
    } on FirebaseAuthException catch (e) {e) {
      await _handleAuthException(e);
      rethrow;
    }
    return null;
  }

  /// Handle Firebase Auth exceptions with proper error mapping
  Future<void> _handleAuthException(FirebaseAuthException e) async {
    errorType = _mapFirebaseErrorToType(e.code);
    severity = _getErrorSeverity(e.code);

    await _errorService.handleError(
      e,
      StackTrace.current,
      type: errorType,
      severity: severity,
      context: {
        'firebase_error_code': e.code,
        'firebase_error_message': e.message,
        'operation': 'authentication',
      },
    );
  }

  /// Map Firebase Auth error codes to our error types
  ErrorType _mapFirebaseErrorToType(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
      case 'credential-already-in-use':
        return ErrorType.authentication;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
      case 'user-disabled':
        return ErrorType.authentication;
      case 'weak-password':
      case 'email-already-in-use':
        return ErrorType.validation;
      case 'network-request-failed':
      case 'too-many-requests':
        return ErrorType.network;
      case 'operation-not-allowed':
      case 'invalid-credential':
        return ErrorType.authentication;
      default:
        return ErrorType.unknown;
    }
  }

  /// Get error severity based on Firebase error code
  ErrorSeverity _getErrorSeverity(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
      case 'credential-already-in-use':
        return ErrorSeverity.high;
      case 'user-disabled':
      case 'operation-not-allowed':
        return ErrorSeverity.critical;
      case 'too-many-requests':
        return ErrorSeverity.high;
      default:
        return ErrorSeverity.medium;
    }
  }

  /// Check if the error is a social account link conflict
  bool isSocialAccountConflict(FirebaseAuthException e) => e.code == 'account-exists-with-different-credential' ||
        e.code == 'credential-already-in-use';

  /// Get the email associated with the conflicting account
  String? getConflictingEmail(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return e.email;
    }
    return null;
  }

  /// Get the credential that was used in the failed sign-in attempt
  AuthCredential? getConflictingCredential(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return e.credential;
    }
    return null;
  }
}
