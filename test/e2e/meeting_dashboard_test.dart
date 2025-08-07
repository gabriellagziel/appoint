import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_oint/features/meeting_dashboard/presentation/meeting_dashboard.dart';
import 'package:app_oint/features/meeting_dashboard/services/meeting_dashboard_service.dart';
import 'package:app_oint/features/meeting_dashboard/widgets/meeting_overview_card.dart';
import 'package:app_oint/features/meeting_dashboard/widgets/participant_list_section.dart';
import 'package:app_oint/features/meeting_dashboard/widgets/edit_meeting_dialog.dart';
import 'package:app_oint/features/meeting_dashboard/widgets/meeting_analytics_summary.dart';
import 'package:app_oint/features/meeting_dashboard/widgets/follow_up_actions_panel.dart';
import 'package:app_oint/features/create_meeting/domain/models/meeting_models.dart';

void main() {
  group('Meeting Dashboard E2E Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should display meeting dashboard correctly', (WidgetTester tester) async {
      const meetingId = 'test_meeting_123';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: MeetingDashboard(meetingId: meetingId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Meeting Dashboard'), findsOneWidget);
      expect(find.text('Team Meeting'), findsOneWidget);
      expect(find.text('Participants'), findsOneWidget);
      expect(find.text('Analytics Summary'), findsOneWidget);
    });

    testWidgets('should show edit dialog for owner', (WidgetTester tester) async {
      const meetingId = 'test_meeting_123';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: MeetingDashboard(meetingId: meetingId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit Meeting'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('should display participant list with tabs', (WidgetTester tester) async {
      const meetingId = 'test_meeting_123';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: MeetingDashboard(meetingId: meetingId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for participant section
      expect(find.text('Participants'), findsOneWidget);
    });

    testWidgets('should show analytics summary with metrics', (WidgetTester tester) async {
      const meetingId = 'test_meeting_123';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: MeetingDashboard(meetingId: meetingId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for analytics metrics
      expect(find.text('Total Invited'), findsOneWidget);
      expect(find.text('Analytics Summary'), findsOneWidget);
    });

    testWidgets('should show follow-up actions for owner', (WidgetTester tester) async {
      const meetingId = 'test_meeting_123';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: MeetingDashboard(meetingId: meetingId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for follow-up actions
      expect(find.text('Follow-up Actions'), findsOneWidget);
      expect(find.text('Send Reminder'), findsOneWidget);
      expect(find.text('Send Update'), findsOneWidget);
      expect(find.text('Reschedule'), findsOneWidget);
      expect(find.text('Cancel Meeting'), findsOneWidget);
    });

    testWidgets('should handle meeting editing', (WidgetTester tester) async {
      const meetingId = 'test_meeting_123';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: MeetingDashboard(meetingId: meetingId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open edit dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Check edit form fields
      expect(find.text('Edit Meeting'), findsOneWidget);
      expect(find.text('Meeting Title *'), findsOneWidget);
      expect(find.text('Meeting Notes'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('should display meeting overview card correctly', (WidgetTester tester) async {
      final meeting = Meeting(
        id: 'test_meeting_123',
        title: 'Test Meeting',
        participants: [],
        meetingType: MeetingType.group,
        meetingTime: MeetingTime(
          dateTime: DateTime.now().add(const Duration(days: 1)),
        ),
        status: 'active',
        createdAt: DateTime.now(),
        createdBy: 'test@example.com',
        shareLink: 'https://app-oint.com/invite/test_meeting_123',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeetingOverviewCard(
              meeting: meeting,
              isOwner: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Meeting'), findsOneWidget);
      expect(find.text('Owner'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('should handle participant actions', (WidgetTester tester) async {
      final participants = [
        GuestParticipant(
          id: '1',
          name: 'Test Participant',
          email: 'test@example.com',
          status: 'accepted',
          createdAt: DateTime.now(),
          meetingId: 'test_meeting_123',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticipantListSection(
              participants: participants,
              meetingId: 'test_meeting_123',
              onParticipantUpdated: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Participant'), findsOneWidget);
      expect(find.text('Accepted'), findsOneWidget);
    });

    test('should get meeting analytics', () async {
      const meetingId = 'test_meeting_123';
      
      final analytics = await MeetingDashboardService.getMeetingAnalyticsSummary(meetingId);
      
      expect(analytics['totalInvited'], greaterThan(0));
      expect(analytics['accepted'], greaterThanOrEqualTo(0));
      expect(analytics['acceptanceRate'], isA<double>());
    });

    test('should get participant statistics', () async {
      final participants = [
        GuestParticipant(
          id: '1',
          name: 'Accepted User',
          status: 'accepted',
          createdAt: DateTime.now(),
          meetingId: 'test_meeting_123',
        ),
        GuestParticipant(
          id: '2',
          name: 'Declined User',
          status: 'declined',
          createdAt: DateTime.now(),
          meetingId: 'test_meeting_123',
        ),
        GuestParticipant(
          id: '3',
          name: 'Pending User',
          status: 'pending',
          createdAt: DateTime.now(),
          meetingId: 'test_meeting_123',
        ),
      ];

      final stats = MeetingDashboardService.getParticipantStats(participants);
      
      expect(stats['total'], equals(3));
      expect(stats['accepted'], equals(1));
      expect(stats['declined'], equals(1));
      expect(stats['pending'], equals(1));
    });

    test('should update meeting successfully', () async {
      const meetingId = 'test_meeting_123';
      
      final success = await MeetingDashboardService.updateMeeting(
        meetingId: meetingId,
        title: 'Updated Meeting Title',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        notes: 'Updated meeting notes',
      );
      
      expect(success, isTrue);
    });

    test('should send follow-up message successfully', () async {
      const meetingId = 'test_meeting_123';
      
      final success = await MeetingDashboardService.sendFollowUpMessage(
        meetingId: meetingId,
        message: 'Test follow-up message',
        participantIds: ['1', '2', '3'],
        messageType: 'push',
      );
      
      expect(success, isTrue);
    });

    test('should reschedule meeting successfully', () async {
      const meetingId = 'test_meeting_123';
      
      final success = await MeetingDashboardService.rescheduleMeeting(
        meetingId: meetingId,
        newDateTime: DateTime.now().add(const Duration(days: 3)),
      );
      
      expect(success, isTrue);
    });

    test('should cancel meeting successfully', () async {
      const meetingId = 'test_meeting_123';
      
      final success = await MeetingDashboardService.cancelMeeting(meetingId);
      
      expect(success, isTrue);
    });
  });
} 