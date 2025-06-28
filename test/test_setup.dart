import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:file_picker/file_picker.dart';

import '../lib/generated/pigeon_auth_api.dart';
import '../lib/generated/pigeon_firestore_api.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}
class MockFirebaseAppCheck extends Mock implements FirebaseAppCheck {}
class MockFilePicker extends Mock implements FilePicker {}
class MockAuthHostApi extends Mock implements AuthHostApi {}
class MockFirestoreHostApi extends Mock implements FirestoreHostApi {}

void setupFirebaseTestMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();

    FirebaseAuth.instanceFor = ({required FirebaseApp app}) => MockFirebaseAuth();
    FirebaseFirestore.instanceFor = ({required FirebaseApp app}) => MockFirebaseFirestore();
    FirebaseCrashlytics.instance = MockFirebaseCrashlytics();
    FirebaseAppCheck.instance = MockFirebaseAppCheck();
    FilePicker.platform = MockFilePicker();

    AuthHostApi.setup(MockAuthHostApi());
    FirestoreHostApi.setup(MockFirestoreHostApi());
  });
}
