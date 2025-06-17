// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_share_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartShareLinkImpl _$$SmartShareLinkImplFromJson(Map<String, dynamic> json) =>
    _$SmartShareLinkImpl(
      meetingId: json['meetingId'] as String,
      creatorId: json['creatorId'] as String,
      contextId: json['contextId'] as String?,
      groupId: json['groupId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      shareChannel: json['shareChannel'] as String?,
    );

Map<String, dynamic> _$$SmartShareLinkImplToJson(
        _$SmartShareLinkImpl instance) =>
    <String, dynamic>{
      'meetingId': instance.meetingId,
      'creatorId': instance.creatorId,
      'contextId': instance.contextId,
      'groupId': instance.groupId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'shareChannel': instance.shareChannel,
    };

_$GroupRecognitionImpl _$$GroupRecognitionImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupRecognitionImpl(
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      firstSharedAt: DateTime.parse(json['firstSharedAt'] as String),
      totalShares: (json['totalShares'] as num).toInt(),
      totalResponses: (json['totalResponses'] as num).toInt(),
      lastSharedAt: json['lastSharedAt'] == null
          ? null
          : DateTime.parse(json['lastSharedAt'] as String),
    );

Map<String, dynamic> _$$GroupRecognitionImplToJson(
        _$GroupRecognitionImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'phoneNumber': instance.phoneNumber,
      'firstSharedAt': instance.firstSharedAt.toIso8601String(),
      'totalShares': instance.totalShares,
      'totalResponses': instance.totalResponses,
      'lastSharedAt': instance.lastSharedAt?.toIso8601String(),
    };

_$ShareAnalyticsImpl _$$ShareAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$ShareAnalyticsImpl(
      meetingId: json['meetingId'] as String,
      channel: json['channel'] as String,
      sharedAt: DateTime.parse(json['sharedAt'] as String),
      groupId: json['groupId'] as String?,
      recipientId: json['recipientId'] as String?,
      status: $enumDecodeNullable(_$ShareStatusEnumMap, json['status']),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$ShareAnalyticsImplToJson(
        _$ShareAnalyticsImpl instance) =>
    <String, dynamic>{
      'meetingId': instance.meetingId,
      'channel': instance.channel,
      'sharedAt': instance.sharedAt.toIso8601String(),
      'groupId': instance.groupId,
      'recipientId': instance.recipientId,
      'status': _$ShareStatusEnumMap[instance.status],
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };

const _$ShareStatusEnumMap = {
  ShareStatus.shared: 'shared',
  ShareStatus.clicked: 'clicked',
  ShareStatus.responded: 'responded',
  ShareStatus.confirmed: 'confirmed',
  ShareStatus.declined: 'declined',
};
