import 'package:json_annotation/json_annotation.dart';

part 'analytics.g.dart';

@JsonSerializable()
class Analytics {
  final int totalUsers;
  final int totalOrgs;
  final int activeAppointments;

  Analytics({
    required this.totalUsers,
    required this.totalOrgs,
    required this.activeAppointments,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsToJson(this);
}
