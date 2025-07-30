// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_broadcast_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminBroadcastMessageImpl _$$AdminBroadcastMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminBroadcastMessageImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$BroadcastMessageTypeEnumMap, json['type']),
      targetingFilters: BroadcastTargetingFilters.fromJson(
          json['targeting_filters'] as Map<String, dynamic>),
      createdByAdminId: json['created_by_admin_id'] as String,
      createdByAdminName: json['created_by_admin_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: $enumDecode(_$BroadcastMessageStatusEnumMap, json['status']),
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      externalLink: json['external_link'] as String?,
      pollOptions: (json['poll_options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      formFields: (json['form_fields'] as List<dynamic>?)
          ?.map((e) => CustomFormField.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduledFor: json['scheduled_for'] == null
          ? null
          : DateTime.parse(json['scheduled_for'] as String),
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      estimatedRecipients: (json['estimated_recipients'] as num?)?.toInt(),
      actualRecipients: (json['actual_recipients'] as num?)?.toInt(),
      openedCount: (json['opened_count'] as num?)?.toInt(),
      clickedCount: (json['clicked_count'] as num?)?.toInt(),
      pollResponseCount: (json['poll_response_count'] as num?)?.toInt(),
      failedCount: (json['failed_count'] as num?)?.toInt(),
      pollResponses: (json['poll_responses'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      failedRecipients: (json['failed_recipients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      failureReason: json['failure_reason'] as String?,
    );

Map<String, dynamic> _$$AdminBroadcastMessageImplToJson(
    _$AdminBroadcastMessageImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'content': instance.content,
    'type': _$BroadcastMessageTypeEnumMap[instance.type]!,
    'targeting_filters': instance.targetingFilters,
    'created_by_admin_id': instance.createdByAdminId,
    'created_by_admin_name': instance.createdByAdminName,
    'created_at': instance.createdAt.toIso8601String(),
    'status': _$BroadcastMessageStatusEnumMap[instance.status]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('video_url', instance.videoUrl);
  writeNotNull('external_link', instance.externalLink);
  writeNotNull('poll_options', instance.pollOptions);
  writeNotNull('form_fields', instance.formFields);
  writeNotNull('scheduled_for', instance.scheduledFor?.toIso8601String());
  writeNotNull('sent_at', instance.sentAt?.toIso8601String());
  writeNotNull('processed_at', instance.processedAt?.toIso8601String());
  writeNotNull('estimated_recipients', instance.estimatedRecipients);
  writeNotNull('actual_recipients', instance.actualRecipients);
  writeNotNull('opened_count', instance.openedCount);
  writeNotNull('clicked_count', instance.clickedCount);
  writeNotNull('poll_response_count', instance.pollResponseCount);
  writeNotNull('failed_count', instance.failedCount);
  writeNotNull('poll_responses', instance.pollResponses);
  writeNotNull('failed_recipients', instance.failedRecipients);
  writeNotNull('failure_reason', instance.failureReason);
  return val;
}

const _$BroadcastMessageTypeEnumMap = {
  BroadcastMessageType.text: 'text',
  BroadcastMessageType.image: 'image',
  BroadcastMessageType.video: 'video',
  BroadcastMessageType.poll: 'poll',
  BroadcastMessageType.link: 'link',
  BroadcastMessageType.form: 'form',
};

const _$BroadcastMessageStatusEnumMap = {
  BroadcastMessageStatus.pending: 'pending',
  BroadcastMessageStatus.sending: 'sending',
  BroadcastMessageStatus.sent: 'sent',
  BroadcastMessageStatus.failed: 'failed',
  BroadcastMessageStatus.partially_sent: 'partially_sent',
};

_$BroadcastTargetingFiltersImpl _$$BroadcastTargetingFiltersImplFromJson(
        Map<String, dynamic> json) =>
    _$BroadcastTargetingFiltersImpl(
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cities:
          (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList(),
      minAge: (json['min_age'] as num?)?.toInt(),
      maxAge: (json['max_age'] as num?)?.toInt(),
      subscriptionTiers: (json['subscription_tiers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accountTypes: (json['account_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accountStatuses: (json['account_statuses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      joinedAfter: json['joined_after'] == null
          ? null
          : DateTime.parse(json['joined_after'] as String),
      joinedBefore: json['joined_before'] == null
          ? null
          : DateTime.parse(json['joined_before'] as String),
      userRoles: (json['user_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$BroadcastTargetingFiltersImplToJson(
    _$BroadcastTargetingFiltersImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('countries', instance.countries);
  writeNotNull('cities', instance.cities);
  writeNotNull('min_age', instance.minAge);
  writeNotNull('max_age', instance.maxAge);
  writeNotNull('subscription_tiers', instance.subscriptionTiers);
  writeNotNull('account_types', instance.accountTypes);
  writeNotNull('languages', instance.languages);
  writeNotNull('account_statuses', instance.accountStatuses);
  writeNotNull('joined_after', instance.joinedAfter?.toIso8601String());
  writeNotNull('joined_before', instance.joinedBefore?.toIso8601String());
  writeNotNull('user_roles', instance.userRoles);
  return val;
}
