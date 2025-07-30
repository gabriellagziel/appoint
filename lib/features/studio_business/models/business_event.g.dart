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
          const DateTimeConverter().fromJson(json['start_time'] as String),
      endTime: const DateTimeConverter().fromJson(json['end_time'] as String),
    );

Map<String, dynamic> _$$BusinessEventImplToJson(_$BusinessEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'start_time': const DateTimeConverter().toJson(instance.startTime),
      'end_time': const DateTimeConverter().toJson(instance.endTime),
    };
