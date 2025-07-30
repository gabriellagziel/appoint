// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playtime_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaytimeGameImpl _$$PlaytimeGameImplFromJson(Map<String, dynamic> json) =>
    _$PlaytimeGameImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdBy: json['created_by'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PlaytimeGameImplToJson(_$PlaytimeGameImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'created_by': instance.createdBy,
    'status': instance.status,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}
