# APP-OINT Agents Guide

## Build & Run

```bash
flutter pub get
flutter run                # Android
dart run                  # CLI
flutter run -d chrome      # Web
```

## Dev Container

The dev container (`.devcontainer/Dockerfile`) installs Flutter 3.32.0 and Dart
3.4.0 from pre-downloaded archives. Before building, place the required SDK
archives under `.devcontainer/sdk_archives` so no network download is needed.

## Testing

```bash
# Start Firebase emulators for Auth, Firestore & Storage
export FIREBASE_STORAGE_EMULATOR_HOST="localhost:9199"
firebase emulators:start --only auth,firestore,storage

# From project root:
dart test --coverage
```

## CI

* Use `dart test --coverage` for CI.
* In `test/test_setup.dart`, ensure you have:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  // ... all your tests
}
```

