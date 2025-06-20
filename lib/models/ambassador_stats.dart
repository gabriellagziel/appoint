import 'package:freezed_annotation/freezed_annotation.dart';

part 'ambassador_stats.freezed.dart';
part 'ambassador_stats.g.dart';

@freezed
class AmbassadorStats with _$AmbassadorStats {
  const factory AmbassadorStats({
    required String country,
    required String language,
    required int ambassadors,
    required int referrals,
    required double surveyScore,
    required DateTime date,
  }) = _AmbassadorStats;

  factory AmbassadorStats.fromJson(Map<String, dynamic> json) =>
      _$AmbassadorStatsFromJson(json);
}

@freezed
class AmbassadorData with _$AmbassadorData {
  const factory AmbassadorData({
    required List<AmbassadorStats> stats,
    required List<ChartDataPoint> chartData,
  }) = _AmbassadorData;
}

@freezed
class ChartDataPoint with _$ChartDataPoint {
  const factory ChartDataPoint({
    required String label,
    required double value,
    required String category,
  }) = _ChartDataPoint;
} 