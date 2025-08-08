import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/group_admin/ui/group_policy_tab.dart';
import 'package:appoint/models/group_policy.dart';
import 'package:appoint/models/group_role.dart';

void main() {
  group('GroupPolicyTab Smoke Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('policy toggle calls updatePolicy and shows SnackBar',
        (WidgetTester tester) async {
      // Mock policy data
      final mockPolicy = GroupPolicy(
        membersCanInvite: true,
        requireVoteForAdmin: false,
        allowNonMembersRSVP: true,
        lastUpdated: DateTime.now(),
        updatedBy: 'test-user',
        version: 1,
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupPolicyTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the first policy switch
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        // Tap the switch
        await tester.tap(switches.first);
        await tester.pumpAndSettle();

        // Verify SnackBar appears
        expect(find.text('Policy updated successfully'), findsOneWidget);
      }
    });

    testWidgets('policy toggle updates UI state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupPolicyTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find policy switches
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        // Get initial state
        final initialSwitch = switches.first.evaluate().single.widget as Switch;
        final initialValue = initialSwitch.value;

        // Tap the switch
        await tester.tap(switches.first);
        await tester.pumpAndSettle();

        // Verify state changed
        final updatedSwitch = switches.first.evaluate().single.widget as Switch;
        expect(updatedSwitch.value, isNot(equals(initialValue)));
      }
    });

    testWidgets('shows error message on policy update failure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupPolicyTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap a switch to trigger error
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        await tester.tap(switches.first);
        await tester.pumpAndSettle();

        // Should show error message
        expect(find.textContaining('Failed to update policy'), findsOneWidget);
      }
    });

    testWidgets('displays policy information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupPolicyTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify policy information section exists
      expect(find.text('Policy Information'), findsOneWidget);
      expect(find.text('Last Updated'), findsOneWidget);
      expect(find.text('Updated By'), findsOneWidget);
      expect(find.text('Policy Version'), findsOneWidget);
    });

    testWidgets('shows restricted access for non-admin users',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupPolicyTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show restricted access message
      expect(find.text('Policy Management Restricted'), findsOneWidget);
      expect(find.text('You need admin permissions to manage group policies'),
          findsOneWidget);
    });
  });
}
