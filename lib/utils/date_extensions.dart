import 'package:intl/intl.dart';

/// Extension methods for DateTime to provide common date utilities
extension DateExtensions on DateTime {
  /// Returns a booking key in the format yyyyMMdd
  /// Example: 2025-03-09 -> "20250309"
  String toBookingKey() => DateFormat('yyyyMMdd').format(this);

  /// Returns the start of the week (Monday) for this date
  /// Example: Wednesday 2025-11-12 -> Monday 2025-11-10
  DateTime startOfWeek() {
    final daysFromMonday = weekday - DateTime.monday;
    return subtract(Duration(days: daysFromMonday));
  }

  /// Returns the end of the week (Sunday) for this date
  /// Example: Wednesday 2025-11-12 -> Sunday 2025-11-16
  DateTime endOfWeek() {
    final daysToSunday = DateTime.sunday - weekday;
    return add(Duration(days: daysToSunday));
  }

  /// Checks if two dates are the same day (ignoring time)
  /// Example: 2025-07-05T23:30:00Z and 2025-07-05T00:05:00Z -> true
  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  /// Returns true if this date is today
  bool get isToday => isSameDay(DateTime.now());

  /// Returns true if this date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  /// Returns true if this date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Returns the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns the start of the month
  DateTime get startOfMonth => DateTime(year, month);

  /// Returns the end of the month
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// Returns the start of the year
  DateTime get startOfYear => DateTime(year);

  /// Returns the end of the year
  DateTime get endOfYear => DateTime(year, 12, 31);

  /// Returns a formatted date string for display
  /// Example: "March 9, 2025"
  String toDisplayDate() => DateFormat.yMMMMd().format(this);

  /// Returns a formatted time string for display
  /// Example: "14:30"
  String toDisplayTime() => DateFormat.Hm().format(this);

  /// Returns a formatted date and time string for display
  /// Example: "March 9, 2025 at 2:30 PM"
  String toDisplayDateTime() => DateFormat.yMMMMd().add_jm().format(this);

  /// Returns the number of days between this date and another date
  int daysDifference(DateTime other) {
    final thisDate = DateTime(year, month, day);
    final otherDate = DateTime(other.year, other.month, other.day);
    return thisDate.difference(otherDate).inDays.abs();
  }

  /// Returns true if this date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Returns true if this date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Returns the age in years from this date to now
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Returns a human-readable relative time string
  /// Example: "2 hours ago", "in 3 days"
  String toRelativeTime() {
    final now = DateTime.now();
    final timeDiff = difference(now);

    if (timeDiff.inMinutes < 1) {
      return 'just now';
    } else if (timeDiff.inMinutes < 60) {
      final minutes = timeDiff.inMinutes.abs();
      return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
    } else if (timeDiff.inHours < 24) {
      final hours = timeDiff.inHours.abs();
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    } else if (timeDiff.inDays < 7) {
      final days = timeDiff.inDays.abs();
      return days == 1 ? '1 day ago' : '$days days ago';
    } else {
      return toDisplayDate();
    }
  }
}
