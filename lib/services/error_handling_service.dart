import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

enum ErrorType {
  network,
  authentication,
  validation,
  database,
  file,
  unknown,
}

class AppError {

  AppError({
    required this.message,
    required this.type, required this.severity, this.code,
    this.stackTrace,
    this.context,
  });
  final String message;
  final String? code;
  final ErrorType type;
  final ErrorSeverity severity;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;

  @override
  String toString() => 'AppError: $message (${type.name}, ${severity.name})';
}

class ErrorHandlingService {
  factory ErrorHandlingService() => _instance;
  ErrorHandlingService._internal();
  static final ErrorHandlingService _instance =
      ErrorHandlingService._internal();

  /// Handle and log errors
  Future<void> handleError(
    final error,
    final StackTrace? stackTrace, {
    final ErrorType type = ErrorType.unknown,
    final ErrorSeverity severity = ErrorSeverity.medium,
    final Map<String, dynamic>? context,
  }) async {
    final appError = AppError(
      message: error.toString(),
      type: type,
      severity: severity,
      stackTrace: stackTrace,
      context: context,
    );

    // Log to console in debug mode
    if (kDebugMode) {
      // Removed debug print: debugPrint('🚨 Error: ${appError.message}');
      // Removed debug print: debugPrint('Type: ${appError.type.name}');
      // Removed debug print: debugPrint('Severity: ${appError.severity.name}');
      if (context != null) {
        // Removed debug print: debugPrint('Context: $context');
      }
      if (stackTrace != null) {
        // Removed debug print: debugPrint('StackTrace: $stackTrace');
      }
    }

    // Send to Crashlytics in production
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: appError.message,
        information: context?.entries
                .map((e) => '${e.key}: ${e.value}')
                .toList() ??
            [],
      );
    }

    // Handle critical errors
    if (severity == ErrorSeverity.critical) {
      await _handleCriticalError(appError);
    }
  }

  /// Handle critical errors
  Future<void> _handleCriticalError(AppError error) async {
    // Log critical error
    // Removed debug print: debugPrint('🚨 CRITICAL ERROR: ${error.message}');

    // In a real app, you might:
    // - Show a critical error screen
    // - Send emergency notifications
    // - Restart the app
    // - Clear corrupted data
  }

  /// Handle network errors
  Future<void> handleNetworkError(
      error, final StackTrace? stackTrace,) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.network,
      context: {'operation': 'network_request'},
    );
  }

  /// Handle authentication errors
  Future<void> handleAuthError(
      error, final StackTrace? stackTrace,) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.authentication,
      severity: ErrorSeverity.high,
      context: {'operation': 'authentication'},
    );
  }

  /// Handle validation errors
  Future<void> handleValidationError(
      error, final StackTrace? stackTrace,) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.validation,
      severity: ErrorSeverity.low,
      context: {'operation': 'validation'},
    );
  }

  /// Handle database errors
  Future<void> handleDatabaseError(
      error, final StackTrace? stackTrace,) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.database,
      severity: ErrorSeverity.high,
      context: {'operation': 'database'},
    );
  }

  /// Handle file errors
  Future<void> handleFileError(
      error, final StackTrace? stackTrace,) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.file,
      context: {'operation': 'file_operation'},
    );
  }

  /// Get user-friendly error message
  String getUserFriendlyMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return 'Connection error. Please check your internet connection and try again.';
      case ErrorType.authentication:
        return 'Authentication failed. Please log in again.';
      case ErrorType.validation:
        return 'Invalid input. Please check your data and try again.';
      case ErrorType.database:
        return 'Data error. Please try again later.';
      case ErrorType.file:
        return 'File operation failed. Please try again.';
      case ErrorType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Check if error is recoverable
  bool isRecoverable(AppError error) => error.severity != ErrorSeverity.critical;

  /// Get error recovery suggestion
  String getRecoverySuggestion(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return 'Try checking your internet connection and restarting the app.';
      case ErrorType.authentication:
        return 'Please log out and log back in.';
      case ErrorType.validation:
        return 'Please review your input and try again.';
      case ErrorType.database:
        return 'Please try again in a few minutes.';
      case ErrorType.file:
        return 'Please try again or contact support if the problem persists.';
      case ErrorType.unknown:
        return 'Please restart the app or contact support if the problem persists.';
    }
  }

  /// Get localized Firebase Auth error message
  String getLocalizedFirebaseAuthError(
      FirebaseAuthException e, AppLocalizations l10n,) {
    switch (e.code) {
      case 'user-not-found':
        return l10n.authErrorUserNotFound;
      case 'wrong-password':
        return l10n.authErrorWrongPassword;
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'user-disabled':
        return l10n.authErrorUserDisabled;
      case 'weak-password':
        return l10n.authErrorWeakPassword;
      case 'email-already-in-use':
        return l10n.authErrorEmailAlreadyInUse;
      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;
      case 'operation-not-allowed':
        return l10n.authErrorOperationNotAllowed;
      case 'invalid-credential':
        return l10n.authErrorInvalidCredential;
      case 'REDACTED_TOKEN':
        return l10n.REDACTED_TOKEN;
      case 'credential-already-in-use':
        return l10n.authErrorCredentialAlreadyInUse;
      case 'network-request-failed':
        return l10n.authErrorNetworkRequestFailed;
      case 'requires-recent-login':
        return l10n.authErrorRequiresRecentLogin;
      case 'app-not-authorized':
        return l10n.authErrorAppNotAuthorized;
      case 'invalid-verification-code':
        return l10n.REDACTED_TOKEN;
      case 'invalid-verification-id':
        return l10n.authErrorInvalidVerificationId;
      case 'missing-verification-code':
        return l10n.REDACTED_TOKEN;
      case 'missing-verification-id':
        return l10n.authErrorMissingVerificationId;
      case 'invalid-phone-number':
        return l10n.authErrorInvalidPhoneNumber;
      case 'missing-phone-number':
        return l10n.authErrorMissingPhoneNumber;
      case 'quota-exceeded':
        return l10n.authErrorQuotaExceeded;
      case 'code-expired':
        return l10n.authErrorCodeExpired;
      case 'session-expired':
        return l10n.authErrorSessionExpired;
      case 'multi-factor-auth-required':
        return l10n.REDACTED_TOKEN;
      case 'multi-factor-info-not-found':
        return l10n.REDACTED_TOKEN;
      case 'missing-multi-factor-session':
        return l10n.REDACTED_TOKEN;
      case 'invalid-multi-factor-session':
        return l10n.REDACTED_TOKEN;
      case 'second-factor-already-in-use':
        return l10n.REDACTED_TOKEN;
      case 'REDACTED_TOKEN':
        return l10n.REDACTED_TOKEN;
      case 'unsupported-first-factor':
        return l10n.authErrorUnsupportedFirstFactor;
      case 'email-change-needs-verification':
        return l10n.REDACTED_TOKEN;
      case 'phone-number-already-exists':
        return l10n.REDACTED_TOKEN;
      case 'invalid-password':
        return l10n.authErrorInvalidPassword;
      case 'invalid-id-token':
        return l10n.authErrorInvalidIdToken;
      case 'id-token-expired':
        return l10n.authErrorIdTokenExpired;
      case 'id-token-revoked':
        return l10n.authErrorIdTokenRevoked;
      case 'internal-error':
        return l10n.authErrorInternalError;
      case 'invalid-argument':
        return l10n.authErrorInvalidArgument;
      case 'invalid-claims':
        return l10n.authErrorInvalidClaims;
      case 'invalid-continue-uri':
        return l10n.authErrorInvalidContinueUri;
      case 'invalid-creation-time':
        return l10n.authErrorInvalidCreationTime;
      case 'invalid-disabled-field':
        return l10n.authErrorInvalidDisabledField;
      case 'invalid-display-name':
        return l10n.authErrorInvalidDisplayName;
      case 'invalid-dynamic-link-domain':
        return l10n.REDACTED_TOKEN;
      case 'invalid-email-verified':
        return l10n.authErrorInvalidEmailVerified;
      case 'invalid-hash-algorithm':
        return l10n.authErrorInvalidHashAlgorithm;
      case 'invalid-hash-block-size':
        return l10n.authErrorInvalidHashBlockSize;
      case 'invalid-hash-derived-key-length':
        return l10n.REDACTED_TOKEN;
      case 'invalid-hash-key':
        return l10n.authErrorInvalidHashKey;
      case 'invalid-hash-memory-cost':
        return l10n.authErrorInvalidHashMemoryCost;
      case 'invalid-hash-parallelization':
        return l10n.REDACTED_TOKEN;
      case 'invalid-hash-rounds':
        return l10n.authErrorInvalidHashRounds;
      case 'invalid-hash-salt-separator':
        return l10n.REDACTED_TOKEN;
      case 'invalid-last-sign-in-time':
        return l10n.authErrorInvalidLastSignInTime;
      case 'invalid-page-token':
        return l10n.authErrorInvalidPageToken;
      case 'invalid-provider-data':
        return l10n.authErrorInvalidProviderData;
      case 'invalid-provider-id':
        return l10n.authErrorInvalidProviderId;
      case 'invalid-session-cookie-duration':
        return l10n.REDACTED_TOKEN;
      case 'invalid-uid':
        return l10n.authErrorInvalidUid;
      case 'invalid-user-import':
        return l10n.authErrorInvalidUserImport;
      case 'maximum-user-count-exceeded':
        return l10n.REDACTED_TOKEN;
      case 'missing-android-pkg-name':
        return l10n.authErrorMissingAndroidPkgName;
      case 'missing-continue-uri':
        return l10n.authErrorMissingContinueUri;
      case 'missing-hash-algorithm':
        return l10n.authErrorMissingHashAlgorithm;
      case 'missing-ios-bundle-id':
        return l10n.authErrorMissingIosBundleId;
      case 'missing-uid':
        return l10n.authErrorMissingUid;
      case 'missing-oauth-client-secret':
        return l10n.REDACTED_TOKEN;
      case 'project-not-found':
        return l10n.authErrorProjectNotFound;
      case 'reserved-claims':
        return l10n.authErrorReservedClaims;
      case 'session-cookie-expired':
        return l10n.authErrorSessionCookieExpired;
      case 'session-cookie-revoked':
        return l10n.authErrorSessionCookieRevoked;
      case 'uid-already-exists':
        return l10n.authErrorUidAlreadyExists;
      case 'unauthorized-continue-uri':
        return l10n.REDACTED_TOKEN;
      default:
        return l10n.authErrorUnknown;
    }
  }

  /// Check if Firebase Auth error is a social account conflict
  bool isSocialAccountConflict(FirebaseAuthException e) => e.code == 'REDACTED_TOKEN' ||
        e.code == 'credential-already-in-use';
}

// Riverpod providers
final errorHandlingServiceProvider =
    Provider<ErrorHandlingService>((ref) => ErrorHandlingService());

final errorStateProvider = StateProvider<AppError?>((ref) => null);

// Error handling extension
extension ErrorHandlingExtension on WidgetRef {
  Future<void> handleError(
    final error,
    final StackTrace? stackTrace, {
    final ErrorType type = ErrorType.unknown,
    final ErrorSeverity severity = ErrorSeverity.medium,
    final Map<String, dynamic>? context,
  }) async {
    final service = read(errorHandlingServiceProvider);
    await service.handleError(
      error,
      stackTrace,
      type: type,
      severity: severity,
      context: context,
    );
  }
}
