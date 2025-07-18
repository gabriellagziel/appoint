import 'package:appoint/config/environment_config.dart';
import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/models/invoice.dart';
import 'package:appoint/features/studio_business/models/promo_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessSubscriptionService {

  BusinessSubscriptionService({
    final FirebaseFirestore? firestore,
    final FirebaseAuth? auth,
    final FirebaseFunctions? functions,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _functions = functions ?? FirebaseFunctions.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  // Getter methods to ensure we have valid instances
  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;
  FirebaseFunctions get functions => _functions;

  // Subscribe to Basic plan (€4.99)
  Future<void> subscribeBasic() async {
    await _subscribeToPlan(SubscriptionPlan.basic);
  }

  // Subscribe to Pro plan (€14.99)
  Future<void> subscribePro() async {
    await _subscribeToPlan(SubscriptionPlan.pro);
  }

  // Generic subscription method
  Future<void> _subscribeToPlan(SubscriptionPlan plan) async {
    try {
      final sessionId = await createCheckoutSession(plan: plan);

      // Load Stripe checkout URL from environment configuration
      const stripeCheckoutUrl = EnvironmentConfig.stripeCheckoutUrl;

      // Launch Stripe checkout
      final url = '$stripeCheckoutUrl/$sessionId';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch checkout URL');
      }
    } catch (e) {
      throw Exception('Failed to start subscription: $e');
    }
  }

  // Open customer portal
  Future<void> openCustomerPortal() async {
    try {
      final url = await createCustomerPortalSession();

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch customer portal URL');
      }
    } catch (e) {
      throw Exception('Failed to open customer portal: $e');
    }
  }

  // Apply promo code
  Future<void> applyPromoCode(String code) async {
    try {
      // Validate the promo code
      final promoCode = await validatePromoCode(code);
      if (promoCode == null) {
        throw Exception('Invalid or expired promo code');
      }

      // Get current user
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Check if user already has a subscription
      final existingSubscription = await getCurrentSubscription();

      if (existingSubscription != null) {
        // Update existing subscription with promo code
        await _firestore
            .collection('business_subscriptions')
            .doc(existingSubscription.id)
            .update({
          'promoCodeId': promoCode.id,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        // Create a new subscription document with promo code
        await _firestore.collection('business_subscriptions').add({
          'businessId': user.uid,
          'customerId': user.uid,
          'promoCodeId': promoCode.id,
          'status': 'inactive',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      // Increment usage count
      await _firestore.collection('promoCodes').doc(promoCode.id).update({
        'currentUses': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to apply promo code: $e');
    }
  }

  // Create Stripe checkout session
  Future<String> createCheckoutSession({
    required final SubscriptionPlan plan,
    final String? promoCode,
  }) async {
    try {
      final callable =
          _functions.httpsCallable('createBusinessCheckoutSession');
      final result = await callable.call({
        'plan': plan.name,
        'promoCode': promoCode,
      });

      return result.data['sessionId'] as String;
    } catch (e) {
      throw Exception('Failed to create checkout session: $e');
    }
  }

  // Create Stripe customer portal session
  Future<String> createCustomerPortalSession() async {
    try {
      final callable = _functions.httpsCallable('createCustomerPortalSession');
      final result = await callable.call({});

      return result.data['url'] as String;
    } catch (e) {
      throw Exception('Failed to create customer portal session: $e');
    }
  }

  // Validate promo code
  Future<PromoCode?> validatePromoCode(String code) async {
    try {
      final doc = await _firestore
          .collection('promoCodes')
          .where('code', isEqualTo: code.toUpperCase())
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return null;

      final promoCode = PromoCode.fromJson(doc.docs.first.data());

      // Check if code is still valid
      final now = DateTime.now();
      if (now.isBefore(promoCode.validFrom) ||
          now.isAfter(promoCode.validUntil)) {
        return null;
      }

      // Check if usage limit exceeded
      if (promoCode.currentUses >= promoCode.maxUses) {
        return null;
      }

      return promoCode;
    } catch (e) {
      // Removed debug print: debugPrint('Error validating promo code: $e');
      return null;
    }
  }

  // Get current business subscription
  Future<BusinessSubscription?> getCurrentSubscription() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('business_subscriptions')
          .where('businessId', isEqualTo: user.uid)
          .where('status', whereIn: ['active', 'trialing'])
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return null;

      final data = doc.docs.first.data();
      data['id'] = doc.docs.first.id; // Add the document ID to the data
      return BusinessSubscription.fromJson(data);
    } catch (e) {
      // Removed debug print: debugPrint('Error fetching subscription: $e');
      return null;
    }
  }

  // Get subscription invoices
  Future<List<Invoice>> getInvoices({int limit = 10}) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final subscription = await getCurrentSubscription();
      if (subscription == null) return [];

      final snap = await _firestore
          .collection('invoices')
          .where('businessId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snap.docs
          .map((doc) => Invoice.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Removed debug print: debugPrint('Error fetching invoices: $e');
      return [];
    }
  }

  // Stream subscription changes for real-time updates
  Stream<BusinessSubscription?> watchSubscription() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('business_subscriptions')
        .where('businessId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;

      // Get the most recent active subscription
      final activeSubs = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Add the document ID to the data
            return BusinessSubscription.fromJson(data);
          })
          .where((sub) => sub.status.isActive)
          .toList();

      if (activeSubs.isEmpty) return null;

      // Sort by creation date and return the latest
      activeSubs.sort((a, final b) => b.createdAt.compareTo(a.createdAt));
      return activeSubs.first;
    });
  }

  // Check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    final subscription = await getCurrentSubscription();
    return subscription != null && subscription.status.isActive;
  }

  // Get subscription plan limits
  Future<Map<String, dynamic>> getSubscriptionLimits() async {
    final subscription = await getCurrentSubscription();

    if (subscription == null) {
      return {
        'meetingLimit': 0,
        'hasAnalytics': false,
        'hasCsvExport': false,
        'hasEmailReminders': false,
        'hasMonthlyCalendar': false,
        'hasClientList': false,
      };
    }

    return {
      'meetingLimit': subscription.plan.meetingLimit,
      'hasAnalytics': subscription.plan == SubscriptionPlan.pro,
      'hasCsvExport': subscription.plan == SubscriptionPlan.pro,
      'hasEmailReminders': subscription.plan == SubscriptionPlan.pro,
      'hasMonthlyCalendar': subscription.plan == SubscriptionPlan.pro,
      'hasClientList': subscription.plan == SubscriptionPlan.pro,
    };
  }
}
