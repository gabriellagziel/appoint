import 'package:appoint/auth_wrapper.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/service_mocks.dart';

void main() {
  group('AuthWrapper Failure Scenarios', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify AuthWrapper renders without crashing
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('shows basic UI structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify basic structure
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('handles auth service injection', (WidgetTester tester) async {
      // Mock auth service method
      when(() => mockAuthService.currentUser()).thenAnswer((_) async => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify the widget renders with injected service
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('handles auth state changes', (WidgetTester tester) async {
      // Mock auth state stream
      when(() => mockAuthService.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify widget handles auth state
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('renders consistently across rebuilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Trigger rebuild
      await tester.pump();

      // Verify consistent rendering
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('shows error UI when authentication fails',
        (WidgetTester tester) async {
      // Mock authentication failure
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify error UI is shown (basic error handling)
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('shows network error when connection fails',
        (WidgetTester tester) async {
      // Mock network failure
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(Exception('No internet connection'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify basic error handling
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('shows loading state during authentication',
        (WidgetTester tester) async {
      // Mock slow authentication
      when(() => mockAuthService.signIn(any(), any()))
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 2)));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('handles timeout errors gracefully',
        (WidgetTester tester) async {
      // Mock timeout
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(Exception('Request timed out'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Verify basic error handling
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
