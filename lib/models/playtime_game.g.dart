// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playtime_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaytimeGameImpl _$$PlaytimeGameImplFromJson(Map<String, dynamic> json) =>
    _$PlaytimeGameImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PlaytimeGameImplToJson(_$PlaytimeGameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdBy': instance.createdBy,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
