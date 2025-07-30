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

  // Subscribe to Starter plan (€5.00)
  Future<void> subscribeStarter() async {
    await _subscribeToPlan(SubscriptionPlan.starter);
  }

  // Subscribe to Professional plan (€15.00)
  Future<void> subscribeProfessional() async {
    await _subscribeToPlan(SubscriptionPlan.professional);
  }

  // Subscribe to Business Plus plan (€25.00)
  Future<void> subscribeBusinessPlus() async {
    await _subscribeToPlan(SubscriptionPlan.businessPlus);
  }

  // Legacy method redirects (for backward compatibility)
  @Deprecated('Use subscribeStarter() instead')
  Future<void> subscribeBasic() async {
    await subscribeStarter();
  }

  @Deprecated('Use subscribeProfessional() instead')
  Future<void> subscribePro() async {
    await subscribeProfessional();
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

  // Feature Access Control Methods

  /// Check if user can access branding features
  Future<bool> canAccessBranding() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.status.isActive) {
      return false;
    }
    return subscription.plan.brandingEnabled;
  }

  /// Check if user can load maps and track usage
  Future<bool> canLoadMap() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.status.isActive) {
      return false;
    }

    final mapLimit = subscription.plan.mapLimit;
    if (mapLimit == 0) return false; // Starter plan has no maps
    if (mapLimit == -1) return true; // Unlimited (not used currently)

    return subscription.mapUsageCurrentPeriod < mapLimit;
  }

  /// Record map usage and handle overages
  Future<void> recordMapUsage() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.status.isActive) {
      throw Exception('No active subscription found');
    }

    final mapLimit = subscription.plan.mapLimit;
    final currentUsage = subscription.mapUsageCurrentPeriod;
    final newUsage = currentUsage + 1;

    var newOverage = subscription.mapOverageThisPeriod;

    // Calculate overage if we exceed the limit
    if (mapLimit > 0 && newUsage > mapLimit) {
      newOverage += MapUsageConstants.overageRatePerLoad;
    }

    // Update subscription with new usage
    await _firestore
        .collection('business_subscriptions')
        .doc(subscription.id)
        .update({
      'mapUsageCurrentPeriod': newUsage,
      'mapOverageThisPeriod': newOverage,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Get remaining map quota for current period
  Future<int> getRemainingMapQuota() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null || !subscription.status.isActive) {
      return 0;
    }

    final mapLimit = subscription.plan.mapLimit;
    if (mapLimit == 0) return 0; // Starter plan
    if (mapLimit == -1) return -1; // Unlimited

    return (mapLimit - subscription.mapUsageCurrentPeriod).clamp(0, mapLimit);
  }

  /// Reset map usage at the start of new billing period
  Future<void> resetMapUsageForNewPeriod() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final subscription = await getCurrentSubscription();
    if (subscription == null) return;

    await _firestore
        .collection('business_subscriptions')
        .doc(subscription.id)
        .update({
      'mapUsageCurrentPeriod': 0,
      'mapOverageThisPeriod': 0.0,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Generate overage invoice for map usage
  Future<void> generateOverageInvoice() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final subscription = await getCurrentSubscription();
    if (subscription == null || subscription.mapOverageThisPeriod <= 0) {
      return;
    }

    // Create overage invoice
    await _firestore.collection('invoices').add({
      'businessId': user.uid,
      'subscriptionId': subscription.id,
      'type': 'overage',
      'amount': subscription.mapOverageThisPeriod,
      'description': 'Map usage overage charges',
      'mapOverageAmount': subscription.mapOverageThisPeriod,
      'mapOverageCount': (subscription.mapOverageThisPeriod /
              MapUsageConstants.overageRatePerLoad)
          .round(),
      'periodStart': subscription.currentPeriodStart.toIso8601String(),
      'periodEnd': subscription.currentPeriodEnd.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'pending',
      'currency': 'EUR',
    });
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
          'plan': 'starter', // Default to starter
          'mapUsageCurrentPeriod': 0,
          'mapOverageThisPeriod': 0.0,
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
        'plan': plan.name.toLowerCase(),
        'priceId': plan.stripePriceId,
        'promoCode': promoCode,
        'metadata': {
          'tier': plan.name,
          'mapLimit': plan.mapLimit,
          'brandingEnabled': plan.brandingEnabled,
        },
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

      return snap.docs.map((doc) => Invoice.fromJson(doc.data())).toList();
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

  // Get subscription plan limits and feature access
  Future<Map<String, dynamic>> getSubscriptionLimits() async {
    final subscription = await getCurrentSubscription();

    if (subscription == null) {
      return {
        'meetingLimit': 0,
        'mapLimit': 0,
        'brandingEnabled': false,
        'hasAnalytics': false,
        'hasAdvancedAnalytics': false,
        'hasCsvExport': false,
        'hasEmailReminders': false,
        'hasMonthlyCalendar': false,
        'hasClientList': false,
        'hasPrioritySupport': false,
        'mapUsageCurrentPeriod': 0,
        'mapOverageThisPeriod': 0.0,
        'remainingMapQuota': 0,
      };
    }

    final remainingMapQuota = await getRemainingMapQuota();

    return {
      'meetingLimit': subscription.plan.meetingLimit,
      'mapLimit': subscription.plan.mapLimit,
      'brandingEnabled': subscription.plan.brandingEnabled,
      'hasAnalytics': subscription.plan.hasAnalytics,
      'hasAdvancedAnalytics': subscription.plan.hasAdvancedAnalytics,
      'hasCsvExport': subscription.plan.hasAnalytics, // Include with analytics
      'hasEmailReminders':
          subscription.plan.hasAnalytics, // Include with analytics
      'hasMonthlyCalendar': subscription.plan != SubscriptionPlan.starter,
      'hasClientList': subscription.plan != SubscriptionPlan.starter,
      'hasPrioritySupport': subscription.plan.hasPrioritySupport,
      'mapUsageCurrentPeriod': subscription.mapUsageCurrentPeriod,
      'mapOverageThisPeriod': subscription.mapOverageThisPeriod,
      'remainingMapQuota': remainingMapQuota,
    };
  }

  /// Get user-friendly feature access status
  Future<Map<String, String>> getFeatureAccessStatus() async {
    final subscription = await getCurrentSubscription();

    if (subscription == null || !subscription.status.isActive) {
      return {
        'branding': 'locked',
        'maps': 'locked',
        'analytics': 'locked',
        'priority_support': 'locked',
      };
    }

    final remainingMaps = await getRemainingMapQuota();

    return {
      'branding': subscription.plan.brandingEnabled ? 'enabled' : 'locked',
      'maps': subscription.plan.mapLimit > 0
          ? (remainingMaps > 0 ? 'enabled' : 'quota_exceeded')
          : 'locked',
      'analytics': subscription.plan.hasAnalytics ? 'enabled' : 'locked',
      'priority_support':
          subscription.plan.hasPrioritySupport ? 'enabled' : 'locked',
    };
  }
}
