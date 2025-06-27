import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/features/admin/REDACTED_TOKEN.dart';
import 'package:appoint/features/admin/REDACTED_TOKEN.dart';
import 'package:appoint/features/admin/admin_error_logs_demo_screen.dart';
import 'package:appoint/features/admin/admin_demo_panel_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('Admin Demo Screens Tests', () {
    testWidgets('MonetizationControlDemoScreen can be instantiated',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MonetizationControlDemoScreen(),
          ),
        ),
      );

      expect(find.text('Monetization Control'), findsOneWidget);
      expect(find.text('Enable Ads'), findsOneWidget);
    });

    testWidgets('BroadcastSystemDemoScreen can be instantiated',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BroadcastSystemDemoScreen(),
          ),
        ),
      );

      expect(find.text('Broadcast System'), findsOneWidget);
      expect(find.text('Send Message'), findsOneWidget);
    });

    testWidgets('ErrorLogsDemoScreen can be instantiated',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ErrorLogsDemoScreen(),
          ),
        ),
      );

      expect(find.text('Error & Activity Logs'), findsOneWidget);
    });

    testWidgets('Admin Demo Panel renders all demo screens correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AdminDemoPanelScreen(),
          ),
        ),
      );

      // Check for the main title
      expect(find.text('Admin Panel Demo'), findsOneWidget);
      expect(find.text('Admin Panel Demo Screens'), findsOneWidget);

      // Use skipOffstage: false to find all widgets, including those not currently visible
      expect(find.text('Monetization Control', skipOffstage: false),
          findsOneWidget);
      expect(
          find.text('Broadcast System', skipOffstage: false), findsOneWidget);
      expect(find.text('Error & Activity Logs', skipOffstage: false),
          findsOneWidget);
      expect(find.text('Full Admin Dashboard', skipOffstage: false),
          findsOneWidget);
    });

    test('MonetizationControl provider works correctly', () {
      final container = ProviderContainer();

      // Initial state should be true
      expect(container.read(monetizationControlProvider).isAdsEnabled, true);

      // Toggle to false
      container.read(monetizationControlProvider.notifier).toggleAds(false);
      expect(container.read(monetizationControlProvider).isAdsEnabled, false);

      // Toggle back to true
      container.read(monetizationControlProvider.notifier).toggleAds(true);
      expect(container.read(monetizationControlProvider).isAdsEnabled, true);

      container.dispose();
    });

    test('BroadcastMessage provider works correctly', () {
      final container = ProviderContainer();

      // Initial state should be empty message and 'All' target
      expect(container.read(broadcastMessageProvider).message, '');
      expect(container.read(broadcastMessageProvider).target, 'All');

      // Send a message
      container
          .read(broadcastMessageProvider.notifier)
          .sendMessage('Test message', 'Premium Users');
      expect(container.read(broadcastMessageProvider).message, 'Test message');
      expect(container.read(broadcastMessageProvider).target, 'Premium Users');

      container.dispose();
    });

    test('ErrorLog provider works correctly', () {
      final container = ProviderContainer();

      // Initial state should be empty
      expect(container.read(errorLogProvider), isEmpty);

      // Add an error log
      container
          .read(errorLogProvider.notifier)
          .addErrorLog('Test error message');
      expect(container.read(errorLogProvider).length, 1);
      expect(
          container.read(errorLogProvider).first.message, 'Test error message');

      // Add another error log
      container.read(errorLogProvider.notifier).addErrorLog('Another error');
      expect(container.read(errorLogProvider).length, 2);
      expect(container.read(errorLogProvider).last.message, 'Another error');

      container.dispose();
    });
  });
}
