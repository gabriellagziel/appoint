import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// Formats dates and relative times using the current locale.
///
/// This wrapper makes it easy to support all locales configured in
/// `l10n.yaml` by delegating to the `intl` package.
class LocalizedDateFormatter {
  LocalizedDateFormatter(this._locale);

  /// Create a formatter from the generated [AppLocalizations].
  factory LocalizedDateFormatter.fromL10n(AppLocalizations l10n) => LocalizedDateFormatter(l10n.localeName);

  final String _locale;

  /// Format a calendar date like "Jan 5, 2024" respecting locale.
  String formatDate(DateTime date) => DateFormat.yMMMMEEEEd(_locale).format(date);

  /// Format the difference from [timestamp] to now in a human friendly form.
  String formatRelative(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) {
      return Intl.message('just now', name: 'justNow', locale: _locale);
    }
    if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return Intl.plural(
        minutes,
        one: '$minutes minute ago',
        other: '$minutes minutes ago',
        name: 'minutesAgo',
        args: [minutes],
        locale: _locale,
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
        locale: _locale,
      );
    }
    final days = diff.inDays;
    return Intl.plural(
      days,
      one: '$days day ago',
      other: '$days days ago',
      name: 'daysAgo',
      args: [days],
      locale: _locale,
    );
  }
}
