import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Import the generated mocks
import 'mocks/firebase_mocks.mocks.dart';

// Mock Firebase services using firebase_auth_mocks
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Use the generated mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

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
  static MockUser createMockUser() => MockUser();
  static MockUserCredential createMockUserCredential() => MockUserCredential();

  /// Setup basic Firebase mocks for testing
  static void setupBasicFirebaseMocks() {
    // Setup Firebase Auth mocks
    final mockAuth = createMockAuth();
    final mockUser = createMockUser();
    final mockUserCredential = createMockUserCredential();

    // Setup user mock with proper method stubs
    when(() => mockUser.uid).thenReturn('test-user-id');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    when(() => mockUser.isAnonymous).thenReturn(false);
    when(() => mockUser.emailVerified).thenReturn(true);

    // Setup user credential mock
    when(() => mockUserCredential.user).thenReturn(mockUser);

    // Setup auth mock with proper method stubs
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockAuth.authStateChanges())
        .thenAnswer((_) => Stream.value(mockUser));
    when(() => mockAuth.userChanges())
        .thenAnswer((_) => Stream.value(mockUser));
    when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockUserCredential);
    when(() => mockAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockUserCredential);
    when(() => mockAuth.signOut()).thenAnswer((_) async {});
  }
}

/// Legacy function for backward compatibility
Future<void> initializeTestFirebase() async {
  await FirebaseTestHelper.initializeFirebase();
}

/// Legacy function for backward compatibility
Widget REDACTED_TOKEN(Widget child) =>
    FirebaseTestHelper.REDACTED_TOKEN(child);

// Global mock instances for tests
final mockAuth = MockFirebaseAuth();
final mockFirestore = MockFirebaseFirestore();

// Helper function to setup Firebase mocks
void setupFirebaseMocks() {
  FirebaseTestHelper.setupBasicFirebaseMocks();
}

// Helper function to create a test widget with Firebase mocks
Widget createTestApp(Widget child) => MaterialApp(
      home: child,
    );

// Helper function to create a test widget with Firebase mocks and providers
Widget createTestAppWithProviders(Widget child) => MaterialApp(
      home: child,
    );
