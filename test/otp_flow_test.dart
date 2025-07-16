import 'package:flutter_test/flutter_test.dart';
import 'firebase_test_helper.dart';

// Flutter widgets & material controls

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  testWidgets('OTP flow: send and verify code', (tester) async {});
}
