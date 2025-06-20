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
      website: json['website'] as String? ?? '',
      services:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      equipment:
          (json['equipment'] as List<dynamic>).map((e) => e as String).toList(),
      studioHours: json['studioHours'] as Map<String, dynamic>,
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudioProfileToJson(StudioProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'services': instance.services,
      'equipment': instance.equipment,
      'studioHours': instance.studioHours,
      'logoUrl': instance.logoUrl,
      'coverImageUrl': instance.coverImageUrl,
      'photos': instance.photos,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
