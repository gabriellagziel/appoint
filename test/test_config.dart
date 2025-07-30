import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'test_setup_init.dart';

/// Ensures the widget binding is initialized and Firebase core mocks are set up
/// before running tests.
void setupTestConfig() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  initializeHttpOverrides();
}

void main() {
  setupTestConfig();
}
