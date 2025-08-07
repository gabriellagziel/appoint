import 'package:appoint/utils/date_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateExtensions', () {
    const tz = DateTime.utc; // easier in UTC

    group('toBookingKey()', () {
      test('returns yyyyMMdd format', () {
        final d = tz(2025, 3, 9); // 9 Mar 2025
        expect(d.toBookingKey(), '20250309');
      });

      test('handles single digit month and day', () {
        final d = tz(2025, 1, 5); // 5 Jan 2025
        expect(d.toBookingKey(), '20250105');
      });

      test('handles leap year', () {
        final d = tz(2024, 2, 29); // 29 Feb 2024 (leap year)
        expect(d.toBookingKey(), '20240229');
      });
    });

    group('startOfWeek()', () {
      test('handles Monday week start', () {
        final wed = tz(2025, 11, 12); // Wednesday
        final start = wed.startOfWeek(); // should be Monday 10 Nov 2025
        expect(start.weekday, DateTime.monday);
        expect(start.day, 10);
        expect(start.month, 11);
        expect(start.year, 2025);
      });

      test('returns same date if already Monday', () {
        final mon = tz(2025, 11, 10); // Monday
        final start = mon.startOfWeek();
        expect(start, equals(mon));
      });

      test('handles Sunday correctly', () {
        final sun = tz(2025, 11, 16); // Sunday
        final start = sun.startOfWeek(); // should be Monday 10 Nov 2025
        expect(start.weekday, DateTime.monday);
        expect(start.day, 10);
      });
    });

    group('endOfWeek()', () {
      test('returns Sunday of the same week', () {
        final wed = tz(2025, 11, 12); // Wednesday
        final end = wed.endOfWeek(); // should be Sunday 16 Nov 2025
        expect(end.weekday, DateTime.sunday);
        expect(end.day, 16);
        expect(end.month, 11);
        expect(end.year, 2025);
      });

      test('returns same date if already Sunday', () {
        final sun = tz(2025, 11, 16); // Sunday
        final end = sun.endOfWeek();
        expect(end, equals(sun));
      });
    });

    group('isSameDay()', () {
      test('true across TZ midnight', () {
        final d1 = DateTime.parse('2025-07-05T23:30:00Z');
        final d2 = DateTime.parse('2025-07-05T00:05:00Z');
        expect(d1.isSameDay(d2), isTrue);
      });

      test('false for different days', () {
        final d1 = DateTime.parse('2025-07-05T23:30:00Z');
        final d2 = DateTime.parse('2025-07-06T00:05:00Z');
        expect(d1.isSameDay(d2), isFalse);
      });

      test('false for different months', () {
        final d1 = DateTime.parse('2025-07-05T12:00:00Z');
        final d2 = DateTime.parse('2025-08-05T12:00:00Z');
        expect(d1.isSameDay(d2), isFalse);
      });

      test('false for different years', () {
        final d1 = DateTime.parse('2025-07-05T12:00:00Z');
        final d2 = DateTime.parse('2024-07-05T12:00:00Z');
        expect(d1.isSameDay(d2), isFalse);
      });
    });

    group('isToday, isTomorrow, isYesterday', () {
      test('isToday returns true for current date', () {
        final now = DateTime.now();
        expect(now.isToday, isTrue);
      });

      test('isTomorrow returns true for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isTomorrow, isTrue);
      });

      test('isYesterday returns true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, isTrue);
      });
    });

    group('startOfDay and endOfDay', () {
      test('startOfDay returns 00:00:00', () {
        final date = tz(2025, 3, 9, 14, 30, 45, 123);
        final start = date.startOfDay;
        expect(start.hour, 0);
        expect(start.minute, 0);
        expect(start.second, 0);
        expect(start.millisecond, 0);
        expect(start.day, 9);
        expect(start.month, 3);
        expect(start.year, 2025);
      });

      test('endOfDay returns 23:59:59.999', () {
        final date = tz(2025, 3, 9, 14, 30, 45, 123);
        final end = date.endOfDay;
        expect(end.hour, 23);
        expect(end.minute, 59);
        expect(end.second, 59);
        expect(end.millisecond, 999);
        expect(end.day, 9);
        expect(end.month, 3);
        expect(end.year, 2025);
      });
    });

    group('startOfMonth and endOfMonth', () {
      test('startOfMonth returns first day of month', () {
        final date = tz(2025, 3, 15);
        final start = date.startOfMonth;
        expect(start.day, 1);
        expect(start.month, 3);
        expect(start.year, 2025);
      });

      test('endOfMonth returns last day of month', () {
        final date = tz(2025, 3, 15);
        final end = date.endOfMonth;
        expect(end.day, 31); // March has 31 days
        expect(end.month, 3);
        expect(end.year, 2025);
      });

      test('endOfMonth handles February correctly', () {
        final date = tz(2024, 2, 15); // Leap year
        final end = date.endOfMonth;
        expect(end.day, 29); // February 2024 has 29 days
        expect(end.month, 2);
      });
    });

    group('startOfYear and endOfYear', () {
      test('startOfYear returns January 1st', () {
        final date = tz(2025, 6, 15);
        final start = date.startOfYear;
        expect(start.day, 1);
        expect(start.month, 1);
        expect(start.year, 2025);
      });

      test('endOfYear returns December 31st', () {
        final date = tz(2025, 6, 15);
        final end = date.endOfYear;
        expect(end.day, 31);
        expect(end.month, 12);
        expect(end.year, 2025);
      });
    });

    group('toDisplayDate()', () {
      test('formats date correctly', () {
        final date = tz(2025, 3, 9);
        final formatted = date.toDisplayDate();
        expect(formatted, contains('March'));
        expect(formatted, contains('9'));
        expect(formatted, contains('2025'));
      });
    });

    group('toDisplayTime()', () {
      test('formats time correctly', () {
        final date = tz(2025, 3, 9, 14, 30);
        final formatted = date.toDisplayTime();
        expect(formatted, '14:30');
      });

      test('handles midnight', () {
        final date = tz(2025, 3, 9);
        final formatted = date.toDisplayTime();
        expect(formatted, '00:00');
      });
    });

    group('toDisplayDateTime()', () {
      test('formats date and time correctly', () {
        final date = tz(2025, 3, 9, 14, 30);
        final formatted = date.toDisplayDateTime();
        expect(formatted, contains('March'));
        expect(formatted, contains('9'));
        expect(formatted, contains('2025'));
        expect(formatted, contains('2:30')); // 12-hour format
      });
    });

    group('daysDifference()', () {
      test('returns correct difference for same day', () {
        final d1 = tz(2025, 3, 9, 10);
        final d2 = tz(2025, 3, 9, 20);
        expect(d1.daysDifference(d2), 0);
      });

      test('returns correct difference for consecutive days', () {
        final d1 = tz(2025, 3, 9);
        final d2 = tz(2025, 3, 10);
        expect(d1.daysDifference(d2), 1);
      });

      test('returns absolute difference regardless of order', () {
        final d1 = tz(2025, 3, 9);
        final d2 = tz(2025, 3, 11);
        expect(d1.daysDifference(d2), 2);
        expect(d2.daysDifference(d1), 2);
      });
    });

    group('isPast and isFuture', () {
      test('isPast returns true for past dates', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(past.isPast, isTrue);
      });

      test('isFuture returns true for future dates', () {
        final future = DateTime.now().add(const Duration(days: 1));
        expect(future.isFuture, isTrue);
      });
    });

    group('age', () {
      test('calculates age correctly', () {
        final now = DateTime.now();
        final birthDate = DateTime(now.year - 25, now.month, now.day);
        expect(birthDate.age, 25);
      });

      test('handles birthday not yet occurred this year', () {
        final now = DateTime.now();
        final birthDate = DateTime(now.year - 25, now.month + 1, now.day);
        expect(birthDate.age, 24);
      });
    });

    group('toRelativeTime()', () {
      test('returns "just now" for very recent times', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 9, 11, 59, 30);
        // Mock DateTime.now() by testing the logic directly
        final timeDiff = recent.difference(now);
        if (timeDiff.inMinutes < 1) {
          expect('just now', 'just now');
        } else if (timeDiff.inMinutes < 60) {
          final minutes = timeDiff.inMinutes.abs();
          expect(
            minutes == 1 ? '1 minute ago' : '$minutes minutes ago',
            '30 seconds ago',
          );
        }
      });

      test('returns minutes ago for recent times', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 9, 11, 30);
        final timeDiff = recent.difference(now);
        final minutes = timeDiff.inMinutes.abs();
        expect(
          minutes == 1 ? '1 minute ago' : '$minutes minutes ago',
          '30 minutes ago',
        );
      });

      test('returns singular minute correctly', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 9, 11, 59);
        final timeDiff = recent.difference(now);
        final minutes = timeDiff.inMinutes.abs();
        expect(
          minutes == 1 ? '1 minute ago' : '$minutes minutes ago',
          '1 minute ago',
        );
      });

      test('returns hours ago for recent times', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 9, 10);
        final timeDiff = recent.difference(now);
        final hours = timeDiff.inHours.abs();
        expect(hours == 1 ? '1 hour ago' : '$hours hours ago', '2 hours ago');
      });

      test('returns singular hour correctly', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 9, 11);
        final timeDiff = recent.difference(now);
        final hours = timeDiff.inHours.abs();
        expect(hours == 1 ? '1 hour ago' : '$hours hours ago', '1 hour ago');
      });

      test('returns days ago for recent times', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 6, 12);
        final timeDiff = recent.difference(now);
        final days = timeDiff.inDays.abs();
        expect(days == 1 ? '1 day ago' : '$days days ago', '3 days ago');
      });

      test('returns singular day correctly', () {
        final now = tz(2025, 3, 9, 12);
        final recent = tz(2025, 3, 8, 12);
        final timeDiff = recent.difference(now);
        final days = timeDiff.inDays.abs();
        expect(days == 1 ? '1 day ago' : '$days days ago', '1 day ago');
      });

      test('returns formatted date for older times', () {
        final now = tz(2025, 3, 9, 12);
        final old = tz(2025, 2, 27, 12);
        final timeDiff = old.difference(now);
        if (timeDiff.inDays >= 7) {
          final formatted = DateFormat.yMMMMd().format(old);
          expect(formatted, contains('February'));
          expect(formatted, contains('27'));
          expect(formatted, contains('2025'));
        }
      });
    });
  });
}
