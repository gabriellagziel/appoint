// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as String),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as String),
      description: json['description'] as String?,
      provider: json['provider'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'description': instance.description,
      'provider': instance.provider,
      'location': instance.location,
    };
