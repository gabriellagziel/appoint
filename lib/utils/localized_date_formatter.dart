import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

/// Formats dates using the current [AppLocalizations].
class LocalizedDateFormatter {
  final AppLocalizations l10n;

  const LocalizedDateFormatter(this.l10n);

  /// Format a calendar date like 'Jan 5, 2024'.
  String formatDate(DateTime date) {
    return DateFormat.yMMMd(l10n.localeName).format(date);
  }

  /// Format a relative time string such as '2 minutes ago'.
  String formatRelative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) {
      return l10n.justNow;
    } else if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return l10n.minutesAgo(minutes);
    } else if (diff.inHours < 24) {
      final hours = diff.inHours;
      return l10n.hoursAgo(hours);
    } else {
      final days = diff.inDays;
      return l10n.daysAgo(days);
    }
  }

  /// All locales supported by the app.
  static Iterable<Locale> get supportedLocales =>
      AppLocalizations.supportedLocales;
}
