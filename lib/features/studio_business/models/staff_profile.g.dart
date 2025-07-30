// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffProfile _$StaffProfileFromJson(Map<String, dynamic> json) => StaffProfile(
      id: json['id'] as String,
      businessProfileId: json['business_profile_id'] as String,
      name: json['name'] as String,
      services:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      photoUrl: json['photo_url'] as String?,
      bio: json['bio'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StaffProfileToJson(StaffProfile instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'business_profile_id': instance.businessProfileId,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photo_url', instance.photoUrl);
  writeNotNull('bio', instance.bio);
  val['services'] = instance.services;
  val['hourly_rate'] = instance.hourlyRate;
  val['is_active'] = instance.isActive;
  val['created_at'] = instance.createdAt.toIso8601String();
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
