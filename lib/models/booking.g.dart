// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      staffId: json['staff_id'] as String,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      dateTime: const DateTimeConverter().fromJson(json['dateTime'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      notes: json['notes'] as String?,
      isConfirmed: json['is_confirmed'] as bool? ?? false,
      createdAt: _$JsonConverterFromJson<String, DateTime>(
          json['created_at'], const DateTimeConverter().fromJson),
      businessProfileId: json['business_profile_id'] as String?,
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'staff_id': instance.staffId,
    'service_id': instance.serviceId,
    'service_name': instance.serviceName,
    'dateTime': const DateTimeConverter().toJson(instance.dateTime),
    'duration': instance.duration.inMicroseconds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notes', instance.notes);
  val['is_confirmed'] = instance.isConfirmed;
  writeNotNull(
      'created_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.createdAt, const DateTimeConverter().toJson));
  writeNotNull('business_profile_id', instance.businessProfileId);
  return val;
}

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
