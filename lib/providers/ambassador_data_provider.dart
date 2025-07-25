import 'package:appoint/models/ambassador_stats.dart';
import 'package:appoint/models/business_analytics.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ambassadorServiceProvider =
    Provider<AmbassadorService>((ref) => AmbassadorService());

class AmbassadorDataNotifier extends StateNotifier<AsyncValue<AmbassadorData>> {

  AmbassadorDataNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadData();
  }
  final AmbassadorService _service;

  String? _selectedCountry;
  String? _selectedLanguage;
  DateTimeRange? _selectedDateRange;

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
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void updateFilters({
    final String? country,
    final String? language,
    final DateTimeRange? dateRange,
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
    error: AsyncValue.error,
  );
});

final ambassadorChartDataProvider =
    Provider<AsyncValue<List<ChartDataPoint>>>((ref) {
  final dataAsync = ref.watch(ambassadorDataProvider);
  return dataAsync.when(
    data: (data) => AsyncValue.data(data.chartData),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

final ambassadorsOverTimeProvider =
    FutureProvider<List<TimeSeriesPoint>>((ref) => ref.read(ambassadorServiceProvider).fetchAmbassadorsOverTime());

// Filter state providers
final ambassadorFiltersProvider =
    StateProvider<Map<String, dynamic>>((ref) => {});

final selectedCountryProvider = StateProvider<String?>((ref) => null);
final selectedLanguageProvider = StateProvider<String?>((ref) => null);
final selectedDateRangeProvider =
    StateProvider<DateTimeRange?>((ref) => null);
