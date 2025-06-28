import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:file_picker/file_picker.dart';

import '../lib/generated/pigeon_auth_api.dart';
import '../lib/generated/pigeon_firestore_api.dart';

class MockFirebaseAuthPlatform extends Mock implements FirebaseAuthPlatform {}
class MockFirebaseFirestorePlatform extends Mock implements FirebaseFirestorePlatform {}
class MockFirebaseCrashlyticsPlatform extends Mock implements FirebaseCrashlyticsPlatform {}
class MockFilePicker extends Mock implements FilePicker {}

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();

    FirebaseAuthPlatform.instance = MockFirebaseAuthPlatform();
    FirebaseFirestorePlatform.instance = MockFirebaseFirestorePlatform();
    FirebaseCrashlyticsPlatform.instance = MockFirebaseCrashlyticsPlatform();
    FilePicker.platform = MockFilePicker();

    AuthHostApi.setup(MockAuthHostApi());
    FirestoreHostApi.setup(MockFirestoreHostApi());
  });
}

void main() {
  setupFirebaseMocks();

  test('Firebase test setup initializes without error', () {
    expect(() => FirebaseAuthPlatform.instance, returnsNormally);
    expect(() => FirebaseFirestorePlatform.instance, returnsNormally);
  });
}

class MockAuthHostApi extends Mock implements AuthHostApi {}
class MockFirestoreHostApi extends Mock implements FirestoreHostApi {}
