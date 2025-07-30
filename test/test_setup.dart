import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appoint/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:REDACTED_TOKEN/test.dart';
import 'package:REDACTED_TOKEN/src/method_channel/utils/firestore_message_codec.dart';
import 'package:REDACTED_TOKEN/src/pigeon/messages.pigeon.dart';

// Common test utilities
class TestUtils {
  static const testEmail = 'test@example.com';
  static const testPassword = 'testpassword123';
  static const testUserId = 'test-user-id';
  static const testUserName = 'Test User';

  static DateTime get testDateTime => DateTime(2025, 6, 18, 10, 0);
  static DateTime get testCreatedAt => DateTime(2025, 6, 17);
}

Future<void> setupTestEnvironment() async {
  // Initialize Firebase for tests
  await registerFirebaseMock();
}

// Centralized Firebase mock setup for all tests
Future<void> registerFirebaseMock() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  // Add other Firebase channels to mock as needed

  // Mock Firebase Auth
  const MethodChannel firebaseAuthChannel =
      MethodChannel('plugins.flutter.io/firebase_auth');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseAuthChannel,
          (MethodCall methodCall) async {
    print(
        '[Mock] firebaseAuthChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for auth methods as needed
    switch (methodCall.method) {
      case 'signInWithEmailAndPassword':
        return {
          'user': {
            'uid': 'test-user-id',
            'email': 'test@example.com',
          },
        };
      case 'signOut':
        return null;
      case 'currentUser':
        return {
          'uid': 'test-user-id',
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
    print(
        '[Mock] cloudFirestoreChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for Firestore methods as needed
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
      case 'FirebaseFirestore#addSnapshotListener':
        return '0';
      case 'Query#addSnapshotListener':
        return '0';
      case 'DocumentReference#addSnapshotListener':
        return '0';
      default:
        return null;
    }
  });

  const String querySnapshotChannel =
      'dev.flutter.pigeon.REDACTED_TOKEN.FirebaseFirestoreHostApi.querySnapshot';
  const String documentSnapshotChannel =
      'dev.flutter.pigeon.REDACTED_TOKEN.FirebaseFirestoreHostApi.documentReferenceSnapshot';
  const MessageCodec<Object?> firestoreCodec = FirebaseFirestoreHostApi.codec;

  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMessageHandler(querySnapshotChannel, (ByteData? message) async {
    return firestoreCodec.encodeMessage(<Object?>['0']);
  });

  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMessageHandler(documentSnapshotChannel, (ByteData? message) async {
    return firestoreCodec.encodeMessage(<Object?>['0']);
  });

  // Mock Firebase Storage
  const MethodChannel firebaseStorageChannel =
      MethodChannel('plugins.flutter.io/firebase_storage');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseStorageChannel,
          (MethodCall methodCall) async {
    print(
        '[Mock] firebaseStorageChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for Firebase Storage methods as needed
    return null;
  });

  // Mock Firebase Messaging
  const MethodChannel firebaseMessagingChannel =
      MethodChannel('plugins.flutter.io/firebase_messaging');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseMessagingChannel,
          (MethodCall methodCall) async {
    print(
        '[Mock] firebaseMessagingChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for Firebase Messaging methods as needed
    return null;
  });

  // Mock Firebase App Check
  const MethodChannel firebaseAppCheckChannel =
      MethodChannel('plugins.flutter.io/firebase_app_check');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseAppCheckChannel,
          (MethodCall methodCall) async {
    print(
        '[Mock] firebaseAppCheckChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for Firebase App Check methods as needed
    return null;
  });

  // Mock Firebase Crashlytics
  const MethodChannel firebaseCrashlyticsChannel =
      MethodChannel('plugins.flutter.io/firebase_crashlytics');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(firebaseCrashlyticsChannel,
          (MethodCall methodCall) async {
    print(
        '[Mock] firebaseCrashlyticsChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for Firebase Crashlytics methods as needed
    return null;
  });

  // Mock file_picker plugin to suppress platform warnings in tests
  const MethodChannel filePickerChannel =
      MethodChannel('plugins.flutter.io/file_picker');
  REDACTED_TOKEN.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(filePickerChannel,
          (MethodCall methodCall) async {
    print(
        '[Mock] filePickerChannel: method=${methodCall.method}, arguments=${methodCall.arguments}');
    // Return mock responses for file_picker methods as needed
    return null;
  });

  // Initialize Firebase app if not already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    // Ignore duplicate app errors
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }
}
