import 'package:appoint/config/environment_config.dart';
import 'package:appoint/models/app_user.dart';
import 'package:appoint/models/user_profile.dart';
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
  final ErrorHandlingService _errorService = ErrorHandlingService();
  IdTokenResult? token;

  Future<User?> currentUser() async => _firebaseAuth.currentUser;

  Stream<AppUser?> authStateChanges() => _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final token = await user.getIdTokenResult(true);
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
    } on FirebaseAuthException catch (e) {
      await _handleAuthException(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signInWithGooglePopup() async {
    try {
      final googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'redirectUri': redirectUri});
      return await _firebaseAuth.signInWithPopup(googleProvider);
    } on FirebaseAuthException catch (e) {
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
    BuildContext context) async {
    try {
      return await signInWithGooglePopup();
    } on FirebaseAuthException catch (e) {
      if (isSocialAccountConflict(e)) {
        final choice = await handleSocialAccountConflict(context, e);

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
      FirebaseAuthException error) async {
    try {
      final credential = getConflictingCredential(error);
      if (credential != null) {
        // Link the credential to the current user
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null) {
          return await currentUser.linkWithCredential(credential);
        }
      }
    } on FirebaseAuthException catch (e) {
      await _handleAuthException(e);
      rethrow;
    }
    return null;
  }

  /// Handle Firebase Auth exceptions with proper error mapping
  Future<void> _handleAuthException(FirebaseAuthException e) async {
    final errorType = _mapFirebaseErrorToType(e.code);
    final severity = _getErrorSeverity(e.code);

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

  /// Sign in with email & password – kept for backward compatibility with existing tests
  Future<UserProfile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password must not be empty');
    }
    if (!isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw FirebaseAuthException(code: 'user-not-found');

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        // Immediately sign-out and force user to verify.
        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email address has not been verified.',
        );
      }

      return UserProfile(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      await _handleAuthException(e);
      rethrow;
    }
  }

  /// Register with email & password and send verification email.
  Future<UserProfile> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (!isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
    if (!isValidPassword(password)) {
      throw ArgumentError('Weak password');
    }

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw FirebaseAuthException(code: 'unknown');

      await user.updateDisplayName(displayName);
      await user.sendEmailVerification();

      return UserProfile(
        id: user.uid,
        name: displayName ?? '',
        email: user.email,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      await _handleAuthException(e);
      rethrow;
    }
  }

  /// Reset password by sending reset link to user email.
  Future<void> resetPassword(String email) async {
    if (!isValidEmail(email)) {
      throw ArgumentError('Invalid email');
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      await _handleAuthException(e);
      rethrow;
    }
  }

  /// Return [UserProfile] of current authenticated user (or null).
  Future<UserProfile?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserProfile(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  /// Update Firestore user document with new profile data.
  Future<void> updateUserProfile(UserProfile profile) async {
    // TODO: Implement Firestore update logic. For now we just update Firebase Auth displayName & photo
    final user = _firebaseAuth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'user-not-found');
    await user.updateDisplayName(profile.name);
    if (profile.photoUrl != null) {
      await user.updatePhotoURL(profile.photoUrl);
    }
    // Firestore sync pending implementation
  }

  /// Permanently delete current user account.
  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'user-not-found');
    await user.delete();
    // TODO: Optionally remove accompanying Firestore docs.
  }

  /// Validate email format using simple regex.
  bool isValidEmail(String email) {
    const pattern = r"^[^@\s]+@[^@\s]+\.[^@\s]+";
    return RegExp(pattern).hasMatch(email);
  }

  /// Validate password strength (min 8 chars incl upper, lower, number).
  bool isValidPassword(String password) {
    if (password.length < 8) return false;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#\$&*~]'));
    return hasUpper && hasLower && hasNumber && hasSpecial;
  }
}
