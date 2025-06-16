// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffAvailabilityImpl _$$StaffAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffAvailabilityImpl(
      staffId: json['staffId'] as String,
      date: const DateTimeConverter().fromJson(json['date'] as String),
      availableSlots: (json['availableSlots'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$StaffAvailabilityImplToJson(
        _$StaffAvailabilityImpl instance) =>
    <String, dynamic>{
      'staffId': instance.staffId,
      'date': const DateTimeConverter().toJson(instance.date),
      'availableSlots': instance.availableSlots,
    };
