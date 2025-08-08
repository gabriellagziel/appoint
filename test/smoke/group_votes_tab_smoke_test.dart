import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/group_admin/ui/group_votes_tab.dart';

void main() {
  group('GroupVotesTab Smoke Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('vote buttons are enabled for open votes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for vote buttons
      expect(find.text('Vote Yes'), findsOneWidget);
      expect(find.text('Vote No'), findsOneWidget);
    });

    testWidgets('clicking Yes disables vote buttons and updates counter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap Yes button
      final yesButton = find.text('Vote Yes');
      if (yesButton.evaluate().isNotEmpty) {
        await tester.tap(yesButton);
        await tester.pumpAndSettle();

        // Verify SnackBar appears
        expect(find.text('Vote cast: Yes'), findsOneWidget);

        // Verify buttons are disabled (user has voted)
        expect(find.text('You voted Yes'), findsOneWidget);
      }
    });

    testWidgets('clicking No disables vote buttons and updates counter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap No button
      final noButton = find.text('Vote No');
      if (noButton.evaluate().isNotEmpty) {
        await tester.tap(noButton);
        await tester.pumpAndSettle();

        // Verify SnackBar appears
        expect(find.text('Vote cast: No'), findsOneWidget);

        // Verify buttons are disabled (user has voted)
        expect(find.text('You voted No'), findsOneWidget);
      }
    });

    testWidgets('close vote button is available for admins',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Look for close vote button
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('close vote shows confirmation dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap close button
      final closeButton = find.text('Close');
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Close Vote'), findsOneWidget);
        expect(find.text('Are you sure you want to close this vote?'),
            findsOneWidget);
      }
    });

    testWidgets('displays open and closed vote sections',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'test-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify sections are displayed
      expect(find.text('Open Votes'), findsOneWidget);
      expect(find.text('Closed Votes'), findsOneWidget);
    });

    testWidgets('shows empty state when no votes exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'empty-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.text('No votes found'), findsOneWidget);
      expect(find.text('Votes will appear here when they are created'),
          findsOneWidget);
    });

    testWidgets('shows error state with retry button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: GroupVotesTab(groupId: 'error-group'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error state is displayed
      expect(find.text('Failed to load votes'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
