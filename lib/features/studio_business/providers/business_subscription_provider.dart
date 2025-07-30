import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/models/business_profile.dart';
import 'package:appoint/features/studio_business/services/business_profile_service.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final REDACTED_TOKEN =
    Provider<BusinessSubscriptionService>(
  (ref) => BusinessSubscriptionService(),
);

final currentSubscriptionProvider = StreamProvider<BusinessSubscription?>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.watchSubscription();
  },
);

final subscriptionLimitsProvider = FutureProvider<Map<String, dynamic>>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.getSubscriptionLimits();
  },
);

final featureAccessProvider = FutureProvider<Map<String, String>>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.getFeatureAccessStatus();
  },
);

// Feature-specific providers for UI access control

final brandingAccessProvider = FutureProvider<bool>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.canAccessBranding();
  },
);

final mapAccessProvider = FutureProvider<bool>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.canLoadMap();
  },
);

final remainingMapQuotaProvider = FutureProvider<int>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.getRemainingMapQuota();
  },
);

// Map usage tracking provider
final mapUsageNotifierProvider =
    StateNotifierProvider<MapUsageNotifier, AsyncValue<void>>(
  (ref) => MapUsageNotifier(ref.watch(REDACTED_TOKEN)),
);

class MapUsageNotifier extends StateNotifier<AsyncValue<void>> {
  MapUsageNotifier(this._service) : super(const AsyncValue.data(null));

  final BusinessSubscriptionService _service;

  Future<void> recordMapUsage() async {
    state = const AsyncValue.loading();
    try {
      await _service.recordMapUsage();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<bool> canLoadMap() async {
    try {
      return await _service.canLoadMap();
    } catch (e) {
      return false;
    }
  }
}

// Business profile provider with branding access control
final businessProfileProvider =
    StateNotifierProvider<BusinessProfileNotifier, BusinessProfile?>(
  BusinessProfileNotifier.new,
);

class BusinessProfileNotifier extends StateNotifier<BusinessProfile?> {
  BusinessProfileNotifier(this._ref) : super(null) {
    loadProfile();
  }

  final Ref _ref;
  final _service = BusinessProfileService();

  Future<void> loadProfile() async {
    try {
      final profile = await _service.fetchProfile();
      state = profile;
    } catch (e) {
      // Profile not found, create default
      state = null;
    }
  }

  /// Check if user can access branding features before allowing profile updates
  Future<bool> _canAccessBranding() async {
    final subscriptionService = _ref.read(REDACTED_TOKEN);
    return subscriptionService.canAccessBranding();
  }

  Future<void> updateField({
    String? name,
    String? description,
    String? phone,
    String? email,
    String? address,
    String? website,
    List<String>? services,
    Map<String, dynamic>? businessHours,
    String? logoUrl,
    String? coverImageUrl,
  }) async {
    if (state == null) return;

    // Check branding access for branding-related fields
    final isBrandingUpdate = logoUrl != null ||
        coverImageUrl != null ||
        description != null ||
        services != null ||
        businessHours != null;

    if (isBrandingUpdate) {
      final canAccess = await _canAccessBranding();
      if (!canAccess) {
        throw Exception(
            'Branding features require Professional plan or higher');
      }
    }

    state = state!.copyWith(
      name: name ?? state!.name,
      description: description ?? state!.description,
      phone: phone ?? state!.phone,
      email: email ?? state!.email,
      address: address ?? state!.address,
      website: website ?? state!.website,
      services: services ?? state!.services,
      businessHours: businessHours ?? state!.businessHours,
      logoUrl: logoUrl ?? state!.logoUrl,
      coverImageUrl: coverImageUrl ?? state!.coverImageUrl,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> updateProfile(BusinessProfile profile) async {
    // Check branding access for profile with branding features
    final hasBrandingFeatures = profile.logoUrl != null ||
        profile.coverImageUrl != null ||
        profile.description.isNotEmpty ||
        profile.services.isNotEmpty;

    if (hasBrandingFeatures) {
      final canAccess = await _canAccessBranding();
      if (!canAccess) {
        throw Exception(
            'Branding features require Professional plan or higher');
      }
    }

    state = profile;
  }

  Future<void> save() async {
    if (state == null) return;

    // Final branding access check before saving
    final hasBrandingFeatures = state!.logoUrl != null ||
        state!.coverImageUrl != null ||
        state!.description.isNotEmpty ||
        state!.services.isNotEmpty;

    if (hasBrandingFeatures) {
      final canAccess = await _canAccessBranding();
      if (!canAccess) {
        throw Exception(
            'Branding features require Professional plan or higher');
      }
    }

    await _service.updateProfile(state!);
  }
}

// Helper providers for UI state management

final hasActiveSubscriptionProvider = FutureProvider<bool>(
  (ref) {
    final service = ref.watch(REDACTED_TOKEN);
    return service.hasActiveSubscription();
  },
);

final subscriptionStatusProvider = Provider<String>((ref) {
  final subscriptionAsync = ref.watch(currentSubscriptionProvider);
  return subscriptionAsync.when(
    data: (subscription) {
      if (subscription == null) return 'inactive';
      return subscription.status.name;
    },
    loading: () => 'loading',
    error: (_, __) => 'error',
  );
});

final currentPlanProvider = Provider<SubscriptionPlan?>((ref) {
  final subscriptionAsync = ref.watch(currentSubscriptionProvider);
  return subscriptionAsync.whenOrNull(
    data: (subscription) => subscription?.plan,
  );
});

// Usage tracking for displaying in UI
final mapUsageStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final subscriptionAsync = ref.watch(currentSubscriptionProvider);
  final limitsAsync = ref.watch(subscriptionLimitsProvider);

  return subscriptionAsync.when(
    data: (subscription) {
      if (subscription == null) {
        return {
          'current': 0,
          'limit': 0,
          'remaining': 0,
          'overage': 0.0,
          'hasLimit': false,
        };
      }

      return limitsAsync.when(
        data: (limits) => {
          'current': subscription.mapUsageCurrentPeriod,
          'limit': subscription.plan.mapLimit,
          'remaining': limits['remainingMapQuota'] ?? 0,
          'overage': subscription.mapOverageThisPeriod,
          'hasLimit': subscription.plan.mapLimit > 0,
        },
        loading: () => {
          'current': subscription.mapUsageCurrentPeriod,
          'limit': subscription.plan.mapLimit,
          'remaining': 0,
          'overage': subscription.mapOverageThisPeriod,
          'hasLimit': subscription.plan.mapLimit > 0,
        },
        error: (_, __) => {
          'current': 0,
          'limit': 0,
          'remaining': 0,
          'overage': 0.0,
          'hasLimit': false,
        },
      );
    },
    loading: () => {
      'current': 0,
      'limit': 0,
      'remaining': 0,
      'overage': 0.0,
      'hasLimit': false,
    },
    error: (_, __) => {
      'current': 0,
      'limit': 0,
      'remaining': 0,
      'overage': 0.0,
      'hasLimit': false,
    },
  );
});
