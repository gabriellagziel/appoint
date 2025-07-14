import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/foundation.dart'; // Unused

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._();
  static AnalyticsService get instance => _instance;
  
  AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Initialize analytics
  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    await _analytics.setUserId(id: 'user_123'); // TODO: Get real user ID
  }

  // Track screen views
  Future<void> trackScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // Track user actions
  Future<void> trackUserAction({
    required String action,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: action,
      parameters: parameters,
    );
  }

  // Track booking events
  Future<void> trackBooking({
    required String serviceId,
    required String businessId,
    required double amount,
    String? currency,
  }) async {
    await _analytics.logEvent(
      name: 'booking_created',
      parameters: {
        'service_id': serviceId,
        'business_id': businessId,
        'amount': amount,
        'currency': currency ?? 'USD',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track search events
  Future<void> trackSearch({
    required String query,
    String? category,
    String? location,
    int? resultsCount,
  }) async {
    await _analytics.logEvent(
      name: 'search_performed',
      parameters: {
        'query': query,
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (resultsCount != null) 'results_count': resultsCount,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track subscription events
  Future<void> trackSubscription({
    required String planId,
    required double amount,
    String? currency,
  }) async {
    await _analytics.logEvent(
      name: 'subscription_started',
      parameters: {
        'plan_id': planId,
        'amount': amount,
        'currency': currency ?? 'USD',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track messaging events
  Future<void> trackMessage({
    required String chatId,
    required String messageType,
    int? messageLength,
  }) async {
    await _analytics.logEvent(
      name: 'message_sent',
      parameters: {
        'chat_id': chatId,
        'message_type': messageType,
        if (messageLength != null) 'message_length': messageLength,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track rewards events
  Future<void> trackRewardEarned({
    required int points,
    required String source,
  }) async {
    await _analytics.logEvent(
      name: 'reward_earned',
      parameters: {
        'points': points,
        'source': source,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track onboarding events
  Future<void> trackOnboardingStep({
    required String step,
    required int stepNumber,
    int? totalSteps,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_step_completed',
      parameters: {
        'step': step,
        'step_number': stepNumber,
        if (totalSteps != null) 'total_steps': totalSteps,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track error events
  Future<void> trackError({
    required String error,
    required String feature,
    Map<String, dynamic>? context,
  }) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error': error,
        'feature': feature,
        if (context != null) 'context': context.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track performance events
  Future<void> trackPerformance({
    required String metric,
    required double value,
    String? unit,
  }) async {
    await _analytics.logEvent(
      name: 'performance_metric',
      parameters: {
        'metric': metric,
        'value': value,
        if (unit != null) 'unit': unit,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track user engagement
  Future<void> trackEngagement({
    required String action,
    required String screen,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'action': action,
        'screen': screen,
        if (parameters != null) ...parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track family coordination events
  Future<void> trackFamilyAction({
    required String action,
    required String memberId,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'family_action',
      parameters: {
        'action': action,
        'member_id': memberId,
        if (parameters != null) ...parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track business events
  Future<void> trackBusinessAction({
    required String action,
    required String businessId,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'business_action',
      parameters: {
        'action': action,
        'business_id': businessId,
        if (parameters != null) ...parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Set user properties
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Set user properties for user type
  Future<void> setUserType(String userType) async {
    await setUserProperty(name: 'user_type', value: userType);
  }

  // Set user properties for subscription status
  Future<void> setSubscriptionStatus(String status) async {
    await setUserProperty(name: 'subscription_status', value: status);
  }

  // Set user properties for family size
  Future<void> setFamilySize(int size) async {
    await setUserProperty(name: 'family_size', value: size.toString());
  }

  // Track conversion events
  Future<void> trackConversion({
    required String conversionType,
    required double value,
    String? currency,
  }) async {
    await _analytics.logEvent(
      name: 'conversion',
      parameters: {
        'conversion_type': conversionType,
        'value': value,
        'currency': currency ?? 'USD',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track feature usage
  Future<void> trackFeatureUsage({
    required String feature,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'feature_used',
      parameters: {
        'feature': feature,
        if (parameters != null) ...parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track app lifecycle events
  Future<void> trackAppLifecycle({
    required String event,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'app_lifecycle',
      parameters: {
        'event': event,
        if (parameters != null) ...parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track network events
  Future<void> trackNetworkEvent({
    required String event,
    required String endpoint,
    int? responseTime,
    int? statusCode,
  }) async {
    await _analytics.logEvent(
      name: 'network_event',
      parameters: {
        'event': event,
        'endpoint': endpoint,
        if (responseTime != null) 'response_time': responseTime,
        if (statusCode != null) 'status_code': statusCode,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track device information
  Future<void> trackDeviceInfo({
    required String platform,
    required String version,
    String? deviceModel,
  }) async {
    await _analytics.logEvent(
      name: 'device_info',
      parameters: {
        'platform': platform,
        'version': version,
        if (deviceModel != null) 'device_model': deviceModel,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track session events
  Future<void> trackSession({
    required String event,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'session_event',
      parameters: {
        'event': event,
        if (parameters != null) ...parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Track custom events
  Future<void> trackCustomEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Get analytics instance for direct access
  FirebaseAnalytics get analytics => _analytics;
} 