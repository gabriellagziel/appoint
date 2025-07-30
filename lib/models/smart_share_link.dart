import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_share_link.freezed.dart';
part 'smart_share_link.g.dart';

@freezed
class SmartShareLink with _$SmartShareLink {
  const factory SmartShareLink({
    required final String meetingId,
    required final String creatorId,
    final String? contextId,
    final String? groupId,
    final DateTime? createdAt,
    final String? shareChannel,
  }) = _SmartShareLink;

  factory SmartShareLink.fromJson(Map<String, dynamic> json) =>
      _$SmartShareLinkFromJson(json);
}

@freezed
class ShareAnalytics with _$ShareAnalytics {
  const factory ShareAnalytics({
    required final String meetingId,
    required final String channel,
    required final DateTime sharedAt,
    final String? groupId,
    final String? recipientId,
    final ShareStatus? status,
    final DateTime? respondedAt,
  }) = _ShareAnalytics;

  factory ShareAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ShareAnalyticsFromJson(json);
}

enum ShareStatus {
  shared,
  clicked,
  responded,
  confirmed,
  declined,
}
