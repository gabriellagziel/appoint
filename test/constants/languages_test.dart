import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/constants/languages.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('Languages', () {
    test('recognizes supported language', () {
      expect(isSupportedLanguage('en'), isTrue);
    });

    test('rejects unsupported language', () {
      expect(isSupportedLanguage('xx'), isFalse);
    });
  });
}
