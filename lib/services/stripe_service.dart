import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a Stripe checkout session
  Future<Map<String, dynamic>> createCheckoutSession({
    required final String studioId,
    required final String priceId,
    final String? customerEmail,
    final String? successUrl,
    final String? cancelUrl,
  }) async {
    try {
      final callable = _functions.httpsCallable('createCheckoutSession');

      final result = await callable.call({
        'studioId': studioId,
        'priceId': priceId,
        'customerEmail': customerEmail,
        'successUrl': successUrl,
        'cancelUrl': cancelUrl,
      });

      return result.data;
    } catch (e) {
      // Removed debug print: print('Error creating checkout session: $e');
      rethrow;
    }
  }

  /// Get subscription status for a studio
  Future<String?> getSubscriptionStatus(final String studioId) async {
    try {
      final doc = await _firestore.collection('studio').doc(studioId).get();
      return doc.data()?['subscriptionStatus'] as String?;
    } catch (e) {
      // Removed debug print: print('Error getting subscription status: $e');
      return null;
    }
  }

  /// Update subscription status
  Future<void> updateSubscriptionStatus({
    required final String studioId,
    required final String status,
    final String? subscriptionId,
  }) async {
    try {
      await _firestore.collection('studio').doc(studioId).update({
        'subscriptionStatus': status,
        if (subscriptionId != null) 'subscriptionId': subscriptionId,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Removed debug print: print('Error updating subscription status: $e');
      rethrow;
    }
  }

  /// Cancel subscription
  Future<bool> cancelSubscription(final String studioId) async {
    try {
      final doc = await _firestore.collection('studio').doc(studioId).get();
      final subscriptionId = doc.data()?['subscriptionId'] as String?;

      if (subscriptionId != null) {
        // Call Cloud Function to cancel subscription
        final callable = _functions.httpsCallable('cancelSubscription');
        await callable.call({'subscriptionId': subscriptionId});

        // Update local status
        await updateSubscriptionStatus(
          studioId: studioId,
          status: 'cancelled',
        );

        return true;
      }
      return false;
    } catch (e) {
      // Removed debug print: print('Error cancelling subscription: $e');
      return false;
    }
  }

  /// Get subscription details
  Future<Map<String, dynamic>?> getSubscriptionDetails(
      final String studioId) async {
    try {
      final doc = await _firestore.collection('studio').doc(studioId).get();
      final data = doc.data();

      if (data != null) {
        return {
          'status': data['subscriptionStatus'] ?? 'inactive',
          'subscriptionId': data['subscriptionId'],
          'lastPaymentDate': data['lastPaymentDate'],
          'createdAt': data['createdAt'],
        };
      }
      return null;
    } catch (e) {
      // Removed debug print: print('Error getting subscription details: $e');
      return null;
    }
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription(final String studioId) async {
    final status = await getSubscriptionStatus(studioId);
    return status == 'active';
  }
}
