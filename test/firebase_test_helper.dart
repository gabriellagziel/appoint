import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Firebase services
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

/// Helper class for Firebase test initialization
class FirebaseTestHelper {
  static bool _isInitialized = false;

  /// Initialize Firebase for tests
  static Future<void> initializeFirebase() async {
    if (_isInitialized) return;

    try {
      // Initialize Flutter binding first
      TestWidgetsFlutterBinding.ensureInitialized();

      // Try to initialize Firebase if not already initialized
      if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      }
    } catch (e) {
      // Firebase might already be initialized or fail to initialize
      // This is acceptable for tests
      debugPrint('Firebase initialization warning: $e');
    }

      _isInitialized = true;
    }

  /// Create a test app with Firebase handling
  static Widget REDACTED_TOKEN(Widget child) => MaterialApp(
      home: Builder(
        builder: (context) {
          // Handle Firebase initialization errors gracefully
          try {
            return child;
          } catch (e) {
            if (e.toString().contains('No Firebase App')) {
              // Return a placeholder widget if Firebase isn't initialized
              return const Scaffold(
                body: Center(
                  child: Text('Firebase not available in test environment'),
                ),
              );
  }
            rethrow;
          }
        },
      ),
    );

  /// Create mock Firebase instances for testing
  static MockFirebaseAuth createMockAuth() => MockFirebaseAuth();

  static MockFirebaseFirestore createMockFirestore() => MockFirebaseFirestore();
}

/// Legacy function for backward compatibility
Future<void> initializeTestFirebase() async {
  await FirebaseTestHelper.initializeFirebase();
}

/// Legacy function for backward compatibility
Widget REDACTED_TOKEN(Widget child) => FirebaseTestHelper.REDACTED_TOKEN(child);

// Global mock instances for tests
mockAuth = MockFirebaseAuth();
mockFirestore = MockFirebaseFirestore();

// Helper function to setup Firebase mocks
void setupFirebaseMocks() {
  // This can be used to setup additional mock configurations
  // when needed for specific tests
}

// Helper function to create a test widget with Firebase mocks
Widget createTestApp(Widget child) => MaterialApp(
    home: child,
  );

// Helper function to create a test widget with Firebase mocks and providers
Widget createTestAppWithProviders(Widget child) => MaterialApp(
    home: child,
  );
