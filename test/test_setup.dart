import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:file_picker/file_picker.dart';
import 'package:REDACTED_TOKEN/test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'mocks/service_mocks.mocks.dart';

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

late MockFirestoreService mockFirestoreService;
late MockAuthService mockAuthService;
late MockFirebaseStorageService mockStorageService;

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

    mockFirestoreService = MockFirestoreService();
    mockAuthService = MockAuthService();
    mockStorageService = MockFirebaseStorageService();
  });
}
