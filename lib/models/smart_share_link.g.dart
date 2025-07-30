// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_share_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartShareLinkImpl _$$SmartShareLinkImplFromJson(Map<String, dynamic> json) =>
    _$SmartShareLinkImpl(
      meetingId: json['meeting_id'] as String,
      creatorId: json['creator_id'] as String,
      contextId: json['context_id'] as String?,
      groupId: json['group_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      shareChannel: json['share_channel'] as String?,
    );

Map<String, dynamic> _$$SmartShareLinkImplToJson(
    _$SmartShareLinkImpl instance) {
  final val = <String, dynamic>{
    'meeting_id': instance.meetingId,
    'creator_id': instance.creatorId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('context_id', instance.contextId);
  writeNotNull('group_id', instance.groupId);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('share_channel', instance.shareChannel);
  return val;
}

_$ShareAnalyticsImpl _$$ShareAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$ShareAnalyticsImpl(
      meetingId: json['meeting_id'] as String,
      channel: json['channel'] as String,
      sharedAt: DateTime.parse(json['shared_at'] as String),
      groupId: json['group_id'] as String?,
      recipientId: json['recipient_id'] as String?,
      status: $enumDecodeNullable(_$ShareStatusEnumMap, json['status']),
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at'] as String),
    );

Map<String, dynamic> _$$ShareAnalyticsImplToJson(
    _$ShareAnalyticsImpl instance) {
  final val = <String, dynamic>{
    'meeting_id': instance.meetingId,
    'channel': instance.channel,
    'shared_at': instance.sharedAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('group_id', instance.groupId);
  writeNotNull('recipient_id', instance.recipientId);
  writeNotNull('status', _$ShareStatusEnumMap[instance.status]);
  writeNotNull('responded_at', instance.respondedAt?.toIso8601String());
  return val;
}

const _$ShareStatusEnumMap = {
  ShareStatus.shared: 'shared',
  ShareStatus.clicked: 'clicked',
  ShareStatus.responded: 'responded',
  ShareStatus.confirmed: 'confirmed',
  ShareStatus.declined: 'declined',
};
