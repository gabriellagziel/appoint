import 'package:flutter/foundation.dart';
import 'dart:convert';
// Optional Stripe SDK import: ensure dependency is added to pubspec before enabling.
// ignore_for_file: uri_does_not_exist, undefined_identifier
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

/// Stripe payment service for handling upgrades
class StripePaymentService {
  static final StripePaymentService _instance =
      StripePaymentService._internal();
  factory StripePaymentService() => _instance;
  StripePaymentService._internal();

  // Production-ready configuration: keys via environment/Runtime config
  // Inline security: Do NOT ship secret keys in the client. Publishable key only.
  static const String _stripePublishableKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  static const String _backendBaseUrl =
      String.fromEnvironment('BACKEND_BASE_URL', defaultValue: '');

  /// Creates a payment link for premium upgrade
  static Future<String?> createUpgradePaymentLink({
    required String userId,
    required String userEmail,
    required double amount,
    String currency = 'USD',
  }) async {
    try {
      // Request a Checkout Session from backend (Cloud Functions or Next.js API)
      final res = await http.post(
        Uri.parse('$_backendBaseUrl/api/checkout/session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (amount * 100).round(),
          'currency': currency.toLowerCase(),
          'userId': userId,
          'customer_email': userEmail,
        }),
      );
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['url'] as String?;

      // Real implementation would look like:
      // final response = await http.post(
      //   Uri.parse('$_stripeApiBaseUrl/payment_links'),
      //   headers: {
      //     'Authorization': 'Bearer $_stripeSecretKey',
      //     'Content-Type': 'application/x-www-form-urlencoded',
      //   },
      //   body: {
      //     'line_items[0][price_data][currency]': currency,
      //     'line_items[0][price_data][product_data][name]': 'Premium Upgrade',
      //     'line_items[0][price_data][unit_amount]': (amount * 100).toInt().toString(),
      //     'line_items[0][quantity]': '1',
      //     'customer_email': userEmail,
      //     'success_url': 'https://app-oint.com/upgrade/success?session_id={CHECKOUT_SESSION_ID}',
      //     'cancel_url': 'https://app-oint.com/upgrade/cancel',
      //     'metadata[user_id]': userId,
      //   },
      // );
      //
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return data['url'];
      // }
    } catch (e) {
      debugPrint('Error creating payment link: $e');
      return null;
    }
  }

  /// Creates a subscription for premium access
  static Future<Map<String, dynamic>?> createSubscription({
    required String userId,
    required String userEmail,
    required String priceId,
  }) async {
    try {
      // Create subscription on backend and return subscription details
      final res = await http.post(
        Uri.parse('$_backendBaseUrl/api/subscriptions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'userId': userId, 'userEmail': userEmail, 'priceId': priceId}),
      );
      if (res.statusCode != 200) return null;
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error creating subscription: $e');
      return null;
    }
  }

  /// Verifies payment success
  static Future<bool> verifyPayment(String sessionId) async {
    try {
      final res = await http.get(Uri.parse(
          '$_backendBaseUrl/api/checkout/verify?sessionId=$sessionId'));
      if (res.statusCode != 200) return false;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['paid'] as bool?) ?? false;
    } catch (e) {
      debugPrint('Error verifying payment: $e');
      return false;
    }
  }

  /// Gets subscription status
  static Future<Map<String, dynamic>?> getSubscriptionStatus(
    String subscriptionId,
  ) async {
    try {
      final res = await http
          .get(Uri.parse('$_backendBaseUrl/api/subscriptions/$subscriptionId'));
      if (res.statusCode != 200) return null;
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting subscription status: $e');
      return null;
    }
  }

  /// Cancels subscription
  static Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final res = await http.delete(
          Uri.parse('$_backendBaseUrl/api/subscriptions/$subscriptionId'));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('Error canceling subscription: $e');
      return false;
    }
  }

  /// Gets available pricing plans
  static List<Map<String, dynamic>> getPricingPlans() {
    return [
      {
        'id': 'price_monthly',
        'name': 'Monthly Premium',
        'price': 9.99,
        'currency': 'USD',
        'interval': 'month',
        'features': [
          'Remove all ads',
          'Unlimited meetings',
          'Priority support',
          'Advanced analytics',
        ],
      },
      {
        'id': 'price_yearly',
        'name': 'Yearly Premium',
        'price': 99.99,
        'currency': 'USD',
        'interval': 'year',
        'features': [
          'Remove all ads',
          'Unlimited meetings',
          'Priority support',
          'Advanced analytics',
          '2 months free',
        ],
      },
    ];
  }

  /// Opens upgrade page with payment link
  static Future<void> openUpgradePage({
    required String userId,
    required String userEmail,
    String planId = 'price_monthly',
  }) async {
    try {
      final plans = getPricingPlans();
      final plan = plans.firstWhere((p) => p['id'] == planId);

      // Initialize SDK if available
      if (_stripePublishableKey.isNotEmpty) {
        Stripe.publishableKey = _stripePublishableKey;
      }

      final paymentLink = await createUpgradePaymentLink(
        userId: userId,
        userEmail: userEmail,
        amount: plan['price'],
        currency: plan['currency'],
      );

      if (paymentLink != null) {
        // Use url_launcher to open payment link in production app
        debugPrint('Opening payment link: $paymentLink');
      } else {
        debugPrint('Failed to create payment link');
      }
    } catch (e) {
      debugPrint('Error opening upgrade page: $e');
    }
  }

  /// Handles webhook events from Stripe
  static Future<void> handleWebhookEvent(Map<String, dynamic> event) async {
    try {
      final eventType = event['type'] as String?;

      switch (eventType) {
        case 'checkout.session.completed':
          await _handleCheckoutCompleted(event['data']['object']);
          break;
        case 'customer.subscription.created':
          await _handleSubscriptionCreated(event['data']['object']);
          break;
        case 'customer.subscription.updated':
          await _handleSubscriptionUpdated(event['data']['object']);
          break;
        case 'customer.subscription.deleted':
          await _handleSubscriptionDeleted(event['data']['object']);
          break;
        default:
          debugPrint('Unhandled webhook event: $eventType');
      }
    } catch (e) {
      debugPrint('Error handling webhook event: $e');
    }
  }

  /// Handles checkout session completed
  static Future<void> _handleCheckoutCompleted(
    Map<String, dynamic> session,
  ) async {
    final userId = session['metadata']?['user_id'];
    if (userId != null) {
      debugPrint('Checkout completed for user: $userId');
      // TODO: Update user premium status in database
    }
  }

  /// Handles subscription created
  static Future<void> _handleSubscriptionCreated(
    Map<String, dynamic> subscription,
  ) async {
    final customerId = subscription['customer'];
    debugPrint('Subscription created for customer: $customerId');
    // TODO: Update user premium status in database
  }

  /// Handles subscription updated
  static Future<void> _handleSubscriptionUpdated(
    Map<String, dynamic> subscription,
  ) async {
    final subscriptionId = subscription['id'];
    final status = subscription['status'];
    debugPrint('Subscription updated: $subscriptionId, status: $status');
    // TODO: Update user premium status in database
  }

  /// Handles subscription deleted
  static Future<void> _handleSubscriptionDeleted(
    Map<String, dynamic> subscription,
  ) async {
    final subscriptionId = subscription['id'];
    debugPrint('Subscription deleted: $subscriptionId');
    // TODO: Update user premium status in database
  }
}
