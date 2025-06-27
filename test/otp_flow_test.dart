import 'package:flutter_test/flutter_test.dart';

// Replace with the real file & widget name for your app's entrypoint
import './fake_firebase_setup.dart';

// Flutter widgets & material controls

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  testWidgets('OTP flow: send and verify code', (tester) async {}, skip: true);
}
