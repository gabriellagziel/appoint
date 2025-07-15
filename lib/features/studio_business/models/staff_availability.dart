import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_availability.g.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();
  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) =>
      '${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}';
}

@JsonSerializable()
class TimeRange { // 0-6 (Sunday-Saturday)

  TimeRange({
    required this.start,
    required this.end,
    required this.weekday,
  });

  factory TimeRange.fromJson(Map<String, dynamic> json) =>
      _$TimeRangeFromJson(json);
  @TimeOfDayConverter()
  final TimeOfDay start;
  @TimeOfDayConverter()
  final TimeOfDay end;
  final int weekday;
  Map<String, dynamic> toJson() => _$TimeRangeToJson(this);
}

@JsonSerializable()
class StaffAvailability {

  StaffAvailability({
    required this.id,
    required this.profileId,
    required this.availableSlots,
  });

  factory StaffAvailability.fromJson(Map<String, dynamic> json) =>
      _$StaffAvailabilityFromJson(json);
  final String id;
  final String profileId;
  final List<TimeRange> availableSlots;
  Map<String, dynamic> toJson() => _$StaffAvailabilityToJson(this);
}
