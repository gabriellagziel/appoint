import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'business_availability.freezed.dart';
part 'business_availability.g.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();
  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) =>
      '${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}';
}

@freezed
class BusinessAvailability with _$BusinessAvailability {
  const factory BusinessAvailability({
    required int weekday, // 0-6 (Sunday-Saturday)
    required bool isOpen,
    @TimeOfDayConverter() required TimeOfDay start,
    @TimeOfDayConverter() required TimeOfDay end,
  }) = _BusinessAvailability;

  factory BusinessAvailability.fromJson(Map<String, dynamic> json) =>
      _$BusinessAvailabilityFromJson(json);
}
