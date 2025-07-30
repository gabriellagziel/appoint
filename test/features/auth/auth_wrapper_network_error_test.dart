import 'dart:async';
import 'dart:io';

import 'package:appoint/features/auth/auth_wrapper.dart';
import 'package:appoint/models/app_user.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthWrapper Network Error Tests', () {
    late MockAuthService mockAuthService;
    late StreamController<AppUser?> authStateController;

    setUp(() {
      mockAuthService = MockAuthService();
      authStateController = StreamController<AppUser?>.broadcast();

      // Mock the authStateChanges method to throw SocketException
      when(
        () => mockAuthService.authStateChanges(),
      ).thenAnswer((_) => Stream.error(const SocketException('No Internet')));
    });

    tearDown(() {
      authStateController.close();
    });

    testWidgets('NetworkErrorRetry widget displays correct UI', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a test callback
      var retryCalled = false;
      void onRetry() {
        retryCalled = true;
      }

      // Build the NetworkErrorRetry widget directly
      await tester.pumpWidget(
        MaterialApp(home: NetworkErrorRetry(onRetry: onRetry)),
      );
      await tester.pumpAndSettle();

      // Assert: Network error UI is shown
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);
      expect(find.textContaining('check your connection'), findsOneWidget);
      expect(find.textContaining('try again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Locate and tap the Retry label directly
      final retryText = find.text('Retry');
      expect(retryText, findsOneWidget);
      await tester.tap(retryText);
      await tester.pumpAndSettle();

      // Verify the retry callback was invoked
      expect(retryCalled, isTrue);
    });

    testWidgets('NetworkErrorRetry widget displays correct styling', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a test callback
      void onRetry() {}

      // Build the NetworkErrorRetry widget directly
      await tester.pumpWidget(
        MaterialApp(home: NetworkErrorRetry(onRetry: onRetry)),
      );
      await tester.pumpAndSettle();

      // Assert: Network error UI styling is correct
      final wifiOffIcon = tester.widget<Icon>(find.byIcon(Icons.wifi_off));
      expect(wifiOffIcon.size, 64);
      expect(wifiOffIcon.color, Colors.red);

      // Check that Retry text is present
      final retryText = find.text('Retry');
      expect(retryText, findsOneWidget);
    });

    testWidgets('NetworkErrorRetry widget is centered on screen', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a test callback
      void onRetry() {}

      // Build the NetworkErrorRetry widget directly
      await tester.pumpWidget(
        MaterialApp(home: NetworkErrorRetry(onRetry: onRetry)),
      );
      await tester.pumpAndSettle();

      // Assert: Network error UI is centered
      final centerWidget = tester.widget<Center>(
        find.ancestor(
          of: find.byIcon(Icons.wifi_off),
          matching: find.byType(Center),
        ),
      );
      expect(centerWidget, isNotNull);
    });

    testWidgets('NetworkErrorRetry widget shows all required elements', (
      WidgetTester tester,
    ) async {
      // Arrange: Create a test callback
      void onRetry() {}

      // Build the NetworkErrorRetry widget directly
      await tester.pumpWidget(
        MaterialApp(home: NetworkErrorRetry(onRetry: onRetry)),
      );
      await tester.pumpAndSettle();

      // Assert: All required UI elements are present
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);
      expect(find.textContaining('check your connection'), findsOneWidget);
      expect(find.textContaining('try again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      final retryText = find.text('Retry');
      expect(retryText, findsOneWidget);
    });

    testWidgets('shows retry button on network error and allows retry', (
      tester,
    ) async {
      // Arrange: override the authServiceProvider with our mock
      final container = ProviderContainer(
        overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: UncontrolledProviderScope(
            container: container,
            child: const AuthWrapper(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Dump the widget tree for debugging
      debugPrint(tester.element(find.byType(AuthWrapper)).toStringDeep());

      // Locate the Retry label
      final retryText = find.text('Retry');
      expect(retryText, findsOneWidget);

      // Tap the label to trigger the button
      await tester.tap(retryText);
      await tester.pumpAndSettle();

      // Verify authStateChanges() called again
      verify(() => mockAuthService.authStateChanges()).called(greaterThan(1));
    });
  });
}
