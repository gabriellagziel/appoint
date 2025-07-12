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
    required final String id,
    required final String title,
    required final String content,
    required final BroadcastMessageType type,
    required final BroadcastTargetingFilters targetingFilters, required final String createdByAdminId, required final String createdByAdminName, required final DateTime createdAt, required final BroadcastMessageStatus status, final String? imageUrl,
    final String? videoUrl,
    final String? externalLink,
    final List<String>? pollOptions,
    final DateTime? scheduledFor,
    final int? estimatedRecipients,
    final int? actualRecipients,
    final int? openedCount,
    final int? clickedCount,
    final Map<String, int>? pollResponses,
    final List<String>? failedRecipients,
    final String? failureReason,
  }) = _AdminBroadcastMessage;

  factory AdminBroadcastMessage.fromJson(Map<String, dynamic> json) =>
      _$AdminBroadcastMessageFromJson(json);
}

@freezed
class BroadcastTargetingFilters with _$BroadcastTargetingFilters {
  const factory BroadcastTargetingFilters({
    final List<String>? countries,
    final List<String>? cities,
    final int? minAge,
    final int? maxAge,
    final List<String>? subscriptionTiers,
    final List<String>? accountTypes,
    final List<String>? languages,
    final List<String>? accountStatuses,
    final DateTime? joinedAfter,
    final DateTime? joinedBefore,
    final List<String>? userRoles,
  }) = _BroadcastTargetingFilters;

  factory BroadcastTargetingFilters.fromJson(Map<String, dynamic> json) =>
      _$BroadcastTargetingFiltersFromJson(json);
}
