import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_share_link.freezed.dart';
part 'smart_share_link.g.dart';

@freezed
class SmartShareLink with _$SmartShareLink {
  const factory SmartShareLink({
    required String meetingId,
    required String creatorId,
    String? contextId,
    String? groupId,
    DateTime? createdAt,
    String? shareChannel,
  }) = _SmartShareLink;

  factory SmartShareLink.fromJson(Map<String, dynamic> json) =>
      _$SmartShareLinkFromJson(json);
}

@freezed
class GroupRecognition with _$GroupRecognition {
  const factory GroupRecognition({
    required String groupId,
    required String groupName,
    required String phoneNumber,
    required DateTime firstSharedAt,
    required int totalShares,
    required int totalResponses,
    DateTime? lastSharedAt,
  }) = _GroupRecognition;

  factory GroupRecognition.fromJson(Map<String, dynamic> json) =>
      _$GroupRecognitionFromJson(json);
}

@freezed
class ShareAnalytics with _$ShareAnalytics {
  const factory ShareAnalytics({
    required String meetingId,
    required String channel,
    required DateTime sharedAt,
    String? groupId,
    String? recipientId,
    ShareStatus? status,
    DateTime? respondedAt,
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
