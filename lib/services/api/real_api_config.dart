class ApiConfig {
  // Production API endpoints
  static const String productionBaseUrl = 'https://api.appoint.com/v1';
  static const String stagingBaseUrl = 'https://staging-api.appoint.com/v1';
  static const String developmentBaseUrl = 'https://dev-api.appoint.com/v1';

  // WebSocket endpoints
  static const String productionWsUrl = 'wss://ws.appoint.com';
  static const String stagingWsUrl = 'wss://staging-ws.appoint.com';
  static const String developmentWsUrl = 'wss://dev-ws.appoint.com';

  // CDN endpoints
  static const String productionCdnUrl = 'https://cdn.appoint.com';
  static const String stagingCdnUrl = 'https://staging-cdn.appoint.com';
  static const String developmentCdnUrl = 'https://dev-cdn.appoint.com';

  // Payment endpoints
  static const String stripeApiUrl = 'https://api.stripe.com/v1';
  static const String paypalApiUrl = 'https://api-m.paypal.com/v1';

  // Analytics endpoints
  static const String analyticsUrl = 'https://analytics.appoint.com';

  // Get base URL based on environment
  static String getBaseUrl(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return productionBaseUrl;
      case 'staging':
        return stagingBaseUrl;
      case 'development':
        return developmentBaseUrl;
      default:
        return developmentBaseUrl;
    }
  }

  // Get WebSocket URL based on environment
  static String getWsUrl(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return productionWsUrl;
      case 'staging':
        return stagingWsUrl;
      case 'development':
        return developmentWsUrl;
      default:
        return developmentWsUrl;
    }
  }

  // Get CDN URL based on environment
  static String getCdnUrl(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return productionCdnUrl;
      case 'staging':
        return stagingCdnUrl;
      case 'development':
        return developmentCdnUrl;
      default:
        return developmentCdnUrl;
    }
  }

  // API endpoints
  static const Map<String, String> endpoints = {
    // Authentication
    'login': '/auth/login',
    'register': '/auth/register',
    'refresh': '/auth/refresh',
    'logout': '/auth/logout',
    'forgotPassword': '/auth/forgot-password',
    'resetPassword': '/auth/reset-password',

    // User management
    'profile': '/user/profile',
    'updateProfile': '/user/profile',
    'changePassword': '/user/change-password',
    'deleteAccount': '/user/delete-account',

    // Booking
    'bookings': '/bookings',
    'booking': '/bookings/{id}',
    'availableSlots': '/bookings/available-slots',
    'bookingHistory': '/bookings/history',
    'upcomingBookings': '/bookings/upcoming',
    'cancelBooking': '/bookings/{id}/cancel',
    'rescheduleBooking': '/bookings/{id}/reschedule',
    'rateBooking': '/bookings/{id}/rate',

    // Search
    'searchServices': '/search/services',
    'searchBusinesses': '/search/businesses',
    'searchProfessionals': '/search/professionals',
    'searchSuggestions': '/search/suggestions',
    'popularSearches': '/search/popular',
    'searchCategories': '/search/categories',
    'nearbyServices': '/search/nearby/services',
    'trendingSearches': '/search/trending',
    'searchHistory': '/search/history',

    // Messaging
    'chats': '/chats',
    'chat': '/chats/{id}',
    'chatMessages': '/chats/{id}/messages',
    'sendMessage': '/chats/{id}/messages',
    'markRead': '/chats/{id}/read',
    'deleteMessage': '/chats/{id}/messages/{messageId}',
    'editMessage': '/chats/{id}/messages/{messageId}',
    'sendFile': '/chats/{id}/messages/file',
    'unreadCount': '/chats/unread-count',
    'searchMessages': '/messages/search',
    'messageReactions': '/chats/{id}/messages/{messageId}/reactions',
    'addReaction': '/chats/{id}/messages/{messageId}/reactions',
    'removeReaction': '/chats/{id}/messages/{messageId}/reactions/{reaction}',
    'chatParticipants': '/chats/{id}/participants',
    'addParticipant': '/chats/{id}/participants',
    'removeParticipant': '/chats/{id}/participants/{participantId}',
    'leaveChat': '/chats/{id}/leave',
    'archiveChat': '/chats/{id}/archive',
    'unarchiveChat': '/chats/{id}/unarchive',
    'archivedChats': '/chats/archived',

    // Subscriptions
    'subscriptionPlans': '/subscriptions/plans',
    'currentSubscription': '/subscriptions/current',
    'subscribe': '/subscriptions',
    'cancelSubscription': '/subscriptions/cancel',
    'reactivateSubscription': '/subscriptions/reactivate',
    'upgradeSubscription': '/subscriptions/upgrade',
    'downgradeSubscription': '/subscriptions/downgrade',
    'subscriptionUsage': '/subscriptions/usage',
    'upcomingInvoice': '/subscriptions/upcoming-invoice',

    // Payments
    'paymentMethods': '/payments/methods',
    'addPaymentMethod': '/payments/methods',
    'updatePaymentMethod': '/payments/methods/{id}',
    'removePaymentMethod': '/payments/methods/{id}',
    'setDefaultPaymentMethod': '/payments/methods/{id}/default',
    'billingHistory': '/payments/history',
    'invoice': '/payments/invoices/{id}',
    'downloadInvoice': '/payments/invoices/{id}/download',
    'processPayment': '/payments/process',
    'paymentStatus': '/payments/{id}',
    'refundPayment': '/payments/{id}/refund',

    // Rewards
    'rewards': '/rewards',
    'reward': '/rewards/{id}',
    'earnPoints': '/rewards/earn',
    'redeemReward': '/rewards/{id}/redeem',
    'pointsHistory': '/rewards/points/history',
    'availableRewards': '/rewards/available',
    'rewardCategories': '/rewards/categories',

    // Family
    'family': '/family',
    'familyMembers': '/family/members',
    'addFamilyMember': '/family/members',
    'removeFamilyMember': '/family/members/{id}',
    'familyInvitations': '/family/invitations',
    'sendInvitation': '/family/invitations',
    'acceptInvitation': '/family/invitations/{id}/accept',
    'declineInvitation': '/family/invitations/{id}/decline',
    'familyBookings': '/family/bookings',
    'familyCalendar': '/family/calendar',
    'familyPermissions': '/family/permissions',

    // Business
    'business': '/business',
    'businessProfile': '/business/profile',
    'businessServices': '/business/services',
    'businessBookings': '/business/bookings',
    'businessAnalytics': '/business/analytics',
    'businessClients': '/business/clients',
    'businessStaff': '/business/staff',
    'businessSettings': '/business/settings',
    'businessAvailability': '/business/availability',
    'businessInvoices': '/business/invoices',
    'businessMessages': '/business/messages',

    // Notifications
    'notifications': '/notifications',
    'notification': '/notifications/{id}',
    'markAllRead': '/notifications/read-all',
    'deleteNotification': '/notifications/{id}',
    'notificationPreferences': '/notifications/preferences',

    // Calendar
    'calendar': '/calendar',
    'calendarEvents': '/calendar/events',
    'calendarEvent': '/calendar/events/{id}',
    'addEvent': '/calendar/events',
    'updateEvent': '/calendar/events/{id}',
    'deleteEvent': '/calendar/events/{id}',
    'calendarSync': '/calendar/sync',
    'calendarShare': '/calendar/share',

    // Settings
    'settings': '/settings',
    'userSettings': '/settings/user',
    'appSettings': '/settings/app',
    'privacySettings': '/settings/privacy',
    'securitySettings': '/settings/security',
    'languageSettings': '/settings/language',
    'themeSettings': '/settings/theme',

    // Analytics
    'analytics': '/analytics',
    'userAnalytics': '/analytics/user',
    'bookingAnalytics': '/analytics/bookings',
    'revenueAnalytics': '/analytics/revenue',
    'userBehavior': '/analytics/behavior',
    'performanceMetrics': '/analytics/performance',

    // File upload
    'uploadFile': '/upload',
    'uploadImage': '/upload/image',
    'uploadDocument': '/upload/document',
    'uploadAvatar': '/upload/avatar',

    // Health check
    'health': '/health',
    'status': '/status',
  };

  // Get endpoint URL
  static String getEndpoint(String key, {Map<String, String>? params}) {
    var endpoint = endpoints[key] ?? '/$key';

    if (params != null) {
      params.forEach((key, value) {
        endpoint = endpoint.replaceAll('{$key}', value);
      });
    }

    return endpoint;
  }

  // API versioning
  static const String apiVersion = 'v1';
  static const String apiVersionHeader = 'X-API-Version';

  // Rate limiting
  static const int rateLimitRequests = 100;
  static const int rateLimitWindow = 60; // seconds

  // Timeout settings
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Retry settings
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1 second

  // Cache settings
  static const int cacheMaxAge = 300; // 5 minutes
  static const int cacheMaxSize = 100; // MB

  // Security settings
  static const bool enableHttps = true;
  static const bool enableCertificatePinning = true;
  static const List<String> allowedOrigins = [
    'https://appoint.com',
    'https://www.appoint.com',
    'https://app.appoint.com',
  ];

  // Feature flags
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
  };

  // Check if feature is enabled
  static bool isFeatureEnabled(String feature) =>
      featureFlags[feature] ?? false;
}
