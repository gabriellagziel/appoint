// Replace with the real file & widget name for your app's entrypoint
import 'package:appoint/main.dart';
import 'package:appoint/services/custom_deep_link_service.dart';
import './test_setup.dart';

// Flutter widgets & material controls
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await registerFirebaseMock();
  });

  testWidgets('OTP flow: send and verify code', (tester) async {}, skip: true);
}
