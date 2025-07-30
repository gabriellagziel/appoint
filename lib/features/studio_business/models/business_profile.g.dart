// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) =>
    BusinessProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      services:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      businessHours: json['business_hours'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      website: json['website'] as String? ?? '',
      logoUrl: json['logo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      ownerId: json['owner_id'] as String?,
      imageUrl: json['image_url'] as String?,
      isAdminFreeAccess: json['is_admin_free_access'] as bool?,
    );

Map<String, dynamic> _$BusinessProfileToJson(BusinessProfile instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'address': instance.address,
    'phone': instance.phone,
    'email': instance.email,
    'website': instance.website,
    'services': instance.services,
    'business_hours': instance.businessHours,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('logo_url', instance.logoUrl);
  writeNotNull('cover_image_url', instance.coverImageUrl);
  val['is_active'] = instance.isActive;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  writeNotNull('owner_id', instance.ownerId);
  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('is_admin_free_access', instance.isAdminFreeAccess);
  return val;
}
