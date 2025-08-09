// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivacyRequestImpl _$$PrivacyRequestImplFromJson(Map<String, dynamic> json) =>
    _$PrivacyRequestImpl(
      id: json['id'] as String,
      childId: json['childId'] as String,
      parentId: json['parentId'] as String,
      requestType: json['requestType'] as String,
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      reason: json['reason'] as String?,
      parentResponse: json['parentResponse'] as String?,
    );

Map<String, dynamic> _$$PrivacyRequestImplToJson(
        _$PrivacyRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'parentId': instance.parentId,
      'requestType': instance.requestType,
      'status': instance.status,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'reason': instance.reason,
      'parentResponse': instance.parentResponse,
    };
