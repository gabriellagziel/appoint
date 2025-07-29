import 'package:appoint/services/api/api_client.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  ErrorHandler._();
  static final ErrorHandler _instance = ErrorHandler._();
  static ErrorHandler get instance => _instance;

  // Handle API errors and show appropriate messages
  void handleApiError(error, BuildContext context) {
    if (error is ApiException) {
      _handleApiException(error, context);
    } else {
      _showGenericError(context, error.toString());
    }
  }

  void _handleApiException(ApiException exception, BuildContext context) {
    switch (exception.type) {
      case ApiExceptionType.timeout:
        _showErrorDialog(
          context,
          'Connection Timeout',
          'The request took too long to complete. Please check your internet connection and try again.',
          'Retry',
          () => _retryLastAction(context),
        );
      case ApiExceptionType.network:
        _showErrorDialog(
          context,
          'No Internet Connection',
          'Please check your internet connection and try again.',
          'Retry',
          () => _retryLastAction(context),
        );
      case ApiExceptionType.unauthorized:
        _showErrorDialog(
          context,
          'Session Expired',
          'Your session has expired. Please log in again.',
          'Login',
          () => _navigateToLogin(context),
        );
      case ApiExceptionType.forbidden:
        _showErrorDialog(
          context,
          'Access Denied',
          "You don't have permission to perform this action.",
          'OK',
          () => Navigator.of(context).pop(),
        );
      case ApiExceptionType.notFound:
        _showErrorDialog(
          context,
          'Not Found',
          'The requested resource was not found.',
          'OK',
          () => Navigator.of(context).pop(),
        );
      case ApiExceptionType.validation:
        _showValidationError(context, exception.validationErrors);
      case ApiExceptionType.server:
        _showErrorDialog(
          context,
          'Server Error',
          'Something went wrong on our end. Please try again later.',
          'Retry',
          () => _retryLastAction(context),
        );
      case ApiExceptionType.cancelled:
        // Don't show dialog for cancelled requests
        break;
      case ApiExceptionType.unknown:
        _showErrorDialog(
          context,
          'Unexpected Error',
          'An unexpected error occurred. Please try again.',
          'Retry',
          () => _retryLastAction(context),
        );
    }
  }

  void _showValidationError(
      BuildContext context, Map<String, List<String>>? errors) {
    if (errors == null || errors.isEmpty) {
      _showGenericError(context, 'Validation failed');
      return;
    }

    final errorMessages = <String>[];
    errors.forEach((field, messages) {
      errorMessages.addAll(messages);
    });

    _showErrorDialog(
      context,
      'Validation Error',
      errorMessages.join('\n'),
      'OK',
      () => Navigator.of(context).pop(),
    );
  }

  void _showErrorDialog(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    VoidCallback onPressed,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  void _showGenericError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _retryLastAction(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Implement retry mechanism
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retry functionality coming soon!')),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // Handle specific feature errors
  void handleBookingError(error, BuildContext context) {
    if (error is ApiException && error.type == ApiExceptionType.validation) {
      _showBookingValidationError(context, error.validationErrors);
    } else {
      handleApiError(error, context);
    }
  }

  void _showBookingValidationError(
      BuildContext context, Map<String, List<String>>? errors) {
    var message = 'Please fix the following errors:';

    if (errors != null) {
      if (errors.containsKey('startTime')) {
        message += '\n• Invalid start time';
      }
      if (errors.containsKey('endTime')) {
        message += '\n• Invalid end time';
      }
      if (errors.containsKey('serviceId')) {
        message += '\n• Service not available';
      }
      if (errors.containsKey('businessId')) {
        message += '\n• Business not available';
      }
    }

    _showErrorDialog(
      context,
      'Booking Error',
      message,
      'OK',
      () => Navigator.of(context).pop(),
    );
  }

  void handlePaymentError(error, BuildContext context) {
    if (error is ApiException && error.type == ApiExceptionType.validation) {
      _showPaymentValidationError(context, error.validationErrors);
    } else {
      handleApiError(error, context);
    }
  }

  void _showPaymentValidationError(
      BuildContext context, Map<String, List<String>>? errors) {
    var message = 'Payment failed. Please check:';

    if (errors != null) {
      if (errors.containsKey('cardNumber')) {
        message += '\n• Card number is invalid';
      }
      if (errors.containsKey('expiryDate')) {
        message += '\n• Expiry date is invalid';
      }
      if (errors.containsKey('cvv')) {
        message += '\n• CVV is invalid';
      }
      if (errors.containsKey('amount')) {
        message += '\n• Amount is invalid';
      }
    }

    _showErrorDialog(
      context,
      'Payment Error',
      message,
      'OK',
      () => Navigator.of(context).pop(),
    );
  }

  void handleAuthError(error, BuildContext context) {
    if (error is ApiException && error.type == ApiExceptionType.unauthorized) {
      _showAuthError(context,
          'Invalid credentials. Please check your email and password.');
    } else if (error is ApiException &&
        error.type == ApiExceptionType.validation) {
      _showAuthValidationError(context, error.validationErrors);
    } else {
      handleApiError(error, context);
    }
  }

  void _showAuthError(BuildContext context, String message) {
    _showErrorDialog(
      context,
      'Authentication Error',
      message,
      'OK',
      () => Navigator.of(context).pop(),
    );
  }

  void _showAuthValidationError(
      BuildContext context, Map<String, List<String>>? errors) {
    var message = 'Please fix the following errors:';

    if (errors != null) {
      if (errors.containsKey('email')) {
        message += '\n• Invalid email address';
      }
      if (errors.containsKey('password')) {
        message += '\n• Password must be at least 8 characters';
      }
      if (errors.containsKey('confirmPassword')) {
        message += '\n• Passwords do not match';
      }
    }

    _showErrorDialog(
      context,
      'Validation Error',
      message,
      'OK',
      () => Navigator.of(context).pop(),
    );
  }

  // Log errors for analytics
  void logError(error, {String? feature, Map<String, dynamic>? context}) {
    // TODO: Implement error logging to analytics service
    if (kDebugMode) {
      print('🚨 Error in $feature: $error');
      if (context != null) {
        print('Context: $context');
      }
    }
  }

  // Handle offline errors
  void handleOfflineError(BuildContext context) {
    _showErrorDialog(
      context,
      'No Internet Connection',
      'Please check your internet connection and try again.',
      'Retry',
      () => _retryLastAction(context),
    );
  }

  // Handle permission errors
  void handlePermissionError(BuildContext context, String permission) {
    _showErrorDialog(
      context,
      'Permission Required',
      'This feature requires $permission permission. Please enable it in your device settings.',
      'Settings',
      () => _openAppSettings(context),
      secondaryAction: 'Cancel',
      onSecondaryPressed: () => Navigator.of(context).pop(),
    );
  }

  void _openAppSettings(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Implement app settings navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please enable permissions in device settings')),
    );
  }

  void _showErrorDialog(
    BuildContext context,
    String title,
    String message,
    String primaryButtonText,
    VoidCallback onPrimaryPressed, {
    String? secondaryAction,
    VoidCallback? onSecondaryPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (secondaryAction != null)
            TextButton(
              onPressed:
                  onSecondaryPressed ?? () => Navigator.of(context).pop(),
              child: Text(secondaryAction),
            ),
          ElevatedButton(
            onPressed: onPrimaryPressed,
            child: Text(primaryButtonText),
          ),
        ],
      ),
    );
  }
}
