import 'package:flutter_test/flutter_test.dart';
import 'package:REDACTED_TOKEN/test.dart';

/// Ensures the widget binding is initialized and Firebase core mocks are set up
/// before running tests.
void setupTestConfig() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
}

void main() {
  setupTestConfig();
}
