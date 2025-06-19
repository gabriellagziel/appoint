# APP-OINT Agents Guide

## Build & Run

```bash
flutter pub get
flutter run                # Android
dart run                  # CLI
flutter run -d chrome      # Web
```

## Testing

```bash
# Start Firebase emulators for Auth & Firestore
firebase emulators:start --only auth,firestore

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

