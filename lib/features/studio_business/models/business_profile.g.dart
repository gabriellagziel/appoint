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
      website: json['website'] as String? ?? '',
      services:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      businessHours: json['businessHours'] as Map<String, dynamic>,
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAdminFreeAccess: json['isAdminFreeAccess'] as bool?,
    );

Map<String, dynamic> _$BusinessProfileToJson(BusinessProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'services': instance.services,
      'businessHours': instance.businessHours,
      'logoUrl': instance.logoUrl,
      'coverImageUrl': instance.coverImageUrl,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'ownerId': instance.ownerId,
      'imageUrl': instance.imageUrl,
      'isAdminFreeAccess': instance.isAdminFreeAccess,
    };
