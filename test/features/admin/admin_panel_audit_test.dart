import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/features/admin/admin_demo_panel_screen.dart';
import 'package:appoint/features/admin/admin_monetization_control_demo_screen.dart';
import 'package:appoint/features/admin/admin_broadcast_system_demo_screen.dart';
import 'package:appoint/features/admin/admin_error_logs_demo_screen.dart';
import 'package:appoint/extensions/fl_chart_color_shim.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('Admin Panel System Audit', () {
    testWidgets('Admin Demo Panel renders all navigation tiles correctly',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AdminDemoPanelScreen(),
          ),
        ),
      );

      // Check for the main title
      expect(find.text('Admin Panel Demo'), findsOneWidget);
      expect(find.text('Admin Panel Demo Screens'), findsOneWidget);

      // Check for all demo screen navigation tiles using skipOffstage: false
      expect(find.text('Monetization Control', skipOffstage: false),
          findsOneWidget);
      expect(
          find.text('Broadcast System', skipOffstage: false), findsOneWidget);
      expect(find.text('Error & Activity Logs', skipOffstage: false),
          findsOneWidget);
      expect(find.text('Full Admin Dashboard', skipOffstage: false),
          findsOneWidget);
    });

    testWidgets('Monetization Control Demo Screen renders correctly',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MonetizationControlDemoScreen(),
          ),
        ),
      );

      // Check for the screen title
      expect(find.text('Monetization Control'), findsOneWidget);

      // Check for the main control
      expect(find.text('Enable Ads'), findsOneWidget);

      // Verify the switch is present
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('Broadcast System Demo Screen renders correctly',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BroadcastSystemDemoScreen(),
          ),
        ),
      );

      // Check for the screen title
      expect(find.text('Broadcast System'), findsOneWidget);

      // Check for the message input field
      expect(find.byType(TextField), findsOneWidget);

      // Check for the send button
      expect(find.text('Send Message'), findsOneWidget);
    });

    testWidgets('Error Logs Demo Screen renders correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ErrorLogsDemoScreen(),
          ),
        ),
      );

      // Check for the screen title
      expect(find.text('Error & Activity Logs'), findsOneWidget);

      // Verify the screen loads without errors
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Navigation from Admin Demo Panel to individual screens works',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AdminDemoPanelScreen(),
            routes: {
              '/admin/monetization-control-demo': (context) =>
                  MonetizationControlDemoScreen(),
              '/admin/broadcast-system-demo': (context) =>
                  BroadcastSystemDemoScreen(),
              '/admin/error-logs-demo': (context) => ErrorLogsDemoScreen(),
            },
          ),
        ),
      );

      // Navigate to Monetization Control
      await tester.tap(find.text('Monetization Control', skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.text('Monetization Control'), findsOneWidget);
      expect(find.text('Enable Ads'), findsOneWidget);

      // Go back and navigate to Broadcast System
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Broadcast System', skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.text('Broadcast System'), findsOneWidget);
      expect(find.text('Send Message'), findsOneWidget);

      // Go back and navigate to Error Logs
      await tester.pageBack();
      await tester.pumpAndSettle();

      // scroll until the card is visible, then tap
      await tester.scrollUntilVisible(
        find.text('Error & Activity Logs'),
        200.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.tap(find.text('Error & Activity Logs'));
      await tester.pumpAndSettle();
      expect(find.text('Error & Activity Logs'), findsOneWidget);
    });

    test('Monetization Control Provider works correctly', () {
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

    test('Broadcast Message Provider works correctly', () {
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

    test('Error Log Provider works correctly', () {
      final container = ProviderContainer();

      // Initial state should be empty
      expect(container.read(errorLogProvider), isEmpty);

      // Add an error log
      container.read(errorLogProvider.notifier).addErrorLog('Test error');
      expect(container.read(errorLogProvider).length, 1);
      expect(container.read(errorLogProvider).first.message, 'Test error');

      container.dispose();
    });

    testWidgets('Admin Demo Panel UI elements are properly styled',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AdminDemoPanelScreen(),
          ),
        ),
      );

      // Check for proper styling elements using skipOffstage: false
      expect(find.byType(Card, skipOffstage: false),
          findsNWidgets(4)); // 4 demo cards
      expect(
          find.byType(Icon, skipOffstage: false), findsNWidgets(4)); // 4 icons
      expect(find.byType(GridView), findsOneWidget); // Grid layout
    });

    testWidgets('Demo screens have proper app bar and navigation',
        (tester) async {
      // Test Monetization Control Demo
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MonetizationControlDemoScreen(),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);

      // Test Broadcast System Demo
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BroadcastSystemDemoScreen(),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);

      // Test Error Logs Demo
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ErrorLogsDemoScreen(),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
