import 'package:appoint/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

/// Test driver app for integration tests
/// This file is used by flutter drive for integration testing
void main() {
  // This line enables the Flutter Driver extension.
  enableFlutterDriverExtension();

  // Launch the app.
  app.main();
}
