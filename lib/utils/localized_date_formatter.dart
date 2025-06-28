import 'package:intl/intl.dart';

/// Provides relative date formatting utilities.
class LocalizedDateFormatter {
  /// Returns a human friendly time string like "2 minutes ago" for the given
  /// [timestamp].
  static String relativeTimeFromNow(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return Intl.message('just now', name: 'justNow');
    }

    if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return Intl.plural(
        minutes,
        one: '$minutes minute ago',
        other: '$minutes minutes ago',
        name: 'minutesAgo',
        args: [minutes],
        examples: const {'minutes': 2},
      );
    }

    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return Intl.plural(
        hours,
        one: '$hours hour ago',
        other: '$hours hours ago',
        name: 'hoursAgo',
        args: [hours],
        examples: const {'hours': 2},
      );
    }

    final days = diff.inDays;
    return Intl.plural(
      days,
      one: '$days day ago',
      other: '$days days ago',
      name: 'daysAgo',
      args: [days],
      examples: const {'days': 2},
    );
  }
}
