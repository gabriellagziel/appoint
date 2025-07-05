import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/models/app_user.dart';
import '../test_setup.dart';

class MockAuthService extends Mock implements AuthService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockIdTokenResult extends Mock implements IdTokenResult {}

void main() {
  setupFirebaseMocks();

  group('AuthProvider', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockIdTokenResult mockTokenResult;

    setUp(() {
      mockAuthService = MockAuthService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockTokenResult = MockIdTokenResult();

      container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          authProvider.overrideWithValue(mockFirebaseAuth),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('AuthService Provider', () {
      test('should provide AuthService instance', () {
        // Act
        final authService = container.read(authServiceProvider);

        // Assert
        expect(authService, isA<AuthService>());
      });
    });

    group('AuthState Provider', () {
      test('should emit null when user is not authenticated', () async {
        // Arrange
        final streamController = StreamController<AppUser?>();
        when(() => mockAuthService.authStateChanges())
            .thenAnswer((_) => streamController.stream.asBroadcastStream());

        // Act
        final authState = container.read(authStateProvider);

        // Assert
        expect(authState, isA<AsyncValue<AppUser?>>());
      });

      test('should emit AppUser when user is authenticated', () async {
        // Arrange
        final streamController = StreamController<AppUser?>();
        when(() => mockAuthService.authStateChanges())
            .thenAnswer((_) => streamController.stream.asBroadcastStream());

        final appUser = AppUser(
          uid: 'test-uid',
          email: 'test@example.com',
          role: 'personal',
          studioId: null,
          businessProfileId: null,
        );

        // Act
        streamController.add(appUser);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final authState = container.read(authStateProvider);
        expect(authState, isA<AsyncValue<AppUser?>>());
      });

      test(
          'should emit AppUser with business role when user has business claims',
          () async {
        // Arrange
        final streamController = StreamController<AppUser?>();
        when(() => mockAuthService.authStateChanges())
            .thenAnswer((_) => streamController.stream.asBroadcastStream());

        final businessUser = AppUser(
          uid: 'business-uid',
          email: 'business@example.com',
          role: 'business',
          studioId: 'studio-123',
          businessProfileId: 'business-456',
        );

        // Act
        streamController.add(businessUser);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final authState = container.read(authStateProvider);
        expect(authState, isA<AsyncValue<AppUser?>>());
      });

      test('should emit null when user signs out', () async {
        // Arrange
        final streamController = StreamController<AppUser?>();
        when(() => mockAuthService.authStateChanges())
            .thenAnswer((_) => streamController.stream.asBroadcastStream());

        // Act
        streamController.add(null);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final authState = container.read(authStateProvider);
        expect(authState, isA<AsyncValue<AppUser?>>());
      });
    });

    group('FirebaseAuth Provider', () {
      test('should provide FirebaseAuth instance', () {
        // Act
        final firebaseAuth = container.read(authProvider);

        // Assert
        expect(firebaseAuth, equals(mockFirebaseAuth));
      });
    });
  });
}
