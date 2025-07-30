// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioProfile _$StudioProfileFromJson(Map<String, dynamic> json) =>
    StudioProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      services:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      equipment:
          (json['equipment'] as List<dynamic>).map((e) => e as String).toList(),
      studioHours: json['studio_hours'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      website: json['website'] as String? ?? '',
      logoUrl: json['logo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$StudioProfileToJson(StudioProfile instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'address': instance.address,
    'phone': instance.phone,
    'email': instance.email,
    'website': instance.website,
    'services': instance.services,
    'equipment': instance.equipment,
    'studio_hours': instance.studioHours,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('logo_url', instance.logoUrl);
  writeNotNull('cover_image_url', instance.coverImageUrl);
  val['photos'] = instance.photos;
  val['is_active'] = instance.isActive;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}
