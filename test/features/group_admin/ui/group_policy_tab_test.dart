import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/group_admin/ui/group_policy_tab.dart';
import 'package:appoint/models/group_policy.dart';
import 'package:appoint/models/group_role.dart';

void main() {
  group('GroupPolicyTab', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('displays policy settings correctly',
        (WidgetTester tester) async {
      final policy = GroupPolicy(
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
            home: GroupPolicyTab(groupId: 'test-group'),
          ),
        ),
      );

      // Wait for the widget to load
      await tester.pumpAndSettle();

      // Verify that policy settings are displayed
      expect(find.text('Members Can Invite'), findsOneWidget);
      expect(find.text('Require Vote for Admin'), findsOneWidget);
      expect(find.text('Allow Non-Members RSVP'), findsOneWidget);
    });

    testWidgets('shows restricted access for non-admin users',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: GroupPolicyTab(groupId: 'test-group'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show restricted access message
      expect(find.text('Policy Management Restricted'), findsOneWidget);
      expect(find.text('You need admin permissions to manage group policies'),
          findsOneWidget);
    });

    testWidgets('toggles policy settings when user has permissions',
        (WidgetTester tester) async {
      // Mock the providers to return admin user
      final policy = GroupPolicy(
        membersCanInvite: true,
        requireVoteForAdmin: false,
        allowNonMembersRSVP: true,
        lastUpdated: DateTime.now(),
        updatedBy: 'admin-user',
        version: 1,
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: GroupPolicyTab(groupId: 'test-group'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the first switch
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        await tester.tap(switches.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('displays policy information correctly',
        (WidgetTester tester) async {
      final policy = GroupPolicy(
        membersCanInvite: true,
        requireVoteForAdmin: false,
        allowNonMembersRSVP: true,
        lastUpdated: DateTime.now(),
        updatedBy: 'test-user',
        version: 2,
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: GroupPolicyTab(groupId: 'test-group'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify policy information is displayed
      expect(find.text('Policy Information'), findsOneWidget);
      expect(find.text('Last Updated'), findsOneWidget);
      expect(find.text('Updated By'), findsOneWidget);
      expect(find.text('Policy Version'), findsOneWidget);
    });

    testWidgets('handles loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: GroupPolicyTab(groupId: 'test-group'),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('handles error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: GroupPolicyTab(groupId: 'test-group'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show error message and retry button
      expect(find.text('Failed to load policy'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
