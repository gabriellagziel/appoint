import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/ambassador_quota_service.dart';

// Provider for the ambassador quota service
final ambassadorQuotaServiceProvider =
    Provider<AmbassadorQuotaService>((final ref) {
  return AmbassadorQuotaService();
});

// Provider for quota statistics
final quotaStatisticsProvider =
    FutureProvider<Map<String, dynamic>>((final ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return service.getQuotaStatistics();
});

// Provider for global statistics
final globalQuotaStatisticsProvider =
    FutureProvider<Map<String, dynamic>>((final ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return service.getGlobalStatistics();
});

// Provider for available slots for a specific country-language combination
final availableSlotsProvider =
    FutureProvider.family<int, Map<String, String>>((final ref, final params) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  final countryCode = params['countryCode']!;
  final languageCode = params['languageCode']!;
  return service.getAvailableSlots(countryCode, languageCode);
});

// Provider for checking if slots are available
final hasAvailableSlotsProvider =
    FutureProvider.family<bool, Map<String, String>>((final ref, final params) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  final countryCode = params['countryCode']!;
  final languageCode = params['languageCode']!;
  return service.hasAvailableSlots(countryCode, languageCode);
});

// Provider for user eligibility
final userEligibilityProvider =
    FutureProvider.family<bool, String>((final ref, final userId) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return service.isUserEligible(userId);
});

// Notifier for ambassador assignment operations
class AmbassadorAssignmentNotifier extends StateNotifier<AsyncValue<bool>> {
  final AmbassadorQuotaService _service;

  AmbassadorAssignmentNotifier(this._service)
      : super(const AsyncValue.data(false));

  Future<bool> assignAmbassador({
    required final String userId,
    required final String countryCode,
    required final String languageCode,
  }) async {
    state = const AsyncValue.loading();

    try {
      final success = await _service.assignAmbassador(
        userId: userId,
        countryCode: countryCode,
        languageCode: languageCode,
      );

      state = AsyncValue.data(success);
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> removeAmbassador(final String userId) async {
    state = const AsyncValue.loading();

    try {
      final success = await _service.removeAmbassador(userId);
      state = AsyncValue.data(success);
      return success;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<int> autoAssignAvailableSlots() async {
    state = const AsyncValue.loading();

    try {
      final assignedCount = await _service.autoAssignAvailableSlots();
      state = AsyncValue.data(assignedCount > 0);
      return assignedCount;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return 0;
    }
  }

  void reset() {
    state = const AsyncValue.data(false);
  }
}

final ambassadorAssignmentProvider =
    StateNotifierProvider<AmbassadorAssignmentNotifier, AsyncValue<bool>>(
        (final ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return AmbassadorAssignmentNotifier(service);
});

// Provider for quota data with refresh capability
class QuotaDataNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final AmbassadorQuotaService _service;

  QuotaDataNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _service.getQuotaStatistics();
      state = AsyncValue.data(stats);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadData();
  }

  // Get specific country-language quota info
  Map<String, dynamic>? getQuotaInfo(
      final String countryCode, final String languageCode) {
    final data = state.value;
    if (data == null) return null;

    final key = '${countryCode}_$languageCode';
    return data[key];
  }

  // Get all quotas for a specific country
  Map<String, dynamic> getQuotasForCountry(final String countryCode) {
    final data = state.value;
    if (data == null) return {};

    final countryQuotas = <String, dynamic>{};
    for (final entry in data.entries) {
      if (entry.value['countryCode'] == countryCode) {
        countryQuotas[entry.key] = entry.value;
      }
    }
    return countryQuotas;
  }

  // Get all quotas for a specific language
  Map<String, dynamic> getQuotasForLanguage(final String languageCode) {
    final data = state.value;
    if (data == null) return {};

    final languageQuotas = <String, dynamic>{};
    for (final entry in data.entries) {
      if (entry.value['languageCode'] == languageCode) {
        languageQuotas[entry.key] = entry.value;
      }
    }
    return languageQuotas;
  }

  // Get top countries by utilization
  List<Map<String, dynamic>> getTopCountriesByUtilization(
      {final int limit = 10}) {
    final data = state.value;
    if (data == null) return [];

    final countries = <String, Map<String, dynamic>>{};

    for (final entry in data.entries) {
      final countryCode = entry.value['countryCode'] as String;
      final currentData = countries[countryCode];

      if (currentData == null) {
        countries[countryCode] = {
          'countryCode': countryCode,
          'totalQuota': entry.value['quota'],
          'totalCurrent': entry.value['currentCount'],
          'totalAvailable': entry.value['availableSlots'],
        };
      } else {
        currentData['totalQuota'] += entry.value['quota'];
        currentData['totalCurrent'] += entry.value['currentCount'];
        currentData['totalAvailable'] += entry.value['availableSlots'];
      }
    }

    // Calculate utilization percentage and sort
    final sortedCountries = countries.values.toList()
      ..sort((final a, final b) {
        final aUtilization =
            (a['totalCurrent'] / a['totalQuota'] * 100).roundToDouble();
        final bUtilization =
            (b['totalCurrent'] / b['totalQuota'] * 100).roundToDouble();
        return bUtilization.compareTo(aUtilization); // Descending order
      });

    return sortedCountries.take(limit).toList();
  }

  // Get countries with most available slots
  List<Map<String, dynamic>> REDACTED_TOKEN(
      {final int limit = 10}) {
    final data = state.value;
    if (data == null) return [];

    final countries = <String, Map<String, dynamic>>{};

    for (final entry in data.entries) {
      final countryCode = entry.value['countryCode'] as String;
      final currentData = countries[countryCode];

      if (currentData == null) {
        countries[countryCode] = {
          'countryCode': countryCode,
          'totalAvailable': entry.value['availableSlots'],
        };
      } else {
        currentData['totalAvailable'] += entry.value['availableSlots'];
      }
    }

    final sortedCountries = countries.values.toList()
      ..sort((final a, final b) => b['totalAvailable']
          .compareTo(a['totalAvailable'])); // Descending order

    return sortedCountries.take(limit).toList();
  }
}

final quotaDataProvider =
    StateNotifierProvider<QuotaDataNotifier, AsyncValue<Map<String, dynamic>>>(
        (final ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return QuotaDataNotifier(service);
});

// Convenience providers for filtered data
final REDACTED_TOKEN =
    Provider<AsyncValue<List<Map<String, dynamic>>>>((final ref) {
  final quotaDataAsync = ref.watch(quotaDataProvider);
  return quotaDataAsync.when(
    data: (final data) => AsyncValue.data(
        ref.read(quotaDataProvider.notifier).getTopCountriesByUtilization()),
    loading: () => const AsyncValue.loading(),
    error: (final error, final stackTrace) =>
        AsyncValue.error(error, stackTrace),
  );
});

final REDACTED_TOKEN =
    Provider<AsyncValue<List<Map<String, dynamic>>>>((final ref) {
  final quotaDataAsync = ref.watch(quotaDataProvider);
  return quotaDataAsync.when(
    data: (final data) => AsyncValue.data(ref
        .read(quotaDataProvider.notifier)
        .REDACTED_TOKEN()),
    loading: () => const AsyncValue.loading(),
    error: (final error, final stackTrace) =>
        AsyncValue.error(error, stackTrace),
  );
});
