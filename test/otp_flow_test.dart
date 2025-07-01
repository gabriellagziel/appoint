import 'package:flutter_test/flutter_test.dart';
import './fake_firebase_setup.dart';

// Flutter widgets & material controls

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('OTP flow: send and verify code', (final tester) async {}, skip: true);
}
