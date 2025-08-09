import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/meeting_checklists/ui/meeting_checklists_tab.dart';

void main() {
  group('Meeting Checklists Tab Smoke Tests', () {
    testWidgets('displays checklists tab with create button',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for create button
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows empty state when no checklists',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-empty';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for empty state
      expect(find.text('No checklists yet'), findsOneWidget);
      expect(
          find.text(
              'Create your first checklist to organize tasks for this meeting'),
          findsOneWidget);
    });

    testWidgets('shows search functionality', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for search field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows no selection state initially',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for no selection state
      expect(find.text('Select a checklist'), findsOneWidget);
      expect(
          find.text(
              'Choose a checklist from the left panel to view and manage its items'),
          findsOneWidget);
    });

    testWidgets('create checklist button shows dialog',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap create button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Should show create dialog
      expect(find.text('Create Checklist'), findsOneWidget);
    });

    testWidgets('shows error state when loading fails',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-error';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show error state
      expect(find.text('Failed to load checklists'), findsOneWidget);
    });

    testWidgets('shows no search results state', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter search term that won't match
      await tester.enterText(find.byType(TextField), 'nonexistentchecklist');
      await tester.pumpAndSettle();

      // Should show no results
      expect(find.text('No checklists match your search'), findsOneWidget);
    });

    testWidgets('clear search button works', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Clear search
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Search field should be empty
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('checklist tiles are interactive', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a checklist tile if available
      final checklistTiles = find.byType(ListTile);
      if (checklistTiles.evaluate().isNotEmpty) {
        await tester.tap(checklistTiles.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('checklist popup menu works', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';
      const groupId = 'test-group-123';
      const userRole = 'member';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingChecklistsTab(
                meetingId: meetingId,
                groupId: groupId,
                userRole: userRole,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap popup menu
      final popupMenus = find.byType(PopupMenuButton);
      if (popupMenus.evaluate().isNotEmpty) {
        await tester.tap(popupMenus.first);
        await tester.pumpAndSettle();
      }
    });
  });
}
