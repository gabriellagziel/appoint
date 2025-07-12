import 'package:flutter/material.dart';

/// Represents a time range for availability
class TimeRange {
  TimeRange({required this.start, required this.end});
  final TimeOfDay start;
  final TimeOfDay end;

  /// Check if the time range is valid (end time is after start time)
  bool get isValid {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }
}

/// Stub for updating a day's availability
void updateDay(availability, final TimeRange range) {
  // TODO(username): Implement this featurent business availability logic
}

/// Business-specific theme
class BusinessTheme {
  static ThemeData get businessTheme => ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        // TODO(username): Implement this featurene branding
      );
}
