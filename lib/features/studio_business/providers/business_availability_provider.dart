import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/studio_business/models/business_availability.dart';
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

  void toggleOpen(final int weekday, final bool isOpen) {
    state = [
      for (final avail in state)
        if (avail.weekday == weekday) avail.copyWith(isOpen: isOpen) else avail
    ];
  }

  void setHours(final int weekday, final TimeOfDay start, final TimeOfDay end) {
    state = [
      for (final avail in state)
        if (avail.weekday == weekday)
          avail.copyWith(start: start, end: end)
        else
          avail
    ];
  }

  void loadConfiguration() {
    // TODO: Implement loading configuration from backend
  }

  void updateDay(final int weekday,
      {final bool? isOpen, final TimeOfDay? start, final TimeOfDay? end}) {
    // TODO: Implement updating a single day's availability
  }
}

final businessAvailabilityProvider = StateNotifierProvider<
    BusinessAvailabilityNotifier, List<BusinessAvailability>>(
  (final ref) => BusinessAvailabilityNotifier(),
);
