import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ambassador_stats.dart';
import '../services/ambassador_service.dart';
import '../models/business_analytics.dart';

final ambassadorServiceProvider =
    Provider<AmbassadorService>((ref) => AmbassadorService());

class AmbassadorDataNotifier extends StateNotifier<AsyncValue<AmbassadorData>> {
  final AmbassadorService _service;

  String? _selectedCountry;
  String? _selectedLanguage;
  DateTimeRange? _selectedDateRange;

  AmbassadorDataNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadData();
  }

  String? get selectedCountry => _selectedCountry;
  String? get selectedLanguage => _selectedLanguage;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  Future<void> _loadData() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _service.fetchAmbassadorStats(
        country: _selectedCountry,
        language: _selectedLanguage,
        dateRange: _selectedDateRange,
      );

      final chartData = _service.generateChartData(stats);
      final data = AmbassadorData(stats: stats, chartData: chartData);

      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void updateFilters({
    String? country,
    String? language,
    DateTimeRange? dateRange,
  }) {
    _selectedCountry = country;
    _selectedLanguage = language;
    _selectedDateRange = dateRange;
    _loadData();
  }

  void clearFilters() {
    _selectedCountry = null;
    _selectedLanguage = null;
    _selectedDateRange = null;
    _loadData();
  }
}

final ambassadorDataProvider =
    StateNotifierProvider<AmbassadorDataNotifier, AsyncValue<AmbassadorData>>(
  (ref) => AmbassadorDataNotifier(ref.read(ambassadorServiceProvider)),
);

// Convenience providers for filtered data
final ambassadorStatsProvider =
    Provider<AsyncValue<List<AmbassadorStats>>>((ref) {
  final dataAsync = ref.watch(ambassadorDataProvider);
  return dataAsync.when(
    data: (data) => AsyncValue.data(data.stats),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final ambassadorChartDataProvider =
    Provider<AsyncValue<List<ChartDataPoint>>>((ref) {
  final dataAsync = ref.watch(ambassadorDataProvider);
  return dataAsync.when(
    data: (data) => AsyncValue.data(data.chartData),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Filter state providers
final ambassadorFiltersProvider =
    StateProvider<Map<String, dynamic>>((ref) => {});

final selectedCountryProvider = StateProvider<String?>((ref) => null);
final selectedLanguageProvider = StateProvider<String?>((ref) => null);
final selectedDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

final ambassadorReferralTrendProvider =
    FutureProvider<List<TimeSeriesPoint>>((ref) {
  final country = ref.watch(selectedCountryProvider);
  final language = ref.watch(selectedLanguageProvider);
  final range = ref.watch(selectedDateRangeProvider);
  return ref.read(ambassadorServiceProvider).fetchReferralTrend(
        country: country,
        language: language,
        dateRange: range,
      );
});
