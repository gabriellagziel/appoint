import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/models/promo_code.dart';
import 'package:appoint/features/studio_business/models/invoice.dart';
import 'package:appoint/providers/firebase_providers.dart';

// Service provider
final businessSubscriptionServiceProvider =
    Provider<BusinessSubscriptionService>((final ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  return BusinessSubscriptionService(
    firestore: firestore,
    auth: auth,
    functions: functions,
  );
});

// Current subscription provider
final currentSubscriptionProvider = StreamProvider<BusinessSubscription?>(
  (final ref) {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.watchSubscription();
  },
);

// Subscription limits provider
final subscriptionLimitsProvider = FutureProvider<Map<String, dynamic>>(
  (final ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.getSubscriptionLimits();
  },
);

// Active subscription check provider
final hasActiveSubscriptionProvider = FutureProvider<bool>(
  (final ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.hasActiveSubscription();
  },
);

// Invoices provider
final subscriptionInvoicesProvider = FutureProvider<List<Invoice>>(
  (final ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.getInvoices();
  },
);

// Promo code validation provider
final promoCodeValidationProvider = FutureProvider.family<PromoCode?, String>(
  (final ref, final code) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.validatePromoCode(code);
  },
);

// Business subscription notifier for actions
class BusinessSubscriptionNotifier
    extends StateNotifier<AsyncValue<BusinessSubscription?>> {
  final BusinessSubscriptionService _service;

  BusinessSubscriptionNotifier(this._service)
      : super(const AsyncValue.loading()) {
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    state = const AsyncValue.loading();
    try {
      final subscription = await _service.getCurrentSubscription();
      state = AsyncValue.data(subscription);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<String> createCheckoutSession({
    required final SubscriptionPlan plan,
    final String? promoCode,
  }) async {
    try {
      return await _service.createCheckoutSession(
        plan: plan,
        promoCode: promoCode,
      );
    } catch (error) {
      throw Exception('Failed to create checkout session: $error');
    }
  }

  Future<String> createCustomerPortalSession() async {
    try {
      return await _service.createCustomerPortalSession();
    } catch (error) {
      throw Exception('Failed to create customer portal session: $error');
    }
  }

  Future<void> refreshSubscription() async {
    await _loadSubscription();
  }
}

final businessSubscriptionNotifierProvider = StateNotifierProvider<
    BusinessSubscriptionNotifier, AsyncValue<BusinessSubscription?>>(
  (final ref) {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return BusinessSubscriptionNotifier(service);
  },
);
