import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_setup.dart';

/// Initializes Firebase mocks for widget tests.
Future<FirebaseApp> initializeTestFirebase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await registerFirebaseMock();
  return Firebase.app();
}
