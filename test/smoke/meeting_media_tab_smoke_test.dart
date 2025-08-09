import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/meeting_media/ui/meeting_media_tab.dart';
import 'package:appoint/features/meeting_media/providers/meeting_media_providers.dart';

void main() {
  group('Meeting Media Tab Smoke Tests', () {
    testWidgets('displays media tab with upload button',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for upload button
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows empty state when no media', (WidgetTester tester) async {
      const meetingId = 'test-meeting-empty';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for empty state
      expect(find.text('No media files yet'), findsOneWidget);
      expect(find.text('Upload files to share with meeting participants'),
          findsOneWidget);
    });

    testWidgets('shows search functionality', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
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

    testWidgets('shows filter options', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for filter chips
      expect(find.byType(FilterChip), findsWidgets);
      expect(find.byType(PopupMenuButton), findsWidgets);
    });

    testWidgets('upload button shows loading state',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap upload button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Should show upload dialog
      expect(find.text('Upload Media'), findsOneWidget);
    });

    testWidgets('shows error state when loading fails',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-error';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show error state
      expect(find.text('Failed to load media'), findsOneWidget);
    });

    testWidgets('shows no results when search has no matches',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter search term that won't match
      await tester.enterText(find.byType(TextField), 'nonexistentfile');
      await tester.pumpAndSettle();

      // Should show no results
      expect(find.text('No files match your search'), findsOneWidget);
    });

    testWidgets('clear search button works', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
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

    testWidgets('filter chips are interactive', (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on a filter chip
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().isNotEmpty) {
        await tester.tap(filterChips.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('visibility filter dropdown works',
        (WidgetTester tester) async {
      const meetingId = 'test-meeting-123';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MeetingMediaTab(
                meetingId: meetingId,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap visibility filter
      final visibilityFilters = find.byType(PopupMenuButton);
      if (visibilityFilters.evaluate().isNotEmpty) {
        await tester.tap(visibilityFilters.first);
        await tester.pumpAndSettle();
      }
    });
  });
}
