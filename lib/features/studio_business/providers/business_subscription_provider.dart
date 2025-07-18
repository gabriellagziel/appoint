import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/models/invoice.dart';
import 'package:appoint/features/studio_business/models/promo_code.dart';
import 'package:appoint/providers/firebase_providers.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service provider
final businessSubscriptionServiceProvider =
    Provider<BusinessSubscriptionService>((ref) {
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
  (ref) {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.watchSubscription();
  },
);

// Subscription limits provider
final subscriptionLimitsProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.getSubscriptionLimits();
  },
);

// Active subscription check provider
final hasActiveSubscriptionProvider = FutureProvider<bool>(
  (ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.hasActiveSubscription();
  },
);

// Invoices provider
final subscriptionInvoicesProvider = FutureProvider<List<Invoice>>(
  (ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.getInvoices();
  },
);

// Promo code validation provider
final FutureProviderFamily<PromoCode?, String> promoCodeValidationProvider = FutureProvider.family<PromoCode?, String>(
  (ref, final code) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.validatePromoCode(code);
  },
);

// Business subscription notifier for actions
class BusinessSubscriptionNotifier
    extends StateNotifier<AsyncValue<BusinessSubscription?>> {

  BusinessSubscriptionNotifier(this._service)
      : super(const AsyncValue.loading()) {
    _loadSubscription();
  }
  final BusinessSubscriptionService _service;

  Future<void> _loadSubscription() async {
    state = const AsyncValue.loading();
    try {
      final subscription = await _service.getCurrentSubscription();
      final state = AsyncValue.data(subscription);
    } catch (e) {
      final state = AsyncValue.error(error, stackTrace);
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
    } catch (e) {
      throw Exception('Failed to create checkout session: $error');
    }
  }

  Future<String> createCustomerPortalSession() async {
    try {
      return await _service.createCustomerPortalSession();
    } catch (e) {
      throw Exception('Failed to create customer portal session: $error');
    }
  }

  Future<void> refreshSubscription() async {
    await _loadSubscription();
  }
}

final businessSubscriptionNotifierProvider = StateNotifierProvider<
    BusinessSubscriptionNotifier, AsyncValue<BusinessSubscription?>>(
  (ref) {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return BusinessSubscriptionNotifier(service);
  },
);
