import 'package:intl/intl.dart';

/// Utility class for locale-aware date formatting.
class LocalizedDateFormatter {
  LocalizedDateFormatter._();

  /// Formats [date] using the full year, month and day pattern for [locale].
  static String formatFullDate(DateTime date, {String? locale}) {
    final formatter = DateFormat.yMMMMd(locale);
    return formatter.format(date);
  }

  /// Returns a human readable relative time string for [date].
  /// For older dates (7+ days) falls back to [formatFullDate].
  static String formatRelativeTime(DateTime date, {String? locale}) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return formatFullDate(date, locale: locale);
    }
  }
}
