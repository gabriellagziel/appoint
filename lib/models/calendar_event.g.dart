// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) => CalendarEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      start: const DateTimeConverter().fromJson(json['start'] as String),
      end: const DateTimeConverter().fromJson(json['end'] as String),
      description: json['description'] as String,
      provider: json['provider'] as String,
    );

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start': const DateTimeConverter().toJson(instance.start),
      'end': const DateTimeConverter().toJson(instance.end),
      'description': instance.description,
      'provider': instance.provider,
    };
