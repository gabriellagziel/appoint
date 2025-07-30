import 'package:flutter_test/flutter_test.dart';
import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Full Flow', () {
    test('placeholder', () async {
      // Placeholder for future login + booking simulation
    });
  });
}
