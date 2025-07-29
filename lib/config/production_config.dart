class ProductionConfig {
  // Environment settings
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const bool isProduction = environment == 'production';
  static const bool isStaging = environment == 'staging';
  static const bool isDevelopment = environment == 'development';

  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev-api.appoint.com/v1',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'wss://dev-ws.appoint.com',
  );

  // Firebase Configuration
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'appoint-dev',
  );

  // Stripe Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_your_stripe_key_here',
  );

  static const String stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'sk_test_your_stripe_secret_here',
  );

  // Analytics Configuration
  static const String analyticsEnabled = String.fromEnvironment(
    'ANALYTICS_ENABLED',
    defaultValue: 'true',
  );

  // Feature Flags
  static const Map<String, bool> featureFlags = {
    'messaging': true,
    'subscriptions': true,
    'rewards': true,
    'family': true,
    'business': true,
    'analytics': true,
    'notifications': true,
    'calendar': true,
    'search': true,
    'onboarding': true,
    'payments': true,
    'real_time': true,
  };

  // App Configuration
  static const String appName = 'APP-OINT';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Performance Configuration
  static const int apiTimeout = 30000; // 30 seconds
  static const int cacheTimeout = 300; // 5 minutes
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1 second

  // Security Configuration
  static const bool enableHttps = true;
  static const bool enableCertificatePinning = true;
  static const List<String> allowedOrigins = [
    'https://appoint.com',
    'https://www.appoint.com',
    'https://app.appoint.com',
  ];

  // Logging Configuration
  static const bool enableLogging = true;
  static const String logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'info',
  );

  // Error Reporting Configuration
  static const bool enableErrorReporting = true;
  static const String errorReportingUrl = String.fromEnvironment(
    'ERROR_REPORTING_URL',
    defaultValue: 'https://errors.appoint.com',
  );

  // Monitoring Configuration
  static const bool enablePerformanceMonitoring = true;
  static const String monitoringUrl = String.fromEnvironment(
    'MONITORING_URL',
    defaultValue: 'https://monitoring.appoint.com',
  );

  // CDN Configuration
  static const String cdnBaseUrl = String.fromEnvironment(
    'CDN_BASE_URL',
    defaultValue: 'https://cdn.appoint.com',
  );

  // Database Configuration
  static const String databaseUrl = String.fromEnvironment(
    'DATABASE_URL',
    defaultValue: 'https://dev-db.appoint.com',
  );

  // Cache Configuration
  static const int maxCacheSize = 100; // MB
  static const int maxCacheAge = 300; // 5 minutes

  // Rate Limiting Configuration
  static const int rateLimitRequests = 100;
  static const int rateLimitWindow = 60; // seconds

  // Notification Configuration
  static const bool enablePushNotifications = true;
  static const bool enableEmailNotifications = true;
  static const bool enableSmsNotifications = false;

  // Payment Configuration
  static const List<String> supportedCurrencies = ['USD', 'EUR', 'GBP'];
  static const String defaultCurrency = 'USD';
  static const List<String> supportedPaymentMethods = [
    'card',
    'paypal',
    'apple_pay',
    'google_pay',
  ];

  // Subscription Configuration
  static const Map<String, Map<String, dynamic>> subscriptionPlans = {
    'free': {
      'name': 'Free Plan',
      'price': 0.0,
      'currency': 'USD',
      'features': [
        'Basic booking',
        'Limited search',
        'Basic messaging',
      ],
    },
    'premium': {
      'name': 'Premium Plan',
      'price': 9.99,
      'currency': 'USD',
      'features': [
        'Unlimited booking',
        'Advanced search',
        'Priority messaging',
        'Rewards program',
        'Family coordination',
      ],
    },
    'business': {
      'name': 'Business Plan',
      'price': 29.99,
      'currency': 'USD',
      'features': [
        'All Premium features',
        'Business analytics',
        'Staff management',
        'Advanced scheduling',
        'Customer management',
      ],
    },
  };

  // Rewards Configuration
  static const int pointsPerBooking = 10;
  static const int pointsPerReferral = 50;
  static const int pointsPerReview = 25;
  static const int pointsPerSocialShare = 5;

  // Family Configuration
  static const int maxFamilyMembers = 10;
  static const int maxFamilyBookings = 50;

  // Business Configuration
  static const int maxBusinessStaff = 20;
  static const int maxBusinessClients = 1000;
  static const int maxBusinessBookings = 1000;

  // Search Configuration
  static const int maxSearchResults = 100;
  static const int searchDebounceMs = 300;
  static const double defaultSearchRadius = 25; // miles

  // Messaging Configuration
  static const int maxMessageLength = 1000;
  static const int maxFileSize = 10; // MB
  static const List<String> supportedFileTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf',
    'text/plain',
  ];

  // Calendar Configuration
  static const int maxCalendarEvents = 1000;
  static const int calendarSyncInterval = 300; // 5 minutes

  // Analytics Configuration
  static const bool enableUserAnalytics = true;
  static const bool enableBusinessAnalytics = true;
  static const bool enablePerformanceAnalytics = true;

  // Testing Configuration
  static const bool enableTestMode = false;
  static const String testApiUrl = 'https://test-api.appoint.com/v1';

  // Development Configuration
  static const bool enableHotReload = true;
  static const bool enableDebugMode = !isProduction;

  // Get configuration value
  static T getValue<T>(String key, T defaultValue) =>
      String.fromEnvironment(key, defaultValue: defaultValue.toString()) as T;

  // Check if feature is enabled
  static bool isFeatureEnabled(String feature) =>
      featureFlags[feature] ?? false;

  // Get subscription plan
  static Map<String, dynamic>? getSubscriptionPlan(String planId) =>
      subscriptionPlans[planId];

  // Get supported payment methods for environment
  static List<String> getSupportedPaymentMethods() {
    if (isProduction) {
      return supportedPaymentMethods;
    } else {
      return ['card', 'paypal']; // Limited for testing
    }
  }

  // Get API timeout based on environment
  static int getApiTimeout() {
    if (isProduction) {
      return apiTimeout;
    } else {
      return apiTimeout * 2; // Longer timeout for development
    }
  }

  // Get cache timeout based on environment
  static int getCacheTimeout() {
    if (isProduction) {
      return cacheTimeout;
    } else {
      return cacheTimeout ~/ 2; // Shorter cache for development
    }
  }

  // Get log level based on environment
  static String getLogLevel() {
    if (isProduction) {
      return 'warn';
    } else {
      return 'debug';
    }
  }

  // Get analytics enabled based on environment
  static bool getAnalyticsEnabled() {
    if (isProduction) {
      return analyticsEnabled == 'true';
    } else {
      return false; // Disable analytics in development
    }
  }

  // Get error reporting enabled based on environment
  static bool getErrorReportingEnabled() {
    if (isProduction) {
      return enableErrorReporting;
    } else {
      return false; // Disable error reporting in development
    }
  }

  // Get performance monitoring enabled based on environment
  static bool getPerformanceMonitoringEnabled() {
    if (isProduction) {
      return enablePerformanceMonitoring;
    } else {
      return false; // Disable performance monitoring in development
    }
  }

  // Get push notifications enabled based on environment
  static bool getPushNotificationsEnabled() {
    if (isProduction) {
      return enablePushNotifications;
    } else {
      return true; // Enable for testing
    }
  }

  // Get test mode enabled
  static bool getTestModeEnabled() => enableTestMode || !isProduction;

  // Get debug mode enabled
  static bool getDebugModeEnabled() => enableDebugMode || !isProduction;

  // Get hot reload enabled
  static bool getHotReloadEnabled() => enableHotReload && !isProduction;
}
