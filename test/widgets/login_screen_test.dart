import 'package:appoint/features/auth/login_screen.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../firebase_test_helper.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createTestWidget(Widget child) => ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: MaterialApp(
          home: child,
        ),
      );

  group('LoginScreen Widget Tests', () {
    testWidgets('should display login form', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Assert
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email and password
    });

    testWidgets('should show email and password fields',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Assert
      expect(find.byType(TextField), findsNWidgets(2)); // Email and password
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should handle email input', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.pump();

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should handle password input', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Assert
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should show loading state', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
      });

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for all timers to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should display error message for login failure',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Login failed'), findsOneWidget);
    });

    testWidgets('should handle successful login', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createTestWidget(const LoginScreen()));
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Assert
      // The login should complete without errors
      expect(find.textContaining('Login failed'), findsNothing);
    });
  });
}
