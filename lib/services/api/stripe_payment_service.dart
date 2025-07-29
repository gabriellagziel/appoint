import 'package:appoint/models/payment.dart';
import 'package:appoint/models/subscription.dart';
import 'package:appoint/services/api/api_client.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart';

class StripePaymentService {
  StripePaymentService._();
  static final StripePaymentService _instance = StripePaymentService._();
  static StripePaymentService get instance => _instance;

  // Initialize Stripe
  Future<void> initialize() async {
    // TODO: Replace with your Stripe publishable key
    await Stripe.instance.initialise(
      publishableKey: 'pk_test_your_stripe_publishable_key_here',
    );
  }

  // Create payment intent
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/payments/create-intent',
        data: {
          'amount': (amount * 100).round(), // Convert to cents
          'currency': currency,
          if (description != null) 'description': description,
          if (metadata != null) 'metadata': metadata,
        },
      );

      return PaymentIntent.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Process payment with card
  Future<PaymentResult> processPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      // Confirm payment with Stripe
      final paymentResult = await Stripe.instance.confirmPayment(
        paymentIntentId,
        const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(),
          ),
        ),
      );

      if (paymentResult.status == PaymentIntentsStatus.Succeeded) {
        // Update payment status on backend
        await ApiClient.instance.post<Map<String, dynamic>>(
          '/payments/confirm',
          data: {
            'paymentIntentId': paymentIntentId,
            'status': 'succeeded',
          },
        );

        return PaymentResult(
          success: true,
          paymentId: paymentResult.paymentIntentId,
          status: 'succeeded',
        );
      } else {
        return PaymentResult(
          success: false,
          error: paymentResult.error?.message ?? 'Payment failed',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  // Create subscription
  Future<Subscription> createSubscription({
    required String planId,
    required String paymentMethodId,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/subscriptions/create',
        data: {
          'planId': planId,
          'paymentMethodId': paymentMethodId,
          if (customerId != null) 'customerId': customerId,
          if (metadata != null) 'metadata': metadata,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update subscription
  Future<Subscription> updateSubscription({
    required String subscriptionId,
    String? planId,
    String? paymentMethodId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/subscriptions/$subscriptionId',
        data: {
          if (planId != null) 'planId': planId,
          if (paymentMethodId != null) 'paymentMethodId': paymentMethodId,
          if (metadata != null) 'metadata': metadata,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription({
    required String subscriptionId,
    bool? atPeriodEnd,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/subscriptions/$subscriptionId/cancel',
        data: {
          if (atPeriodEnd != null) 'atPeriodEnd': atPeriodEnd,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Create customer
  Future<StripeCustomer> createCustomer({
    required String email,
    String? name,
    String? phone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/customers',
        data: {
          'email': email,
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (metadata != null) 'metadata': metadata,
        },
      );

      return StripeCustomer.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Add payment method
  Future<PaymentMethod> addPaymentMethod({
    required String customerId,
    required String paymentMethodId,
    bool? setAsDefault,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/customers/$customerId/payment-methods',
        data: {
          'paymentMethodId': paymentMethodId,
          if (setAsDefault != null) 'setAsDefault': setAsDefault,
        },
      );

      return PaymentMethod.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Remove payment method
  Future<void> removePaymentMethod({
    required String customerId,
    required String paymentMethodId,
  }) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/customers/$customerId/payment-methods/$paymentMethodId',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Set default payment method
  Future<void> setDefaultPaymentMethod({
    required String customerId,
    required String paymentMethodId,
  }) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/customers/$customerId/payment-methods/$paymentMethodId/default',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get customer payment methods
  Future<List<PaymentMethod>> getCustomerPaymentMethods(
      String customerId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/customers/$customerId/payment-methods',
      );

      final methods = response['methods'] as List;
      return methods.map((method) => PaymentMethod.fromJson(method)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create setup intent for adding payment methods
  Future<SetupIntent> createSetupIntent({
    required String customerId,
    String? paymentMethodType,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/setup-intents',
        data: {
          'customerId': customerId,
          if (paymentMethodType != null) 'paymentMethodType': paymentMethodType,
        },
      );

      return SetupIntent.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Confirm setup intent
  Future<SetupIntentResult> confirmSetupIntent({
    required String setupIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final result = await Stripe.instance.confirmSetupIntent(
        setupIntentId,
        const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(),
          ),
        ),
      );

      if (result.status == SetupIntentsStatus.Succeeded) {
        return SetupIntentResult(
          success: true,
          setupIntentId: result.setupIntentId,
          status: 'succeeded',
        );
      } else {
        return SetupIntentResult(
          success: false,
          error: result.error?.message ?? 'Setup failed',
        );
      }
    } catch (e) {
      return SetupIntentResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  // Process refund
  Future<Refund> processRefund({
    required String paymentId,
    double? amount,
    String? reason,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/payments/$paymentId/refund',
        data: {
          if (amount != null) 'amount': (amount * 100).round(),
          if (reason != null) 'reason': reason,
        },
      );

      return Refund.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get payment history
  Future<List<Payment>> getPaymentHistory({
    String? customerId,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (customerId != null) queryParams['customerId'] = customerId;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/payments/history',
        queryParameters: queryParams,
      );

      final payments = response['payments'] as List;
      return payments.map(Payment.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }
}

class PaymentResult {
  const PaymentResult({
    required this.success,
    this.paymentId,
    this.status,
    this.error,
  });

  final bool success;
  final String? paymentId;
  final String? status;
  final String? error;
}

class SetupIntentResult {
  const SetupIntentResult({
    required this.success,
    this.setupIntentId,
    this.status,
    this.error,
  });

  final bool success;
  final String? setupIntentId;
  final String? status;
  final String? error;
}

class StripeCustomer {
  const StripeCustomer({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.metadata,
  });

  factory StripeCustomer.fromJson(Map<String, dynamic> json) => StripeCustomer(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  final String id;
  final String email;
  final String? name;
  final String? phone;
  final Map<String, dynamic>? metadata;
}

class SetupIntent {
  const SetupIntent({
    required this.id,
    required this.clientSecret,
    required this.status,
  });

  factory SetupIntent.fromJson(Map<String, dynamic> json) => SetupIntent(
        id: json['id'] as String,
        clientSecret: json['client_secret'] as String,
        status: json['status'] as String,
      );

  final String id;
  final String clientSecret;
  final String status;
}

class Refund {
  const Refund({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.reason,
  });

  factory Refund.fromJson(Map<String, dynamic> json) => Refund(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble() / 100, // Convert from cents
        currency: json['currency'] as String,
        status: json['status'] as String,
        reason: json['reason'] as String?,
      );

  final String id;
  final double amount;
  final String currency;
  final String status;
  final String? reason;
}
