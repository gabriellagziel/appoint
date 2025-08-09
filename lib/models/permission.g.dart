// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionImpl _$$PermissionImplFromJson(Map<String, dynamic> json) =>
    _$PermissionImpl(
      id: json['id'] as String,
      familyLinkId: json['familyLinkId'] as String,
      grantedTo: json['grantedTo'] as String,
      grantedBy: json['grantedBy'] as String,
      permissionType: json['permissionType'] as String,
      isGranted: json['isGranted'] as bool,
      grantedAt: DateTime.parse(json['grantedAt'] as String),
      revokedAt: json['revokedAt'] == null
          ? null
          : DateTime.parse(json['revokedAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$PermissionImplToJson(_$PermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyLinkId': instance.familyLinkId,
      'grantedTo': instance.grantedTo,
      'grantedBy': instance.grantedBy,
      'permissionType': instance.permissionType,
      'isGranted': instance.isGranted,
      'grantedAt': instance.grantedAt.toIso8601String(),
      'revokedAt': instance.revokedAt?.toIso8601String(),
      'notes': instance.notes,
    };
