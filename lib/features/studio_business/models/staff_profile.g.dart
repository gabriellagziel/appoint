// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffProfile _$StaffProfileFromJson(Map<String, dynamic> json) => StaffProfile(
      id: json['id'] as String,
      businessProfileId: json['businessProfileId'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      services:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StaffProfileToJson(StaffProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessProfileId': instance.businessProfileId,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'services': instance.services,
      'hourlyRate': instance.hourlyRate,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
