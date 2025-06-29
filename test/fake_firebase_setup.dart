import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_config.dart';
import 'test_setup.dart';

/// Initializes Firebase mocks for widget tests.
Future<FirebaseApp> initializeTestFirebase() async {
  setupTestConfig();
  setupFirebaseMocks();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  return Firebase.app();
}
