import 'package:appoint/constants/languages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Languages', () {
    test('should contain expected languages', () {
      expect(supportedLanguages, contains('en'));
      expect(supportedLanguages, contains('es'));
      expect(supportedLanguages, contains('fr'));
    });

    test('recognizes supported language', () {
      expect(isSupportedLanguage('en'), isTrue);
    });

    test('rejects unsupported language', () {
      expect(isSupportedLanguage('xx'), isFalse);
    });
  });
}
