import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/group/ui/screens/group_details_screen.dart';

void main() {
  group('Group Admin E2E Tests', () {
    testWidgets('complete group admin flow', (WidgetTester tester) async {
      // Start with the seeded group
      const groupId = 'test-group-admin-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GroupDetailsScreen(groupId: groupId),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // 1. Verify all tabs are present
      expect(find.text('Members'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Policy'), findsOneWidget);
      expect(find.text('Votes'), findsOneWidget);
      expect(find.text('Audit'), findsOneWidget);

      // 2. Navigate through all tabs to ensure no crashes
      await _navigateThroughTabs(tester);

      // 3. Test Policy Tab functionality
      await _testPolicyTab(tester);

      // 4. Test Votes Tab functionality
      await _testVotesTab(tester);

      // 5. Test Members Tab functionality
      await _testMembersTab(tester);
    });

    testWidgets('handles error states gracefully', (WidgetTester tester) async {
      // Test with non-existent group
      const invalidGroupId = 'non-existent-group';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GroupDetailsScreen(groupId: invalidGroupId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show error state
      expect(find.text('Failed to load group details'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

Future<void> _navigateThroughTabs(WidgetTester tester) async {
  // Navigate to Members tab
  await tester.tap(find.text('Members'));
  await tester.pumpAndSettle();
  expect(find.text('Members'), findsOneWidget);

  // Navigate to Admin tab
  await tester.tap(find.text('Admin'));
  await tester.pumpAndSettle();
  expect(find.text('Quick Actions'), findsOneWidget);

  // Navigate to Policy tab
  await tester.tap(find.text('Policy'));
  await tester.pumpAndSettle();
  expect(find.text('Group Policies'), findsOneWidget);

  // Navigate to Votes tab
  await tester.tap(find.text('Votes'));
  await tester.pumpAndSettle();
  expect(find.text('Open Votes'), findsOneWidget);

  // Navigate to Audit tab
  await tester.tap(find.text('Audit'));
  await tester.pumpAndSettle();
  expect(find.text('Audit Log'), findsOneWidget);
}

Future<void> _testPolicyTab(WidgetTester tester) async {
  // Navigate to Policy tab
  await tester.tap(find.text('Policy'));
  await tester.pumpAndSettle();

  // Find and toggle a policy switch
  final switches = find.byType(Switch);
  if (switches.evaluate().isNotEmpty) {
    final initialSwitch = switches.first.evaluate().single.widget as Switch;
    final initialValue = initialSwitch.value;

    // Tap the switch
    await tester.tap(switches.first);
    await tester.pumpAndSettle();

    // Verify state changed
    final updatedSwitch = switches.first.evaluate().single.widget as Switch;
    expect(updatedSwitch.value, isNot(equals(initialValue)));

    // Verify SnackBar appears
    expect(find.text('Policy updated successfully'), findsOneWidget);
  }
}

Future<void> _testVotesTab(WidgetTester tester) async {
  // Navigate to Votes tab
  await tester.tap(find.text('Votes'));
  await tester.pumpAndSettle();

  // Look for vote buttons
  final yesButton = find.text('Vote Yes');
  final noButton = find.text('Vote No');

  if (yesButton.evaluate().isNotEmpty) {
    // Cast a Yes vote
    await tester.tap(yesButton);
    await tester.pumpAndSettle();

    // Verify SnackBar appears
    expect(find.text('Vote cast: Yes'), findsOneWidget);

    // Verify buttons are disabled after voting
    expect(find.text('You voted Yes'), findsOneWidget);
  }

  // Test close vote functionality
  final closeButton = find.text('Close');
  if (closeButton.evaluate().isNotEmpty) {
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Close Vote'), findsOneWidget);
    expect(
        find.text('Are you sure you want to close this vote?'), findsOneWidget);

    // Cancel the close action
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  }
}

Future<void> _testMembersTab(WidgetTester tester) async {
  // Navigate to Members tab
  await tester.tap(find.text('Members'));
  await tester.pumpAndSettle();

  // Test promote member functionality
  final promoteButtons = find.byIcon(Icons.arrow_upward);
  if (promoteButtons.evaluate().isNotEmpty) {
    await tester.tap(promoteButtons.first);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Promote to Admin'), findsOneWidget);
    expect(find.textContaining('Are you sure you want to promote'),
        findsOneWidget);

    // Cancel the promotion
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  }

  // Test remove member functionality
  final removeButtons = find.byIcon(Icons.remove_circle_outline);
  if (removeButtons.evaluate().isNotEmpty) {
    await tester.tap(removeButtons.first);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Remove Member'), findsOneWidget);
    expect(
        find.textContaining('Are you sure you want to remove'), findsOneWidget);

    // Cancel the removal
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  }

  // Test transfer ownership functionality
  final transferButtons = find.byIcon(Icons.swap_horiz);
  if (transferButtons.evaluate().isNotEmpty) {
    await tester.tap(transferButtons.first);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Transfer Ownership'), findsOneWidget);
    expect(find.textContaining('Are you sure you want to transfer'),
        findsOneWidget);

    // Cancel the transfer
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  }
}
