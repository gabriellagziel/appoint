// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_free_access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParentFreeAccessImpl _$$ParentFreeAccessImplFromJson(
        Map<String, dynamic> json) =>
    _$ParentFreeAccessImpl(
      id: json['id'] as String,
      parentPhoneNumber: json['parentPhoneNumber'] as String,
      status: $enumDecode(_$FreeAccessStatusEnumMap, json['status']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      grantedByAdminId: json['grantedByAdminId'] as String,
      grantedByAdminName: json['grantedByAdminName'] as String,
      grantedAt: DateTime.parse(json['grantedAt'] as String),
      notes: json['notes'] as String?,
      lastAccessedAt: json['lastAccessedAt'] == null
          ? null
          : DateTime.parse(json['lastAccessedAt'] as String),
      totalAccessCount: (json['totalAccessCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ParentFreeAccessImplToJson(
        _$ParentFreeAccessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentPhoneNumber': instance.parentPhoneNumber,
      'status': _$FreeAccessStatusEnumMap[instance.status]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'grantedByAdminId': instance.grantedByAdminId,
      'grantedByAdminName': instance.grantedByAdminName,
      'grantedAt': instance.grantedAt.toIso8601String(),
      'notes': instance.notes,
      'lastAccessedAt': instance.lastAccessedAt?.toIso8601String(),
      'totalAccessCount': instance.totalAccessCount,
    };

const _$FreeAccessStatusEnumMap = {
  FreeAccessStatus.active: 'active',
  FreeAccessStatus.inactive: 'inactive',
  FreeAccessStatus.expired: 'expired',
};
