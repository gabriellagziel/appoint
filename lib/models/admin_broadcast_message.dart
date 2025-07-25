import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appoint/models/custom_form_field.dart';

part 'admin_broadcast_message.freezed.dart';
part 'admin_broadcast_message.g.dart';

enum BroadcastMessageType {
  text,
  image,
  video,
  poll,
  link,
  form,
}

enum BroadcastMessageStatus {
  pending,
  sending,
  sent,
  failed,
  partially_sent,
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
    final List<CustomFormField>? formFields,
    final DateTime? scheduledFor,
    final DateTime? sentAt,
    final DateTime? processedAt,
    final int? estimatedRecipients,
    final int? actualRecipients,
    final int? openedCount,
    final int? clickedCount,
    final int? pollResponseCount,
    final int? failedCount,
    final Map<String, int>? pollResponses,
    final List<String>? failedRecipients,
    final String? failureReason,
  }) = _AdminBroadcastMessage;

  factory AdminBroadcastMessage.fromJson(Map<String, dynamic> json) =>
      _$AdminBroadcastMessageFromJson(json);
  
  // Computed getters for analytics
  int get sentCount => actualRecipients ?? 0;
  int get formResponseCount => pollResponseCount ?? 0;
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
