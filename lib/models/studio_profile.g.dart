// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudioProfileImpl _$$StudioProfileImplFromJson(Map<String, dynamic> json) =>
    _$StudioProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['owner_id'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      imageUrl: json['image_url'] as String?,
      isAdminFreeAccess: json['is_admin_free_access'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StudioProfileImplToJson(_$StudioProfileImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'owner_id': instance.ownerId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('address', instance.address);
  writeNotNull('phone', instance.phone);
  writeNotNull('email', instance.email);
  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('is_admin_free_access', instance.isAdminFreeAccess);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
