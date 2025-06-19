@Skip('Pending Firebase setup conflicts')
import 'package:flutter_test/flutter_test.dart';

// Replace with the real file & widget name for your app's entrypoint
import './test_setup.dart';

// Flutter widgets & material controls

void main() {
  setUpAll(() async {
    await registerFirebaseMock();
  });

  testWidgets('OTP flow: send and verify code', (tester) async {}, skip: true);
}
