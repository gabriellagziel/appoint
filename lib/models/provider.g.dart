// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProvider _$BusinessProviderFromJson(Map<String, dynamic> json) =>
    BusinessProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String?,
      businessProfileId: json['businessProfileId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BusinessProviderToJson(BusinessProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'businessProfileId': instance.businessProfileId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
