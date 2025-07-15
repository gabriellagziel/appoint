import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// Service for tracking custom analytics events throughout the app
class AnalyticsService {
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();
  static AnalyticsService _instance = AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebasePerformance _performance = FirebasePerformance.instance;

  // MARK: - User Properties

  /// Set user properties for analytics
  Future<void> setUserProperties({
    required final String userId,
    final String? userType,
    final String? subscriptionTier,
    final String? country,
    final String? language,
  }) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_type', value: userType);
    await _analytics.setUserProperty(
        name: 'subscription_tier', value: subscriptionTier,);
    await _analytics.setUserProperty(name: 'country', value: country);
    await _analytics.setUserProperty(name: 'language', value: language);
  }

  // MARK: - Onboarding Events

  /// Track app launch
  Future<void> trackAppLaunch() async {
    await _analytics.logEvent(name: 'app_launch');
  }

  /// Track onboarding start
  Future<void> trackOnboardingStart() async {
    await _analytics.logEvent(name: 'onboarding_start');
  }

  /// Track onboarding step completion
  Future<void> trackOnboardingStep({
    required final String stepName,
    required final int stepNumber,
    required final int totalSteps,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_step_complete',
      parameters: {
        'step_name': stepName,
        'step_number': stepNumber,
        'total_steps': totalSteps,
        ...?parameters,
      },
    );
  }

  /// Track onboarding completion
  Future<void> trackOnboardingComplete({
    required final String userType,
    required final int totalTimeSeconds,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_complete',
      parameters: {
        'user_type': userType,
        'total_time_seconds': totalTimeSeconds,
        ...?parameters,
      },
    );
  }

  /// Track account creation
  Future<void> trackAccountCreation({
    required final String accountType,
    required final String signupMethod,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'account_creation',
      parameters: {
        'account_type': accountType,
        'signup_method': signupMethod,
        ...?parameters,
      },
    );
  }

  // MARK: - Booking Events

  /// Track booking flow start
  Future<void> trackBookingStart({
    required final String serviceType,
    required final String providerId,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'booking_start',
      parameters: {
        'service_type': serviceType,
        'provider_id': providerId,
        ...?parameters,
      },
    );
  }

  /// Track service selection
  Future<void> trackServiceSelection({
    required final String serviceId,
    required final String serviceName,
    required final double servicePrice,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'service_selection',
      parameters: {
        'service_id': serviceId,
        'service_name': serviceName,
        'service_price': servicePrice,
        ...?parameters,
      },
    );
  }

  /// Track date/time selection
  Future<void> trackDateTimeSelection({
    required final String selectedDate,
    required final String selectedTime,
    required final String timeSlot,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'datetime_selection',
      parameters: {
        'selected_date': selectedDate,
        'selected_time': selectedTime,
        'time_slot': timeSlot,
        ...?parameters,
      },
    );
  }

  /// Track booking confirmation
  Future<void> trackBookingConfirmation({
    required final String bookingId,
    required final String serviceType,
    required final double totalAmount,
    required final String paymentMethod,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'booking_confirmation',
      parameters: {
        'booking_id': bookingId,
        'service_type': serviceType,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        ...?parameters,
      },
    );
  }

  /// Track booking cancellation
  Future<void> trackBookingCancellation({
    required final String bookingId,
    required final String reason,
    required final int hoursBeforeAppointment,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'booking_cancellation',
      parameters: {
        'booking_id': bookingId,
        'cancellation_reason': reason,
        'hours_before_appointment': hoursBeforeAppointment,
        ...?parameters,
      },
    );
  }

  /// Track booking reschedule
  Future<void> trackBookingReschedule({
    required final String bookingId,
    required final String oldDateTime,
    required final String newDateTime,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'booking_reschedule',
      parameters: {
        'booking_id': bookingId,
        'old_datetime': oldDateTime,
        'new_datetime': newDateTime,
        ...?parameters,
      },
    );
  }

  // MARK: - Payment Events

  /// Track payment initiation
  Future<void> trackPaymentInitiated({
    required final String bookingId,
    required final double amount,
    required final String currency,
    required final String paymentMethod,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'payment_initiated',
      parameters: {
        'booking_id': bookingId,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
        ...?parameters,
      },
    );
  }

  /// Track payment success
  Future<void> trackPaymentSuccess({
    required final String bookingId,
    required final double amount,
    required final String paymentMethod,
    required final String transactionId,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'payment_success',
      parameters: {
        'booking_id': bookingId,
        'amount': amount,
        'payment_method': paymentMethod,
        'transaction_id': transactionId,
        ...?parameters,
      },
    );
  }

  /// Track payment failure
  Future<void> trackPaymentFailure({
    required final String bookingId,
    required final String errorCode,
    required final String errorMessage,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'payment_failure',
      parameters: {
        'booking_id': bookingId,
        'error_code': errorCode,
        'error_message': errorMessage,
        ...?parameters,
      },
    );
  }

  // MARK: - Feature Usage Events

  /// Track feature usage
  Future<void> trackFeatureUsage({
    required final String featureName,
    required final String screenName,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'feature_usage',
      parameters: {
        'feature_name': featureName,
        'screen_name': screenName,
        ...?parameters,
      },
    );
  }

  /// Track search events
  Future<void> trackSearch({
    required final String searchTerm,
    required final String searchType,
    required final int resultsCount,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        'search_type': searchType,
        'results_count': resultsCount,
        ...?parameters,
      },
    );
  }

  /// Track filter usage
  Future<void> trackFilterUsage({
    required final String filterType,
    required final String filterValue,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'filter_usage',
      parameters: {
        'filter_type': filterType,
        'filter_value': filterValue,
        ...?parameters,
      },
    );
  }

  // MARK: - Performance Tracking

  /// Start a custom trace for performance monitoring
  Trace startTrace(String traceName) => _performance.newTrace(traceName);

  /// Start a network request trace
  HttpMetric startNetworkTrace(String url, final String method) => _performance.newHttpMetric(
        url,
        HttpMethod.values.firstWhere(
          (e) =>
              e.toString().split('.').last.toUpperCase() ==
              method.toUpperCase(),
        ),);

  // MARK: - Error Tracking

  /// Track custom errors
  Future<void> trackError({
    required final String errorType,
    required final String errorMessage,
    final String? screenName,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'custom_error',
      parameters: <String, Object>{
        'error_type': errorType,
        'error_message': errorMessage,
        if (screenName != null) 'screen_name': screenName,
        ...?parameters,
      },
    );
  }

  // MARK: - Engagement Events

  /// Track screen view
  Future<void> trackScreenView({
    required final String screenName,
    final String? screenClass,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Track button click
  Future<void> trackButtonClick({
    required final String buttonName,
    required final String screenName,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        'screen_name': screenName,
        ...?parameters,
      },
    );
  }

  // MARK: - Generic Event Logging Methods

  /// Generic event logging method - use this for any custom events
  static Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    await _instance._analytics.logEvent(name: name, parameters: params?.cast<String, Object>());
  }

  /// Generic screen view logging method - use this for tracking screen views
  static Future<void> logScreenView(String screenName) async {
    await _instance._analytics.logScreenView(screenName: screenName);
  }

  // MARK: - Business Events

  /// Track revenue events
  Future<void> trackRevenue({
    required final double value,
    required final String currency,
    required final String productId,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'purchase',
      parameters: {
        'value': value,
        'currency': currency,
        'product_id': productId,
        ...?parameters,
      },
    );
  }

  /// Track subscription events
  Future<void> trackSubscription({
    required final String subscriptionTier,
    required final double price,
    required final String billingPeriod,
    final Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'subscription',
      parameters: {
        'subscription_tier': subscriptionTier,
        'price': price,
        'billing_period': billingPeriod,
        ...?parameters,
      },
    );
  }
}
