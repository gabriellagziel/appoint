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
      availableSlots: (json['availableSlots'] as List<dynamic>?)
          ?.map((e) => const TimeOfDayConverter().fromJson(e as String))
          .toList(),
    );

Map<String, dynamic> _$$StaffAvailabilityImplToJson(
        _$StaffAvailabilityImpl instance) =>
    <String, dynamic>{
      'staffId': instance.staffId,
      'availableFrom': const DateTimeConverter().toJson(instance.availableFrom),
      'availableTo': const DateTimeConverter().toJson(instance.availableTo),
      'availableSlots': instance.availableSlots
          ?.map(const TimeOfDayConverter().toJson)
          .toList(),
    };
