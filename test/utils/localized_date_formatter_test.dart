import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:appoint/utils/localized_date_formatter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('fr');
    await initializeDateFormatting('he');
    await initializeDateFormatting('ja');
  });

  group('LocalizedDateFormatter', () {
    test('formatFullDate returns localized strings', () {
      final date = DateTime(2023, 9, 10);
      expect(LocalizedDateFormatter.formatFullDate(date, locale: 'en'),
          'September 10, 2023');
      expect(LocalizedDateFormatter.formatFullDate(date, locale: 'fr'),
          '10 septembre 2023');
      expect(LocalizedDateFormatter.formatFullDate(date, locale: 'he'),
          '10 \u05E1\u05E4\u05D8\u05DE\u05D1\u05E8 2023');
      expect(LocalizedDateFormatter.formatFullDate(date, locale: 'ja'),
          '2023\u5E749\u670810\u65E5');
    });

    test('formatRelativeTime returns human readable string', () {
      final base = DateTime.now().subtract(const Duration(minutes: 5));
      expect(
        LocalizedDateFormatter.formatRelativeTime(base, locale: 'en'),
        '5 minutes ago',
      );
    });
  });
}
