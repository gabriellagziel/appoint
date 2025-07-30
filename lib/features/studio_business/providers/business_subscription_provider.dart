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

// API usage provider
final apiUsageProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async {
    final service = ref.watch(businessSubscriptionServiceProvider);
    return service.getApiUsage();
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
      state = AsyncValue.data(subscription);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<String> generateApiKey() async {
    try {
      return await _service.generateApiKey();
    } catch (e) {
      throw Exception('Failed to generate API key: $e');
    }
  }

  Future<void> generateMonthlyInvoice() async {
    try {
      await _service.generateMonthlyInvoice();
    } catch (e) {
      throw Exception('Failed to generate monthly invoice: $e');
    }
  }

  Future<void> suspendApiKey() async {
    try {
      await _service.suspendApiKey();
      await _loadSubscription();
    } catch (e) {
      throw Exception('Failed to suspend API key: $e');
    }
  }

  Future<void> reactivateApiKey() async {
    try {
      await _service.reactivateApiKey();
      await _loadSubscription();
    } catch (e) {
      throw Exception('Failed to reactivate API key: $e');
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
