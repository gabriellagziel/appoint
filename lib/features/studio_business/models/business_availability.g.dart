// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessAvailabilityImpl _$$BusinessAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessAvailabilityImpl(
      weekday: (json['weekday'] as num).toInt(),
      isOpen: json['isOpen'] as bool,
      start: const TimeOfDayConverter().fromJson(json['start'] as String),
      end: const TimeOfDayConverter().fromJson(json['end'] as String),
    );

Map<String, dynamic> _$$BusinessAvailabilityImplToJson(
        _$BusinessAvailabilityImpl instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'isOpen': instance.isOpen,
      'start': const TimeOfDayConverter().toJson(instance.start),
      'end': const TimeOfDayConverter().toJson(instance.end),
    };
