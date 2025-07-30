// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffMemberImpl _$$StaffMemberImplFromJson(Map<String, dynamic> json) =>
    _$StaffMemberImpl(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$$StaffMemberImplToJson(_$StaffMemberImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'display_name': instance.displayName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photo_url', instance.photoUrl);
  return val;
}
