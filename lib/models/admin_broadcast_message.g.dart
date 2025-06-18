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
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      externalLink: json['externalLink'] as String?,
      pollOptions: (json['pollOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      targetingFilters: BroadcastTargetingFilters.fromJson(
          json['targetingFilters'] as Map<String, dynamic>),
      createdByAdminId: json['createdByAdminId'] as String,
      createdByAdminName: json['createdByAdminName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.parse(json['scheduledFor'] as String),
      status: $enumDecode(_$BroadcastMessageStatusEnumMap, json['status']),
      estimatedRecipients: (json['estimatedRecipients'] as num?)?.toInt(),
      actualRecipients: (json['actualRecipients'] as num?)?.toInt(),
      openedCount: (json['openedCount'] as num?)?.toInt(),
      clickedCount: (json['clickedCount'] as num?)?.toInt(),
      pollResponses: (json['pollResponses'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      failedRecipients: (json['failedRecipients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      failureReason: json['failureReason'] as String?,
    );

Map<String, dynamic> _$$AdminBroadcastMessageImplToJson(
        _$AdminBroadcastMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'type': _$BroadcastMessageTypeEnumMap[instance.type]!,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'externalLink': instance.externalLink,
      'pollOptions': instance.pollOptions,
      'targetingFilters': instance.targetingFilters.toJson(),
      'createdByAdminId': instance.createdByAdminId,
      'createdByAdminName': instance.createdByAdminName,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
      'status': _$BroadcastMessageStatusEnumMap[instance.status]!,
      'estimatedRecipients': instance.estimatedRecipients,
      'actualRecipients': instance.actualRecipients,
      'openedCount': instance.openedCount,
      'clickedCount': instance.clickedCount,
      'pollResponses': instance.pollResponses,
      'failedRecipients': instance.failedRecipients,
      'failureReason': instance.failureReason,
    };

const _$BroadcastMessageTypeEnumMap = {
  BroadcastMessageType.text: 'text',
  BroadcastMessageType.image: 'image',
  BroadcastMessageType.video: 'video',
  BroadcastMessageType.poll: 'poll',
  BroadcastMessageType.link: 'link',
};

const _$BroadcastMessageStatusEnumMap = {
  BroadcastMessageStatus.pending: 'pending',
  BroadcastMessageStatus.sent: 'sent',
  BroadcastMessageStatus.failed: 'failed',
};

_$BroadcastTargetingFiltersImpl _$$BroadcastTargetingFiltersImplFromJson(
        Map<String, dynamic> json) =>
    _$BroadcastTargetingFiltersImpl(
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cities:
          (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList(),
      minAge: (json['minAge'] as num?)?.toInt(),
      maxAge: (json['maxAge'] as num?)?.toInt(),
      subscriptionTiers: (json['subscriptionTiers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accountTypes: (json['accountTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accountStatuses: (json['accountStatuses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      joinedAfter: json['joinedAfter'] == null
          ? null
          : DateTime.parse(json['joinedAfter'] as String),
      joinedBefore: json['joinedBefore'] == null
          ? null
          : DateTime.parse(json['joinedBefore'] as String),
      userRoles: (json['userRoles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$BroadcastTargetingFiltersImplToJson(
        _$BroadcastTargetingFiltersImpl instance) =>
    <String, dynamic>{
      'countries': instance.countries,
      'cities': instance.cities,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'subscriptionTiers': instance.subscriptionTiers,
      'accountTypes': instance.accountTypes,
      'languages': instance.languages,
      'accountStatuses': instance.accountStatuses,
      'joinedAfter': instance.joinedAfter?.toIso8601String(),
      'joinedBefore': instance.joinedBefore?.toIso8601String(),
      'userRoles': instance.userRoles,
    };
