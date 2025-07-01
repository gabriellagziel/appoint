import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
  final String message;
  final String? code;
  final ErrorType type;
  final ErrorSeverity severity;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;

  AppError({
    required this.message,
    this.code,
    required this.type,
    required this.severity,
    this.stackTrace,
    this.context,
  });

  @override
  String toString() {
    return 'AppError: $message (${type.name}, ${severity.name})';
  }
}

class ErrorHandlingService {
  static final ErrorHandlingService _instance =
      ErrorHandlingService._internal();
  factory ErrorHandlingService() => _instance;
  ErrorHandlingService._internal();

  /// Handle and log errors
  Future<void> handleError(
    final dynamic error,
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
      // Removed debug print: print('🚨 Error: ${appError.message}');
      // Removed debug print: print('Type: ${appError.type.name}');
      // Removed debug print: print('Severity: ${appError.severity.name}');
      if (context != null) {
        // Removed debug print: print('Context: $context');
      }
      if (stackTrace != null) {
        // Removed debug print: print('StackTrace: $stackTrace');
      }
    }

    // Send to Crashlytics in production
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: appError.message,
        information: context?.entries
                .map((final e) => '${e.key}: ${e.value}')
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
  Future<void> _handleCriticalError(final AppError error) async {
    // Log critical error
    // Removed debug print: print('🚨 CRITICAL ERROR: ${error.message}');

    // In a real app, you might:
    // - Show a critical error screen
    // - Send emergency notifications
    // - Restart the app
    // - Clear corrupted data
  }

  /// Handle network errors
  Future<void> handleNetworkError(
      final dynamic error, final StackTrace? stackTrace) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.network,
      severity: ErrorSeverity.medium,
      context: {'operation': 'network_request'},
    );
  }

  /// Handle authentication errors
  Future<void> handleAuthError(
      final dynamic error, final StackTrace? stackTrace) async {
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
      final dynamic error, final StackTrace? stackTrace) async {
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
      final dynamic error, final StackTrace? stackTrace) async {
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
      final dynamic error, final StackTrace? stackTrace) async {
    await handleError(
      error,
      stackTrace,
      type: ErrorType.file,
      severity: ErrorSeverity.medium,
      context: {'operation': 'file_operation'},
    );
  }

  /// Get user-friendly error message
  String getUserFriendlyMessage(final AppError error) {
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
  bool isRecoverable(final AppError error) {
    return error.severity != ErrorSeverity.critical;
  }

  /// Get error recovery suggestion
  String getRecoverySuggestion(final AppError error) {
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
}

// Riverpod providers
final errorHandlingServiceProvider =
    Provider<ErrorHandlingService>((final ref) {
  return ErrorHandlingService();
});

final errorStateProvider = StateProvider<AppError?>((final ref) {
  return null;
});

// Error handling extension
extension ErrorHandlingExtension on WidgetRef {
  Future<void> handleError(
    final dynamic error,
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
