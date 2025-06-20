import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_availability.dart';
import 'package:flutter/material.dart';

class BusinessAvailabilityNotifier
    extends StateNotifier<List<BusinessAvailability>> {
  BusinessAvailabilityNotifier()
      : super([
          for (int i = 0; i < 7; i++)
            BusinessAvailability(
              weekday: i,
              isOpen: i != 0, // Sunday (0) is closed by default
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 17, minute: 0),
            ),
        ]);

  void toggleOpen(int weekday, bool isOpen) {
    state = [
      for (final avail in state)
        if (avail.weekday == weekday) avail.copyWith(isOpen: isOpen) else avail
    ];
  }

  void setHours(int weekday, TimeOfDay start, TimeOfDay end) {
    state = [
      for (final avail in state)
        if (avail.weekday == weekday)
          avail.copyWith(start: start, end: end)
        else
          avail
    ];
  }
}

final businessAvailabilityProvider = StateNotifierProvider<
    BusinessAvailabilityNotifier, List<BusinessAvailability>>(
  (ref) => BusinessAvailabilityNotifier(),
);
