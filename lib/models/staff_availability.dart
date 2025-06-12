import 'dart:core';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'time_of_day_converter.dart';

part 'staff_availability.freezed.dart';
part 'staff_availability.g.dart';

@freezed
class StaffAvailability with _$StaffAvailability {
  const factory StaffAvailability({
    required String staffId,
    @JsonKey(
      fromJson: DateTime.parse,
      toJson:   (DateTime d) => d.toIso8601String(),
    )
    required DateTime date,
    @TimeOfDayConverter() required List<TimeOfDay> availableSlots,
  }) = _StaffAvailability;

  factory StaffAvailability.fromJson(Map<String, dynamic> json) =>
      _$StaffAvailabilityFromJson(json);
}
