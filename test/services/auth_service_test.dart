import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/auth_service.dart';
import 'package:appoint/models/user_profile.dart';
import '../mocks/firebase_mocks.dart';
import '../firebase_test_helper.dart';

// Generate mocks
@GenerateMocks([AuthService])
void main() {
  setUpAll(() async {
    await initializeTestFirebase();
    setupFirebaseMocks();
  });

  group('AuthService Tests', () {
    late AuthService authService;
    late MockFirebaseAuthGenerated mockAuth;
    late MockFirebaseFirestoreGenerated mockFirestore;
    late MockUserGenerated mockUser;
    late MockUserCredentialGenerated mockUserCredential;
    late MockDocumentReferenceGenerated mockDocRef;
    late MockDocumentSnapshotGenerated mockDocSnapshot;

    setUp(() {
      mockAuth = MockFirebaseAuthGenerated();
      mockFirestore = MockFirebaseFirestoreGenerated();
      mockUser = MockUserGenerated();
      mockUserCredential = MockUserCredentialGenerated();
      mockDocRef = MockDocumentReferenceGenerated();
      mockDocSnapshot = MockDocumentSnapshotGenerated();

      authService = AuthService();
    });

    group('signInWithEmailAndPassword', () {
      test('should sign in successfully with valid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const uid = 'test-uid';

        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn('Test User');
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<UserProfile>());
        expect(result.uid, equals(uid));
        expect(result.email, equals(email));
        expect(result.displayName, equals('Test User'));
      });

      test('should throw exception with invalid credentials', () async {
        // Arrange
        const email = 'invalid@example.com';
        const password = 'wrongpassword';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        ));

        // Act & Assert
        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle empty email', () async {
        // Act & Assert
        expect(
          () => authService.signInWithEmailAndPassword(
            email: '',
            password: 'password123',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle empty password', () async {
        // Act & Assert
        expect(
          () => authService.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('should create user successfully', () async {
        // Arrange
        const email = 'newuser@example.com';
        const password = 'password123';
        const uid = 'new-user-uid';

        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn('New User');
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<UserProfile>());
        expect(result.uid, equals(uid));
        expect(result.email, equals(email));
        expect(result.displayName, equals('New User'));
      });

      test('should throw exception with weak password', () async {
        // Arrange
        const email = 'test@example.com';
        const password = '123';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(
          code: 'weak-password',
          message: 'The password provided is too weak.',
        ));

        // Act & Assert
        expect(
          () => authService.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('signOut', () {
      test('should sign out successfully', () async {
        // Arrange
        when(mockAuth.signOut()).thenAnswer((_) async => null);

        // Act
        await authService.signOut();

        // Assert
        verify(mockAuth.signOut()).called(1);
      });

      test('should handle sign out error', () async {
        // Arrange
        when(mockAuth.signOut()).thenThrow(FirebaseAuthException(
          code: 'sign-out-failed',
          message: 'Sign out failed.',
        ));

        // Act & Assert
        expect(
          () => authService.signOut(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('getCurrentUser', () {
      test('should return current user when authenticated', () async {
        // Arrange
        const uid = 'test-uid';
        const email = 'test@example.com';

        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockAuth.currentUser).thenReturn(mockUser);

        // Act
        final result = await authService.getCurrentUser();

        // Assert
        expect(result, isA<UserProfile>());
        expect(result?.uid, equals(uid));
        expect(result?.email, equals(email));
      });

      test('should return null when not authenticated', () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(null);

        // Act
        final result = await authService.getCurrentUser();

        // Assert
        expect(result, isNull);
      });
    });

    group('updateUserProfile', () {
      test('should update user profile successfully', () async {
        // Arrange
        final userProfile = UserProfile(
          uid: 'test-uid',
          displayName: 'Updated Name',
          email: 'updated@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(
          MockCollectionReferenceGenerated(),
        );
        when(mockFirestore.collection('users').doc(userProfile.uid))
            .thenReturn(mockDocRef);
        when(mockDocRef.update(userProfile.toJson()))
            .thenAnswer((_) async => null);

        // Act
        await authService.updateUserProfile(userProfile);

        // Assert
        verify(mockDocRef.update(userProfile.toJson())).called(1);
      });

      test('should handle update error', () async {
        // Arrange
        final userProfile = UserProfile(
          uid: 'test-uid',
          displayName: 'Updated Name',
          email: 'updated@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(
          MockCollectionReferenceGenerated(),
        );
        when(mockFirestore.collection('users').doc(userProfile.uid))
            .thenReturn(mockDocRef);
        when(mockDocRef.update(userProfile.toJson()))
            .thenThrow(FirebaseException(plugin: 'firestore'));

        // Act & Assert
        expect(
          () => authService.updateUserProfile(userProfile),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('deleteUser', () {
      test('should delete user successfully', () async {
        // Arrange
        const uid = 'test-uid';

        when(mockUser.uid).thenReturn(uid);
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.delete()).thenAnswer((_) async => null);

        when(mockFirestore.collection('users')).thenReturn(
          MockCollectionReferenceGenerated(),
        );
        when(mockFirestore.collection('users').doc(uid))
            .thenReturn(mockDocRef);
        when(mockDocRef.delete()).thenAnswer((_) async => null);

        // Act
        await authService.deleteUser();

        // Assert
        verify(mockUser.delete()).called(1);
        verify(mockDocRef.delete()).called(1);
      });

      test('should handle delete error', () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.delete()).thenThrow(FirebaseAuthException(
          code: 'requires-recent-login',
          message: 'This operation is sensitive and requires recent authentication.',
        ));

        // Act & Assert
        expect(
          () => authService.deleteUser(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('resetPassword', () {
      test('should send password reset email successfully', () async {
        // Arrange
        const email = 'test@example.com';

        when(mockAuth.sendPasswordResetEmail(email: email))
            .thenAnswer((_) async => null);

        // Act
        await authService.resetPassword(email);

        // Assert
        verify(mockAuth.sendPasswordResetEmail(email: email)).called(1);
      });

      test('should handle password reset error', () async {
        // Arrange
        const email = 'nonexistent@example.com';

        when(mockAuth.sendPasswordResetEmail(email: email))
            .thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        ));

        // Act & Assert
        expect(
          () => authService.resetPassword(email),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('email validation', () {
      test('should validate correct email format', () {
        // Arrange
        const validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          '123@numbers.com',
        ];

        // Act & Assert
        for (final email in validEmails) {
          expect(authService.isValidEmail(email), isTrue);
        }
      });

      test('should reject invalid email format', () {
        // Arrange
        const invalidEmails = [
          'invalid-email',
          '@example.com',
          'user@',
          'user@.com',
          'user..name@example.com',
          'user@example..com',
        ];

        // Act & Assert
        for (final email in invalidEmails) {
          expect(authService.isValidEmail(email), isFalse);
        }
      });
    });

    group('password validation', () {
      test('should validate strong password', () {
        // Arrange
        const strongPasswords = [
          'Password123!',
          'MySecurePass1@',
          'ComplexP@ssw0rd',
        ];

        // Act & Assert
        for (final password in strongPasswords) {
          expect(authService.isValidPassword(password), isTrue);
        }
      });

      test('should reject weak password', () {
        // Arrange
        const weakPasswords = [
          '123',
          'password',
          'PASSWORD',
          'Password',
          'password123',
        ];

        // Act & Assert
        for (final password in weakPasswords) {
          expect(authService.isValidPassword(password), isFalse);
        }
      });
    });
  });
}
