import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/admin_broadcast_message.freezed.dart';
part '../generated/models/admin_broadcast_message.g.dart';

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
    final String? imageUrl,
    final String? videoUrl,
    final String? externalLink,
    final List<String>? pollOptions,
    required final BroadcastTargetingFilters targetingFilters,
    required final String createdByAdminId,
    required final String createdByAdminName,
    required final DateTime createdAt,
    final DateTime? scheduledFor,
    required final BroadcastMessageStatus status,
    final int? estimatedRecipients,
    final int? actualRecipients,
    final int? openedCount,
    final int? clickedCount,
    final Map<String, int>? pollResponses,
    final List<String>? failedRecipients,
    final String? failureReason,
  }) = _AdminBroadcastMessage;

  factory AdminBroadcastMessage.fromJson(final Map<String, dynamic> json) =>
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

  factory BroadcastTargetingFilters.fromJson(final Map<String, dynamic> json) =>
      _$BroadcastTargetingFiltersFromJson(json);
}
