// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeRange _$TimeRangeFromJson(Map<String, dynamic> json) => TimeRange(
      start: const TimeOfDayConverter().fromJson(json['start'] as String),
      end: const TimeOfDayConverter().fromJson(json['end'] as String),
      weekday: (json['weekday'] as num).toInt(),
    );

Map<String, dynamic> _$TimeRangeToJson(TimeRange instance) => <String, dynamic>{
      'start': const TimeOfDayConverter().toJson(instance.start),
      'end': const TimeOfDayConverter().toJson(instance.end),
      'weekday': instance.weekday,
    };

StaffAvailability _$StaffAvailabilityFromJson(Map<String, dynamic> json) =>
    StaffAvailability(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      availableSlots: (json['available_slots'] as List<dynamic>)
          .map((e) => TimeRange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StaffAvailabilityToJson(StaffAvailability instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_id': instance.profileId,
      'available_slots': instance.availableSlots,
    };
