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
          const DateTimeConverter().fromJson(json['start_time'] as String),
      endTime: const DateTimeConverter().fromJson(json['end_time'] as String),
      description: json['description'] as String?,
      provider: json['provider'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'start_time': const DateTimeConverter().toJson(instance.startTime),
    'end_time': const DateTimeConverter().toJson(instance.endTime),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('provider', instance.provider);
  writeNotNull('location', instance.location);
  return val;
}
