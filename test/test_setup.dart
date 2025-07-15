import 'package:appoint/generated/pigeon_auth_api.dart';
import 'package:appoint/generated/pigeon_firestore_api.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:file_picker/file_picker.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mocks/service_mocks.dart';

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

class MockFirebaseMessagingPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseMessagingPlatform {}

class MockFirebaseFunctionsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseFunctionsPlatform {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

class MockAuthHostApi extends Mock implements AuthHostApi {}

class MockFirestoreHostApi extends Mock implements FirestoreHostApi {}

late MockFirestoreService mockFirestoreService;
late MockAuthService mockAuthService;
late MockFirebaseStorageService mockStorageService;
late MockNotificationService mockNotificationService;

void registerServiceMocks() {
  mockFirestoreService = MockFirestoreService();
  mockAuthService = MockAuthService();
  mockStorageService = MockFirebaseStorageService();
  mockNotificationService = MockNotificationService();
}

/// Global test setup that initializes Firebase and all mocks
Future<void> setupTestEnvironment() async {
  // Initialize Firebase with test configuration
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // If already initialized, continue
  }

  // Set up platform mocks
  FirebaseAuthPlatform.instance = MockFirebaseAuthPlatform();
  FirebaseFirestorePlatform.instance = MockFirebaseFirestorePlatform();
  FirebaseCrashlyticsPlatform.instance = MockFirebaseCrashlyticsPlatform();
  FirebaseMessagingPlatform.instance = MockFirebaseMessagingPlatform();
  FirebaseFunctionsPlatform.instance = MockFirebaseFunctionsPlatform();
  FilePicker.platform = MockFilePicker();

  // Set up Pigeon API mocks
  AuthHostApi.setup(MockAuthHostApi());
  FirestoreHostApi.setup(MockFirestoreHostApi());

  registerServiceMocks();
}

void setupFirebaseMocks() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  setUp(() {
    // Reset mocks before each test
    reset(mockFirestoreService);
    reset(mockAuthService);
    reset(mockStorageService);
    reset(mockNotificationService);
  });
}

/// Simple setup for tests that don't need full Firebase mocking
void setupBasicTestEnvironment() {
  setUpAll(() async {
    // Initialize Firebase if not already done
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Ignore if already initialized
    }
  });
}
