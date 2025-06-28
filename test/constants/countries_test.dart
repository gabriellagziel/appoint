import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/constants/countries.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('Countries', () {
    test('valid code returns name', () {
      expect(getCountryName('IL'), 'Israel');
    });

    test('invalid code returns Unknown', () {
      expect(getCountryName('XX'), 'Unknown');
    });
  });
}
