// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProvider _$BusinessProviderFromJson(Map<String, dynamic> json) =>
    BusinessProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      businessProfileId: json['business_profile_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      role: json['role'] as String?,
    );

Map<String, dynamic> _$BusinessProviderToJson(BusinessProvider instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('role', instance.role);
  val['business_profile_id'] = instance.businessProfileId;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}
