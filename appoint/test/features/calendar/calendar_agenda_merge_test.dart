import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lib/features/calendar/controllers/calendar_controller.dart';
import '../../../lib/features/calendar/widgets/day_agenda_list.dart';
import '../../../lib/models/agenda_item.dart';

void main() {
  group('Calendar Agenda Merge Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should merge meetings and reminders sorted by time', () async {
      final controller = container.read(calendarControllerProvider.notifier);

      await controller.loadTodayAgenda();

      final state = container.read(calendarControllerProvider);

      state.when(
        loading: () => fail('Should not be loading'),
        data: (agenda) {
          // Should have both meetings and reminders
          expect(agenda.length, greaterThan(0));

          // Should be sorted by time
          for (int i = 0; i < agenda.length - 1; i++) {
            expect(agenda[i].time.isBefore(agenda[i + 1].time), isTrue);
          }

          // Should have both types
          final hasMeetings = agenda.any((item) => item.isMeeting);
          final hasReminders = agenda.any((item) => item.isReminder);

          expect(hasMeetings, isTrue);
          expect(hasReminders, isTrue);
        },
        errorCallback: (error) => fail('Should not have error: $error'),
      );
    });

    testWidgets('should display agenda items with correct styling',
        (WidgetTester tester) async {
      final mockAgenda = [
        AgendaItem(
          id: 'meeting_1',
          title: 'Team Standup',
          time: DateTime.now().add(const Duration(hours: 9)),
          type: AgendaItemType.meeting,
          metadata: {
            'participants': ['Alice', 'Bob'],
            'location': 'Conference Room A',
          },
        ),
        AgendaItem(
          id: 'reminder_1',
          title: 'Submit report',
          time: DateTime.now().add(const Duration(hours: 17)),
          type: AgendaItemType.reminder,
          metadata: {
            'priority': 'high',
            'category': 'work',
          },
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DayAgendaList(
              agenda: mockAgenda,
              onMeetingTap: (meetingId) {
                // Mock navigation
              },
              onReminderTap: (reminderId) {
                // Mock navigation
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display meeting title
      expect(find.text('Team Standup'), findsOneWidget);

      // Should display reminder title
      expect(find.text('Submit report'), findsOneWidget);

      // Should show participant count for meetings
      expect(find.text('2 participants'), findsOneWidget);

      // Should show location for meetings
      expect(find.text('Conference Room A'), findsOneWidget);

      // Should show category for reminders
      expect(find.text('WORK'), findsOneWidget);

      // Should show priority for reminders
      expect(find.text('HIGH'), findsOneWidget);
    });

    testWidgets('should handle tap on meeting item',
        (WidgetTester tester) async {
      bool meetingTapped = false;
      String? tappedMeetingId;

      final mockAgenda = [
        AgendaItem(
          id: 'meeting_123',
          title: 'Test Meeting',
          time: DateTime.now().add(const Duration(hours: 1)),
          type: AgendaItemType.meeting,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DayAgendaList(
              agenda: mockAgenda,
              onMeetingTap: (meetingId) {
                meetingTapped = true;
                tappedMeetingId = meetingId;
              },
              onReminderTap: (reminderId) {
                // Not called for meetings
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the meeting item
      await tester.tap(find.text('Test Meeting'));
      await tester.pumpAndSettle();

      // Should call the meeting tap callback
      expect(meetingTapped, isTrue);
      expect(tappedMeetingId, equals('meeting_123'));
    });

    testWidgets('should handle tap on reminder item',
        (WidgetTester tester) async {
      bool reminderTapped = false;
      String? tappedReminderId;

      final mockAgenda = [
        AgendaItem(
          id: 'reminder_456',
          title: 'Test Reminder',
          time: DateTime.now().add(const Duration(hours: 2)),
          type: AgendaItemType.reminder,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DayAgendaList(
              agenda: mockAgenda,
              onMeetingTap: (meetingId) {
                // Not called for reminders
              },
              onReminderTap: (reminderId) {
                reminderTapped = true;
                tappedReminderId = reminderId;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the reminder item
      await tester.tap(find.text('Test Reminder'));
      await tester.pumpAndSettle();

      // Should call the reminder tap callback
      expect(reminderTapped, isTrue);
      expect(tappedReminderId, equals('reminder_456'));
    });

    testWidgets('should show empty state when no agenda items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DayAgendaList(
              agenda: const [],
              onMeetingTap: (meetingId) {},
              onReminderTap: (reminderId) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty state message
      expect(find.text('No events today'), findsOneWidget);
      expect(find.text('Your meetings and reminders will appear here'),
          findsOneWidget);
    });

    test('should handle calendar controller refresh', () async {
      final controller = container.read(calendarControllerProvider.notifier);

      // Load initial agenda
      await controller.loadTodayAgenda();

      // Refresh agenda
      await controller.refresh();

      final state = container.read(calendarControllerProvider);

      state.when(
        loading: () => fail('Should not be loading after refresh'),
        data: (agenda) {
          expect(agenda, isNotEmpty);
        },
        errorCallback: (error) => fail('Should not have error after refresh: $error'),
      );
    });
  });
}
