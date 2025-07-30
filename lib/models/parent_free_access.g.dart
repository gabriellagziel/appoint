// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_free_access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParentFreeAccessImpl _$$ParentFreeAccessImplFromJson(
        Map<String, dynamic> json) =>
    _$ParentFreeAccessImpl(
      id: json['id'] as String,
      parentPhoneNumber: json['parent_phone_number'] as String,
      status: $enumDecode(_$FreeAccessStatusEnumMap, json['status']),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      grantedByAdminId: json['granted_by_admin_id'] as String,
      grantedByAdminName: json['granted_by_admin_name'] as String,
      grantedAt: DateTime.parse(json['granted_at'] as String),
      notes: json['notes'] as String?,
      lastAccessedAt: json['last_accessed_at'] == null
          ? null
          : DateTime.parse(json['last_accessed_at'] as String),
      totalAccessCount: (json['total_access_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ParentFreeAccessImplToJson(
    _$ParentFreeAccessImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'parent_phone_number': instance.parentPhoneNumber,
    'status': _$FreeAccessStatusEnumMap[instance.status]!,
    'start_date': instance.startDate.toIso8601String(),
    'end_date': instance.endDate.toIso8601String(),
    'granted_by_admin_id': instance.grantedByAdminId,
    'granted_by_admin_name': instance.grantedByAdminName,
    'granted_at': instance.grantedAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notes', instance.notes);
  writeNotNull('last_accessed_at', instance.lastAccessedAt?.toIso8601String());
  writeNotNull('total_access_count', instance.totalAccessCount);
  return val;
}

const _$FreeAccessStatusEnumMap = {
  FreeAccessStatus.active: 'active',
  FreeAccessStatus.inactive: 'inactive',
  FreeAccessStatus.expired: 'expired',
};
