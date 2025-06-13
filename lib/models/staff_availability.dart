import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'time_of_day_converter.dart';

part 'staff_availability.freezed.dart';
part 'staff_availability.g.dart';

String _dateToIso(DateTime d) => d.toIso8601String();

@freezed
class StaffAvailability with _$StaffAvailability {
  const factory StaffAvailability({
    required String staffId,
    @JsonKey(fromJson: DateTime.parse, toJson: _dateToIso)
    required DateTime date,
    // TODO: Re-add TimeOfDayConverter once generator issues are resolved
    @TimeOfDayConverter() required List<TimeOfDay> availableSlots,
  }) = _StaffAvailability;

  factory StaffAvailability.fromJson(Map<String, dynamic> json) =>
      _$StaffAvailabilityFromJson(json);
}
