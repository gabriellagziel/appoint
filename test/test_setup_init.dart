import 'package:firebase_storage/firebase_storage.dart';
import 'test_config.dart';

/// Initializes Firebase and configures the storage emulator before tests run.
void main() {
  setupTestConfig();

  // Connect Firebase Storage to the local emulator.
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
}
