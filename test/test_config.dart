import 'package:flutter_test/flutter_test.dart';
import 'package:REDACTED_TOKEN/test.dart';
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
