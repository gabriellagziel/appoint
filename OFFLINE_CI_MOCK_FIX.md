# Offline CI Mock Fix Options

This guide describes two ways to satisfy the methods expected by the offline CI tests.

## Option 1: Mockito code generation (recommended)

1. Update `pubspec.yaml`:

```diff
@@
 dev_dependencies:
   integration_test: ^1.0.0
+  mockito: ^5.4.0
+  build_runner: ^2.4.0
```

2. Create `test/mocks.dart`:

```dart
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_crashlytics_platform_interface/firebase_crashlytics_platform_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:appoint/infra/firestore_service.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/infra/firebase_storage_service.dart';

@GenerateMocks([
  FirebaseFirestorePlatform,
  FirebaseCrashlyticsPlatform,
  FilePicker,
  FirestoreService,
  AuthService,
  FirebaseStorageService,
])
void main() {}
```

3. Run `flutter pub get` and then:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Import the generated `mocks.mocks.dart` in your tests and remove the
hand-written mock classes:

```diff
- import 'mocks/service_mocks.mocks.dart';
+ import 'mocks.mocks.dart';
-
-class MockFirebaseFirestorePlatform extends Mock
-    with MockPlatformInterfaceMixin
-    implements FirebaseFirestorePlatform {}
-
-class MockFirebaseCrashlyticsPlatform extends Mock
-    with MockPlatformInterfaceMixin
-    implements FirebaseCrashlyticsPlatform {}
-
-class MockFilePicker extends Mock
-    with MockPlatformInterfaceMixin
-    implements FilePicker {}
+// Use the generated mocks instead of the manual implementations.
```

## Option 2: Manual `noSuchMethod` fallback

If you cannot use `build_runner`, keep the manual classes and override
`noSuchMethod`:

```diff
-class MockFirebaseFirestorePlatform extends Mock
-    with MockPlatformInterfaceMixin
-    implements FirebaseFirestorePlatform {}
+class MockFirebaseFirestorePlatform extends Mock
+    with MockPlatformInterfaceMixin
+    implements FirebaseFirestorePlatform {
+  @override
+  dynamic noSuchMethod(Invocation invocation) =>
+      super.noSuchMethod(invocation);
+}
```

Apply the same pattern for:
`MockFirebaseCrashlyticsPlatform`, `MockFilePicker`, `MockFirestoreService`,
`MockAuthService`, and `MockFirebaseStorageService`.

Both approaches keep the project fully offline compliant.
