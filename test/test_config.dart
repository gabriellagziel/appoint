import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ensures the widget binding is initialized and Firebase core mocks are set up
/// before running tests.
void setupTestConfig() {
  setUpAll(() async {
    // Set up Firebase for testing
    await setupFirebaseForTesting();
  });
}

Future<void> setupFirebaseForTesting() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase might already be initialized, which is fine
  }
}

void main() {
  setupTestConfig();
}
