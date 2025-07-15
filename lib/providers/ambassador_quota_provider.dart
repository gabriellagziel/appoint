import 'package:appoint/services/ambassador_quota_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the ambassador quota service
final ambassadorQuotaServiceProvider =
    Provider<AmbassadorQuotaService>((ref) => AmbassadorQuotaService());

// Provider for quota statistics
final quotaStatisticsProvider =
    FutureProvider<Map<String, dynamic>>((ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return service.getQuotaStatistics();
});

// Provider for global statistics
final globalQuotaStatisticsProvider =
    FutureProvider<Map<String, dynamic>>((ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return service.getGlobalStatistics();
});

// Provider for available slots for a specific country-language combination
final FutureProviderFamily<int, Map<String, String>> availableSlotsProvider =
    FutureProvider.family<int, Map<String, String>>((ref, final params) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  final countryCode = params['countryCode']!;
  final languageCode = params['languageCode']!;
  return service.getAvailableSlots(countryCode, languageCode);
});

// Provider for checking if slots are available
final FutureProviderFamily<bool, Map<String, String>> hasAvailableSlotsProvider =
    FutureProvider.family<bool, Map<String, String>>((ref, final params) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  final countryCode = params['countryCode']!;
  final languageCode = params['languageCode']!;
  return service.hasAvailableSlots(countryCode, languageCode);
});

// Provider for user eligibility
final FutureProviderFamily<bool, String> userEligibilityProvider =
    FutureProvider.family<bool, String>((ref, final userId) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return service.isUserEligible(userId);
});

// Notifier for ambassador assignment operations
class AmbassadorAssignmentNotifier extends StateNotifier<AsyncValue<bool>> {

  AmbassadorAssignmentNotifier(this._service)
      : super(const AsyncValue.data(false));
  final AmbassadorQuotaService _service;

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
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> removeAmbassador(String userId) async {
    state = const AsyncValue.loading();

    try {
      final success = await _service.removeAmbassador(userId);
      state = AsyncValue.data(success);
      return success;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<int> autoAssignAvailableSlots() async {
    state = const AsyncValue.loading();

    try {
      final assignedCount = await _service.autoAssignAvailableSlots();
      state = AsyncValue.data(assignedCount > 0);
      return assignedCount;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return 0;
    }
  }

  void reset() {
    state = const AsyncValue.data(false);
  }
}

final ambassadorAssignmentProvider =
    StateNotifierProvider<AmbassadorAssignmentNotifier, AsyncValue<bool>>(
        (ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return AmbassadorAssignmentNotifier(service);
});

// Provider for quota data with refresh capability
class QuotaDataNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {

  QuotaDataNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadData();
  }
  final AmbassadorQuotaService _service;

  Future<void> _loadData() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _service.getQuotaStatistics();
      state = AsyncValue.data(stats);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadData();
  }

  // Get specific country-language quota info
  Map<String, dynamic>? getQuotaInfo(
      String countryCode, final String languageCode,) {
    final data = state.value;
    if (data == null) return null;

    final key = '${countryCode}_$languageCode';
    return data[key];
  }

  // Get all quotas for a specific country
  Map<String, dynamic> getQuotasForCountry(String countryCode) {
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
  Map<String, dynamic> getQuotasForLanguage(String languageCode) {
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
      {int limit = 10,}) {
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
      ..sort((a, final b) {
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
      {int limit = 10,}) {
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
      ..sort((a, final b) => b['totalAvailable']
          .compareTo(a['totalAvailable']),); // Descending order

    return sortedCountries.take(limit).toList();
  }
}

final quotaDataProvider =
    StateNotifierProvider<QuotaDataNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  final service = ref.read(ambassadorQuotaServiceProvider);
  return QuotaDataNotifier(service);
});

// Convenience providers for filtered data
final REDACTED_TOKEN =
    Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final quotaDataAsync = ref.watch(quotaDataProvider);
  return quotaDataAsync.when(
    data: (data) => AsyncValue.data(
        ref.read(quotaDataProvider.notifier).getTopCountriesByUtilization(),),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

final REDACTED_TOKEN =
    Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final quotaDataAsync = ref.watch(quotaDataProvider);
  return quotaDataAsync.when(
    data: (data) => AsyncValue.data(ref
        .read(quotaDataProvider.notifier)
        .REDACTED_TOKEN(),),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});
