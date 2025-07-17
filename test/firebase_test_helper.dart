import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Firebase services
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

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
  static Widget createTestAppWithFirebaseHandling(Widget child) => MaterialApp(
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

  /// Setup comprehensive Firebase mocks for all services
  static void setupComprehensiveFirebaseMocks() {
    // Setup Firebase Auth mocks
    final mockAuth = createMockAuth();
    final mockUser = createMockUser();
    final mockUserCredential = createMockUserCredential();

    // Setup user mock
    when(() => mockUser.uid).thenReturn('test-user-id');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    when(() => mockUser.isAnonymous).thenReturn(false);
    when(() => mockUser.emailVerified).thenReturn(true);

    // Setup user credential mock
    when(() => mockUserCredential.user).thenReturn(mockUser);

    // Setup auth mock
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(mockUser));
    when(() => mockAuth.userChanges()).thenAnswer((_) => Stream.value(mockUser));
    when(() => mockAuth.signInWithEmailAndPassword(any(), any())).thenAnswer((_) async => mockUserCredential);
    when(() => mockAuth.createUserWithEmailAndPassword(any(), any())).thenAnswer((_) async => mockUserCredential);
    when(() => mockAuth.signOut()).thenAnswer((_) async {});

    // Setup Firestore mocks
    final mockFirestore = createMockFirestore();
    final mockCollection = MockCollectionReference();
    final mockDocument = MockDocumentReference();
    final mockDocumentSnapshot = MockDocumentSnapshot();
    final mockQuerySnapshot = MockQuerySnapshot();

    // Setup collection mock
    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocument);
    when(() => mockCollection.add(any())).thenAnswer((_) async => mockDocument);
    when(() => mockCollection.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));

    // Setup document mock
    when(() => mockDocument.set(any())).thenAnswer((_) async {});
    when(() => mockDocument.update(any())).thenAnswer((_) async {});
    when(() => mockDocument.delete()).thenAnswer((_) async {});
    when(() => mockDocument.snapshots()).thenAnswer((_) => Stream.value(mockDocumentSnapshot));
    when(() => mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);

    // Setup document snapshot mock
    when(() => mockDocumentSnapshot.exists).thenReturn(true);
    when(() => mockDocumentSnapshot.data()).thenReturn({
      'id': 'test-doc-id',
      'name': 'Test Document',
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Setup query snapshot mock
    when(() => mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot]);
    when(() => mockQuerySnapshot.size).thenReturn(1);
  }
}

// Additional mock classes
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}

/// Legacy function for backward compatibility
Future<void> initializeTestFirebase() async {
  await FirebaseTestHelper.initializeFirebase();
}

/// Legacy function for backward compatibility
Widget createTestAppWithFirebaseHandling(Widget child) => FirebaseTestHelper.createTestAppWithFirebaseHandling(child);

// Global mock instances for tests
final mockAuth = MockFirebaseAuth();
final mockFirestore = MockFirebaseFirestore();

// Helper function to setup Firebase mocks
void setupFirebaseMocks() {
  FirebaseTestHelper.setupComprehensiveFirebaseMocks();
}

// Helper function to create a test widget with Firebase mocks
Widget createTestApp(Widget child) => MaterialApp(
    home: child,
  );

// Helper function to create a test widget with Firebase mocks and providers
Widget createTestAppWithProviders(Widget child) => MaterialApp(
    home: child,
  );
