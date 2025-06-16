// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      staffId: json['staffId'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      dateTime: const DateTimeConverter().fromJson(json['dateTime'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      notes: json['notes'] as String?,
      isConfirmed: json['isConfirmed'] as bool? ?? false,
      createdAt: _$JsonConverterFromJson<String, DateTime>(
          json['createdAt'], const DateTimeConverter().fromJson),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'staffId': instance.staffId,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'dateTime': const DateTimeConverter().toJson(instance.dateTime),
      'duration': instance.duration.inMicroseconds,
      'notes': instance.notes,
      'isConfirmed': instance.isConfirmed,
      'createdAt': _$JsonConverterToJson<String, DateTime>(
          instance.createdAt, const DateTimeConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
