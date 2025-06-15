// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffAvailabilityImpl _$$StaffAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffAvailabilityImpl(
      staffId: json['staffId'] as String,
      availableFrom:
          const DateTimeConverter().fromJson(json['availableFrom'] as String),
      availableTo:
          const DateTimeConverter().fromJson(json['availableTo'] as String),
    );

Map<String, dynamic> _$$StaffAvailabilityImplToJson(
        _$StaffAvailabilityImpl instance) =>
    <String, dynamic>{
      'staffId': instance.staffId,
      'availableFrom': const DateTimeConverter().toJson(instance.availableFrom),
      'availableTo': const DateTimeConverter().toJson(instance.availableTo),
    };
