import 'package:appoint/constants/countries.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Countries', () {
    test('should contain expected countries', () {
      expect(countries, contains('United States'));
      expect(countries, contains('Canada'));
      expect(countries, contains('United Kingdom'));
    });

    test('valid code returns name', () {
      expect(getCountryName('IL'), 'Israel');
    });

    test('invalid code returns Unknown', () {
      expect(getCountryName('XX'), 'Unknown');
    });
  });
}
