import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_broadcast_message.freezed.dart';
part 'admin_broadcast_message.g.dart';

enum BroadcastMessageType {
  text,
  image,
  video,
  poll,
  link,
}

enum BroadcastMessageStatus {
  pending,
  sent,
  failed,
}

@freezed
class AdminBroadcastMessage with _$AdminBroadcastMessage {
  const factory AdminBroadcastMessage({
    required String id,
    required String title,
    required String content,
    required BroadcastMessageType type,
    String? imageUrl,
    String? videoUrl,
    String? externalLink,
    List<String>? pollOptions,
    required BroadcastTargetingFilters targetingFilters,
    required String createdByAdminId,
    required String createdByAdminName,
    required DateTime createdAt,
    DateTime? scheduledFor,
    required BroadcastMessageStatus status,
    int? estimatedRecipients,
    int? actualRecipients,
    int? openedCount,
    int? clickedCount,
    Map<String, int>? pollResponses,
    List<String>? failedRecipients,
    String? failureReason,
  }) = _AdminBroadcastMessage;

  factory AdminBroadcastMessage.fromJson(Map<String, dynamic> json) =>
      _$AdminBroadcastMessageFromJson(json);
}

@freezed
class BroadcastTargetingFilters with _$BroadcastTargetingFilters {
  const factory BroadcastTargetingFilters({
    List<String>? countries,
    List<String>? cities,
    int? minAge,
    int? maxAge,
    List<String>? subscriptionTiers,
    List<String>? accountTypes,
    List<String>? languages,
    List<String>? accountStatuses,
    DateTime? joinedAfter,
    DateTime? joinedBefore,
    List<String>? userRoles,
  }) = _BroadcastTargetingFilters;

  factory BroadcastTargetingFilters.fromJson(Map<String, dynamic> json) =>
      _$BroadcastTargetingFiltersFromJson(json);
}
