// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as String),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as String),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
    };
