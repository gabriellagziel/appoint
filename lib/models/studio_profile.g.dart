// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudioProfileImpl _$$StudioProfileImplFromJson(Map<String, dynamic> json) =>
    _$StudioProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAdminFreeAccess: json['isAdminFreeAccess'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StudioProfileImplToJson(_$StudioProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerId': instance.ownerId,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'isAdminFreeAccess': instance.isAdminFreeAccess,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
