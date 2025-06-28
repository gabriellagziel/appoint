import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_crashlytics_platform_interface/firebase_crashlytics_platform_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../lib/generated/pigeon_auth_api.dart';
import '../lib/generated/pigeon_firestore_api.dart';

// Mocks
class MockFirebaseAuthPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseAuthPlatform {}
class MockFirebaseFirestorePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseFirestorePlatform {}
class MockFirebaseCrashlyticsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseCrashlyticsPlatform {}
class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}
class MockAuthHostApi extends Mock implements AuthHostApi {}
class MockFirestoreHostApi extends Mock implements FirestoreHostApi {}

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();

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
