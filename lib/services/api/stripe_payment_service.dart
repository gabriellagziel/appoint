import 'package:appoint/features/subscriptions/models/subscription.dart';
import 'package:appoint/services/api/api_client.dart';
import 'package:flutter/material.dart';

class StripePaymentService {
  StripePaymentService._();
  static final StripePaymentService _instance = StripePaymentService._();
  static StripePaymentService get instance => _instance;

  // TODO: Replace with your Stripe publishable key
  static const String _publishableKey = 'pk_test_your_stripe_key_here';

  // Initialize Stripe
  Future<void> initialize() async {
    // Stripe initialization would go here
    debugPrint('Stripe initialized with key: $_publishableKey');
  }

  // Create payment intent
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/payment-intents',
        data: {
          'amount': (amount * 100).round(), // Convert to cents
          'currency': currency,
          'customer_id': customerId,
          'metadata': metadata,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create subscription
  Future<Subscription> createSubscription({
    required String customerId,
    required String priceId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/subscriptions',
        data: {
          'customer_id': customerId,
          'price_id': priceId,
          'metadata': metadata,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get subscription
  Future<Subscription> getSubscription(String subscriptionId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/subscriptions/$subscriptionId',
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/subscriptions/$subscriptionId/cancel',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update subscription
  Future<Subscription> updateSubscription({
    required String subscriptionId,
    String? priceId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/stripe/subscriptions/$subscriptionId',
        data: {
          'price_id': priceId,
          'metadata': metadata,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get customer
  Future<Map<String, dynamic>> getCustomer(String customerId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/customers/$customerId',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create customer
  Future<Map<String, dynamic>> createCustomer({
    required String email,
    String? name,
    String? phone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/customers',
        data: {
          'email': email,
          'name': name,
          'phone': phone,
          'metadata': metadata,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update customer
  Future<Map<String, dynamic>> updateCustomer({
    required String customerId,
    String? email,
    String? name,
    String? phone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/stripe/customers/$customerId',
        data: {
          'email': email,
          'name': name,
          'phone': phone,
          'metadata': metadata,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete customer
  Future<void> deleteCustomer(String customerId) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/stripe/customers/$customerId',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get payment methods
  Future<List<Map<String, dynamic>>> getPaymentMethods(
      String customerId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/customers/$customerId/payment-methods',
      );

      return (response['payment_methods'] as List)
          .map((method) => method as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Attach payment method
  Future<void> attachPaymentMethod({
    required String customerId,
    required String paymentMethodId,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/customers/$customerId/payment-methods',
        data: {
          'payment_method_id': paymentMethodId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Detach payment method
  Future<void> detachPaymentMethod(String paymentMethodId) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/stripe/payment-methods/$paymentMethodId',
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
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/customers/$customerId/default-payment-method',
        data: {
          'payment_method_id': paymentMethodId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Create setup intent
  Future<Map<String, dynamic>> createSetupIntent({
    required String customerId,
    String? paymentMethodType,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/setup-intents',
        data: {
          'customer_id': customerId,
          'payment_method_type': paymentMethodType,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Confirm setup intent
  Future<Map<String, dynamic>> confirmSetupIntent({
    required String setupIntentId,
    String? paymentMethodId,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/setup-intents/$setupIntentId/confirm',
        data: {
          'payment_method_id': paymentMethodId,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get setup intent
  Future<Map<String, dynamic>> getSetupIntent(String setupIntentId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/setup-intents/$setupIntentId',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get payment intent
  Future<Map<String, dynamic>> getPaymentIntent(String paymentIntentId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/payment-intents/$paymentIntentId',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Confirm payment intent
  Future<Map<String, dynamic>> confirmPaymentIntent({
    required String paymentIntentId,
    String? paymentMethodId,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/payment-intents/$paymentIntentId/confirm',
        data: {
          'payment_method_id': paymentMethodId,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Cancel payment intent
  Future<void> cancelPaymentIntent(String paymentIntentId) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/payment-intents/$paymentIntentId/cancel',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get invoice
  Future<Map<String, dynamic>> getInvoice(String invoiceId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/invoices/$invoiceId',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Pay invoice
  Future<Map<String, dynamic>> payInvoice(String invoiceId) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/invoices/$invoiceId/pay',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get refund
  Future<Map<String, dynamic>> getRefund(String refundId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/refunds/$refundId',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create refund
  Future<Map<String, dynamic>> createRefund({
    required String paymentIntentId,
    int? amount,
    String? reason,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/stripe/refunds',
        data: {
          'payment_intent_id': paymentIntentId,
          'amount': amount,
          'reason': reason,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get webhook events
  Future<List<Map<String, dynamic>>> getWebhookEvents({
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (fromDate != null)
        queryParams['from_date'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to_date'] = toDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/webhook-events',
        queryParameters: queryParams,
      );

      return (response['events'] as List)
          .map((event) => event as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get account
  Future<Map<String, dynamic>> getAccount() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/account',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update account
  Future<Map<String, dynamic>> updateAccount({
    required Map<String, dynamic> accountData,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/stripe/account',
        data: accountData,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get balance
  Future<Map<String, dynamic>> getBalance() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/balance',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get balance transactions
  Future<List<Map<String, dynamic>>> getBalanceTransactions({
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (fromDate != null)
        queryParams['from_date'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to_date'] = toDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/stripe/balance-transactions',
        queryParameters: queryParams,
      );

      return (response['transactions'] as List)
          .map((transaction) => transaction as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
