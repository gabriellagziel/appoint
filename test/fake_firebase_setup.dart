import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:REDACTED_TOKEN/test.dart';

/// Initializes a fake [FirebaseApp] and mocks common Firebase method channels
/// so that widget and integration tests can run without real backends.
Future<FirebaseApp> initializeTestFirebase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  // Mock Firebase Auth
  const MethodChannel firebaseAuthChannel =
      MethodChannel('plugins.flutter.io/firebase_auth');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseAuthChannel,
          (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'signInWithEmailAndPassword':
        return {
          'user': {
            'uid': 'test-user',
            'email': 'test@example.com',
          },
        };
      case 'signOut':
        return null;
      case 'currentUser':
        return {
          'uid': 'test-user',
          'email': 'test@example.com',
        };
      default:
        return null;
    }
  });

  // Mock Cloud Firestore
  const MethodChannel cloudFirestoreChannel =
      MethodChannel('plugins.flutter.io/cloud_firestore');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(cloudFirestoreChannel,
          (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'DocumentReference#get':
        return {'data': {}};
      case 'DocumentReference#set':
        return null;
      case 'DocumentReference#update':
        return null;
      case 'DocumentReference#delete':
        return null;
      case 'Query#get':
        return {'documents': []};
      case 'Query#count':
        return {'count': 0};
      default:
        return null;
    }
  });

  // Mock Firebase Storage
  const MethodChannel firebaseStorageChannel =
      MethodChannel('plugins.flutter.io/firebase_storage');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseStorageChannel,
          (MethodCall methodCall) async {
    return null;
  });

  // Mock Firebase Messaging
  const MethodChannel firebaseMessagingChannel =
      MethodChannel('plugins.flutter.io/firebase_messaging');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseMessagingChannel,
          (MethodCall methodCall) async {
    return null;
  });

  // Mock Firebase App Check
  const MethodChannel firebaseAppCheckChannel =
      MethodChannel('plugins.flutter.io/firebase_app_check');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseAppCheckChannel,
          (MethodCall methodCall) async {
    return null;
  });

  // Mock Firebase Crashlytics
  const MethodChannel firebaseCrashlyticsChannel =
      MethodChannel('plugins.flutter.io/firebase_crashlytics');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseCrashlyticsChannel,
          (MethodCall methodCall) async {
    return null;
  });

  // Mock file_picker plugin to suppress platform warnings in tests
  const MethodChannel filePickerChannel =
      MethodChannel('plugins.flutter.io/file_picker');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(filePickerChannel,
          (MethodCall methodCall) async {
    return null;
  });

  const firebaseOptions = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: '1:1234567890:android:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'test-project',
  );

  try {
    return await Firebase.initializeApp(name: 'TEST', options: firebaseOptions);
  } catch (_) {
    return Firebase.app('TEST');
  }
}

