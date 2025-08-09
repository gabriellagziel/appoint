import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentService {
  static const bool _useFirestore = true; // TODO: Read from environment
  static const bool _usePushNotifications = true; // TODO: Read from environment
  static const bool _useAnalytics = true; // TODO: Read from environment

  /// Check if Firestore should be used
  static bool get useFirestore => _useFirestore;

  /// Check if push notifications should be used
  static bool get usePushNotifications => _usePushNotifications;

  /// Check if analytics should be used
  static bool get useAnalytics => _useAnalytics;

  /// Get environment name
  static String get environment {
    // TODO: Read from environment variables
    return 'development';
  }

  /// Check if running in production
  static bool get isProduction => environment == 'production';

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';

  /// Get API base URL
  static String get apiBaseUrl {
    if (isProduction) {
      return 'https://api.app-oint.com';
    } else {
      return 'https://dev-api.app-oint.com';
    }
  }

  /// Get web app URL
  static String get webAppUrl {
    if (isProduction) {
      return 'https://app-oint.com';
    } else {
      return 'https://dev.app-oint.com';
    }
  }
}

/// Riverpod provider for environment service
final environmentServiceProvider = Provider<EnvironmentService>((ref) {
  return EnvironmentService();
});
