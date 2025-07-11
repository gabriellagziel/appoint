import 'package:freezed_annotation/freezed_annotation.dart';

part 'ambassador_stats.freezed.dart';
part 'ambassador_stats.g.dart';

@freezed
class AmbassadorStats with _$AmbassadorStats {
  const factory AmbassadorStats({
    required final String country,
    required final String language,
    required final int ambassadors,
    required final int referrals,
    required final double surveyScore,
    required final DateTime date,
  }) = _AmbassadorStats;

  factory AmbassadorStats.fromJson(Map<String, dynamic> json) =>
      _$AmbassadorStatsFromJson(json);
}

@freezed
class AmbassadorData with _$AmbassadorData {
  const factory AmbassadorData({
    required final List<AmbassadorStats> stats,
    required final List<ChartDataPoint> chartData,
  }) = _AmbassadorData;
}

@freezed
class ChartDataPoint with _$ChartDataPoint {
  const factory ChartDataPoint({
    required final String label,
    required final double value,
    required final String category,
  }) = _ChartDataPoint;
}
