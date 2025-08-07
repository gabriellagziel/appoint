// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionImpl _$$PermissionImplFromJson(Map<String, dynamic> json) =>
    _$PermissionImpl(
      id: json['id'] as String,
      familyLinkId: json['familyLinkId'] as String,
      category: json['category'] as String,
      accessLevel: json['accessLevel'] as String,
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$$PermissionImplToJson(_$PermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyLinkId': instance.familyLinkId,
      'category': instance.category,
      'accessLevel': instance.accessLevel,
      'lastModified': instance.lastModified?.toIso8601String(),
    };
