import 'package:appoint/features/subscriptions/models/subscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart' as stripe;
import 'dart:developer' as dev;

class SubscriptionService {
  SubscriptionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Get available subscription plans
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    final snapshot = await _firestore.collection('subscription_plans').get();
    
    return snapshot.docs.map((doc) {
      return SubscriptionPlan.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Subscribe to a plan
  Future<void> subscribeToPlan(String planId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Get plan details
    final planDoc = await _firestore.collection('subscription_plans').doc(planId).get();
    if (!planDoc.exists) throw Exception('Plan not found');

    final plan = SubscriptionPlan.fromJson({...planDoc.data()!, 'id': planId});

    // Create Stripe subscription
    final stripeSubscription = await _createStripeSubscription(plan);

    // Create subscription in Firestore
    final subscription = Subscription(
      id: '',
      userId: user.uid,
      planId: planId,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      endDate: _calculateEndDate(plan.interval),
      stripeSubscriptionId: stripeSubscription.id,
      stripeCustomerId: stripeSubscription.customerId,
    );

    await _firestore.collection('subscriptions').add(subscription.toJson());

    // Update user's subscription status
    await _firestore.collection('users').doc(user.uid).update({
      'subscriptionPlanId': planId,
      'subscriptionStatus': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Cancel subscription
  Future<void> cancelSubscription() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Get active subscription
    final subscriptionDoc = await _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (subscriptionDoc.docs.isEmpty) {
      throw Exception('No active subscription found');
    }

    final subscription = Subscription.fromJson({
      ...subscriptionDoc.docs.first.data(),
      'id': subscriptionDoc.docs.first.id,
    });

    // Cancel in Stripe
    if (subscription.stripeSubscriptionId != null) {
      await _cancelStripeSubscription(subscription.stripeSubscriptionId!);
    }

    // Update in Firestore
    await _firestore
        .collection('subscriptions')
        .doc(subscription.id)
        .update({
      'status': 'canceled',
      'canceledAt': FieldValue.serverTimestamp(),
      'cancelAtPeriodEnd': true,
    });

    // Update user status
    await _firestore.collection('users').doc(user.uid).update({
      'subscriptionStatus': 'canceled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get current subscription status
  Future<SubscriptionStatus> getCurrentStatus() async {
    final user = _auth.currentUser;
    if (user == null) return SubscriptionStatus.unpaid;

    final subscriptionDoc = await _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (subscriptionDoc.docs.isEmpty) {
      return SubscriptionStatus.unpaid;
    }

    final subscription = Subscription.fromJson({
      ...subscriptionDoc.docs.first.data(),
      'id': subscriptionDoc.docs.first.id,
    });

    return subscription.status;
  }

  /// Get user's subscription details
  Future<UserSubscription?> getUserSubscription() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    // Get current plan
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    final userData = userDoc.data()!;
    final planId = userData['subscriptionPlanId'] as String?;
    
    if (planId == null) return null;

    final planDoc = await _firestore.collection('subscription_plans').doc(planId).get();
    if (!planDoc.exists) return null;

    final plan = SubscriptionPlan.fromJson({...planDoc.data()!, 'id': planId});

    // Get active subscription
    final subscriptionDoc = await _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    Subscription? activeSubscription;
    if (subscriptionDoc.docs.isNotEmpty) {
      activeSubscription = Subscription.fromJson({
        ...subscriptionDoc.docs.first.data(),
        'id': subscriptionDoc.docs.first.id,
      });
    }

    // Get payment methods
    final paymentMethods = await _getPaymentMethods(user.uid);

    // Get billing history
    final billingHistory = await _getBillingHistory(user.uid);

    // Get usage stats
    final usageStats = await _getUsageStats(user.uid);

    return UserSubscription(
      userId: user.uid,
      currentPlan: plan,
      activeSubscription: activeSubscription,
      paymentMethods: paymentMethods,
      billingHistory: billingHistory,
      usageStats: usageStats,
    );
  }

  /// Add payment method
  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('payment_methods')
        .add(paymentMethod.toJson());
  }

  /// Remove payment method
  Future<void> removePaymentMethod(String paymentMethodId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('payment_methods')
        .doc(paymentMethodId)
        .delete();
  }

  /// Get payment methods
  Future<List<PaymentMethod>> _getPaymentMethods(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('payment_methods')
        .get();

    return snapshot.docs.map((doc) {
      return PaymentMethod.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Get billing history
  Future<List<Payment>> _getBillingHistory(String userId) async {
    final snapshot = await _firestore
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((doc) {
      return Payment.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  /// Get usage stats
  Future<UsageStats> _getUsageStats(String userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    // Get bookings this month
    final bookingsSnapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .get();

    final bookingsThisMonth = bookingsSnapshot.docs.length;

    // Get messages this month
    final messagesSnapshot = await _firestore
        .collection('messages')
        .where('senderId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .get();

    final messagesThisMonth = messagesSnapshot.docs.length;

    // Get storage usage (placeholder - would need actual storage calculation)
    const storageUsed = 0.0; // MB
    const storageLimit = 1000.0; // MB

    return UsageStats(
      bookingsThisMonth: bookingsThisMonth,
      bookingsLimit: 100, // Based on plan
      messagesThisMonth: messagesThisMonth,
      messagesLimit: 1000, // Based on plan
      storageUsed: storageUsed,
      storageLimit: storageLimit,
    );
  }

  /// Create Stripe subscription
  Future<StripeSubscription> _createStripeSubscription(SubscriptionPlan plan) async {
    // This would integrate with Stripe SDK
    // For now, return a mock subscription
    return StripeSubscription(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      customerId: 'cus_${DateTime.now().millisecondsSinceEpoch}',
      status: 'active',
      currentPeriodStart: DateTime.now(),
      currentPeriodEnd: _calculateEndDate(plan.interval),
    );
  }

  /// Cancel Stripe subscription
  Future<void> _cancelStripeSubscription(String subscriptionId) async {
    // This would integrate with Stripe SDK
    // For now, just log the cancellation
    dev.log('Canceling Stripe subscription: $subscriptionId', name: 'SubscriptionService');
  }

  /// Calculate end date based on interval
  DateTime _calculateEndDate(SubscriptionInterval interval) {
    final now = DateTime.now();
    
    switch (interval) {
      case SubscriptionInterval.weekly:
        return now.add(const Duration(days: 7));
      case SubscriptionInterval.monthly:
        return DateTime(now.year, now.month + 1, now.day);
      case SubscriptionInterval.yearly:
        return DateTime(now.year + 1, now.month, now.day);
    }
  }
}

// Mock Stripe subscription class (replace with actual Stripe SDK)
class StripeSubscription {
  const StripeSubscription({
    required this.id,
    required this.customerId,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
  });

  final String id;
  final String customerId;
  final String status;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
} 