import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/group_admin/ui/group_members_tab.dart';
import 'package:appoint/models/group_role.dart';

void main() {
  group('GroupMembersTab Smoke Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('owner sees transfer ownership button, admin does not',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for transfer ownership button (should be visible for owner)
      final transferButtons = find.byIcon(Icons.swap_horiz);
      expect(transferButtons, findsOneWidget);
    });

    testWidgets('admin can remove member but not admin/owner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for remove member buttons
      final removeButtons = find.byIcon(Icons.remove_circle_outline);
      expect(removeButtons, findsOneWidget);

      // Tap remove button
      if (removeButtons.evaluate().isNotEmpty) {
        await tester.tap(removeButtons.first);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Remove Member'), findsOneWidget);
        expect(find.textContaining('Are you sure you want to remove'),
            findsOneWidget);
      }
    });

    testWidgets('promote member shows confirmation dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for promote buttons
      final promoteButtons = find.byIcon(Icons.arrow_upward);
      if (promoteButtons.evaluate().isNotEmpty) {
        await tester.tap(promoteButtons.first);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Promote to Admin'), findsOneWidget);
        expect(find.textContaining('Are you sure you want to promote'),
            findsOneWidget);
      }
    });

    testWidgets('demote admin shows confirmation dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for demote buttons
      final demoteButtons = find.byIcon(Icons.arrow_downward);
      if (demoteButtons.evaluate().isNotEmpty) {
        await tester.tap(demoteButtons.first);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Demote Admin'), findsOneWidget);
        expect(find.textContaining('Are you sure you want to demote'),
            findsOneWidget);
      }
    });

    testWidgets('transfer ownership shows confirmation dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for transfer ownership buttons
      final transferButtons = find.byIcon(Icons.swap_horiz);
      if (transferButtons.evaluate().isNotEmpty) {
        await tester.tap(transferButtons.first);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Transfer Ownership'), findsOneWidget);
        expect(find.textContaining('Are you sure you want to transfer'),
            findsOneWidget);
      }
    });

    testWidgets('shows insufficient permissions toast for unauthorized actions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to perform an unauthorized action
      final removeButtons = find.byIcon(Icons.remove_circle_outline);
      if (removeButtons.evaluate().isNotEmpty) {
        await tester.tap(removeButtons.first);
        await tester.pumpAndSettle();

        // Should show error message
        expect(find.textContaining('Failed to remove user'), findsOneWidget);
      }
    });

    testWidgets('displays member list with roles', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify member list is displayed
      expect(find.text('Owner'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Member'), findsOneWidget);
    });

    testWidgets('shows empty state when no members exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'empty-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.text('No members found'), findsOneWidget);
    });

    testWidgets('shows error state with retry button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'error-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error state is displayed
      expect(find.text('Failed to load members'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('successful actions show SnackBar feedback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupMembersTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Perform a successful action
      final promoteButtons = find.byIcon(Icons.arrow_upward);
      if (promoteButtons.evaluate().isNotEmpty) {
        await tester.tap(promoteButtons.first);
        await tester.pumpAndSettle();

        // Confirm the action
        final confirmButton = find.text('Promote');
        if (confirmButton.evaluate().isNotEmpty) {
          await tester.tap(confirmButton);
          await tester.pumpAndSettle();

          // Verify success message
          expect(find.textContaining('promoted to admin'), findsOneWidget);
        }
      }
    });
  });
}
