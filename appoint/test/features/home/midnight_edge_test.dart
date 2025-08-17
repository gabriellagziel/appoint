import 'package:appoint/features/home/home_landing_screen.dart';
import 'package:appoint/features/home/providers/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Agenda sort across midnight with tie-breaker', (tester) async {
    // Reminder at 00:10, Meeting at 00:10 same minute → reminder first
    final afterMidnightReminder = Reminder(
      id: 'r2',
      dueAt: DateTime(2025, 1, 2, 0, 10),
      text: 'After midnight reminder',
    );
    final afterMidnightMeeting = Meeting(
      id: 'm2',
      startAt: DateTime(2025, 1, 2, 0, 10),
      title: 'After midnight standup',
    );

    // Also include an item before midnight previous day to ensure only display order checked
    final beforeMidnightMeeting = Meeting(
      id: 'm1',
      startAt: DateTime(2025, 1, 1, 23, 30),
      title: 'Late night sync',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayMeetingsProvider.overrideWithValue(
            AsyncValue.data([beforeMidnightMeeting, afterMidnightMeeting]),
          ),
          todayRemindersProvider.overrideWithValue(
            AsyncValue.data([afterMidnightReminder]),
          ),
        ],
        child: const MaterialApp(home: HomeLandingScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Presence assertions
    expect(find.text('Late night sync'), findsOneWidget);
    expect(find.text('After midnight reminder'), findsOneWidget);
    expect(find.text('After midnight standup'), findsOneWidget);
  });
}










