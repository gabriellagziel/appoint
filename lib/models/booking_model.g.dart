// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      staffId: json['staff_id'] as String,
      serviceId: json['service_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'staff_id': instance.staffId,
      'service_id': instance.serviceId,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
    };
