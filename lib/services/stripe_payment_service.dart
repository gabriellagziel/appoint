import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Stripe payment service for handling upgrades
class StripePaymentService {
  static final StripePaymentService _instance =
      StripePaymentService._internal();
  factory StripePaymentService() => _instance;
  StripePaymentService._internal();

  // TODO: Replace with actual Stripe configuration
  static const String _stripePublishableKey = 'pk_test_your_publishable_key';
  static const String _stripeSecretKey = 'sk_test_your_secret_key';
  static const String _stripeApiBaseUrl = 'https://api.stripe.com/v1';

  /// Creates a payment link for premium upgrade
  static Future<String?> createUpgradePaymentLink({
    required String userId,
    required String userEmail,
    required double amount,
    String currency = 'USD',
  }) async {
    try {
      // TODO: Replace with actual Stripe API call
      // For now, return a mock payment link
      debugPrint(
        'Creating payment link for user: $userId, amount: $amount $currency',
      );

      // Mock payment link
      return 'https://checkout.stripe.com/pay/cs_test_mock_payment_link#fidkdXx0YmxldVo';

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
      // TODO: Replace with actual Stripe API call
      debugPrint('Creating subscription for user: $userId, price: $priceId');

      // Mock subscription data
      return {
        'id': 'sub_mock_subscription_id',
        'status': 'active',
        'current_period_end':
            DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch,
        'customer': 'cus_mock_customer_id',
      };
    } catch (e) {
      debugPrint('Error creating subscription: $e');
      return null;
    }
  }

  /// Verifies payment success
  static Future<bool> verifyPayment(String sessionId) async {
    try {
      // TODO: Replace with actual Stripe API call
      debugPrint('Verifying payment session: $sessionId');

      // Mock verification
      await Future.delayed(Duration(seconds: 1));
      return true;
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
      // TODO: Replace with actual Stripe API call
      debugPrint('Getting subscription status: $subscriptionId');

      // Mock subscription status
      return {
        'id': subscriptionId,
        'status': 'active',
        'current_period_end':
            DateTime.now().add(Duration(days: 25)).millisecondsSinceEpoch,
        'cancel_at_period_end': false,
      };
    } catch (e) {
      debugPrint('Error getting subscription status: $e');
      return null;
    }
  }

  /// Cancels subscription
  static Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      // TODO: Replace with actual Stripe API call
      debugPrint('Canceling subscription: $subscriptionId');

      // Mock cancellation
      await Future.delayed(Duration(seconds: 1));
      return true;
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

      final paymentLink = await createUpgradePaymentLink(
        userId: userId,
        userEmail: userEmail,
        amount: plan['price'],
        currency: plan['currency'],
      );

      if (paymentLink != null) {
        // TODO: Use url_launcher to open payment link
        debugPrint('Opening payment link: $paymentLink');

        // For now, just log the link
        debugPrint('Payment link created: $paymentLink');
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
