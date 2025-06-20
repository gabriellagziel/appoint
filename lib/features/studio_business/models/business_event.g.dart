// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessEventImpl _$$BusinessEventImplFromJson(Map<String, dynamic> json) =>
    _$BusinessEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as String),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as String),
    );

Map<String, dynamic> _$$BusinessEventImplToJson(_$BusinessEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
    };
