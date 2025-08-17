import 'package:appoint/features/home/home_landing_screen.dart';
import 'package:flutter/material.dart';
// ignore_for_file: unused_import
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/home/providers/home_providers.dart';

void main() {
  testWidgets('HomeLandingScreen smoke test', (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HomeLandingScreen())));

    // Greeting text
    expect(
      find.byWidgetPredicate((w) =>
          w is Text &&
          (w.data?.contains('Good morning') == true ||
              w.data?.contains('Good afternoon') == true ||
              w.data?.contains('Good evening') == true ||
              w.data?.contains('Good night') == true)),
      findsOneWidget,
    );

    // Quick actions
    expect(find.byKey(const Key('qa_action_new_meeting')), findsOneWidget);
    expect(find.byKey(const Key('qa_action_add_reminder')), findsOneWidget);
    expect(find.byKey(const Key('qa_action_open_calendar')), findsOneWidget);
    // My Groups exists as outlined/secondary (by key)
    expect(find.byKey(const Key('qa_action_my_groups')), findsOneWidget);
  });
  testWidgets('Today agenda merges and sorts meeting+reminder', (tester) async {
    final meeting = Meeting(
      id: 'm1',
      startAt: DateTime(2025, 1, 1, 9, 0),
      title: 'Coffee chat',
    );
    final reminder = Reminder(
      id: 'r1',
      dueAt: DateTime(2025, 1, 1, 8, 30),
      text: 'Pay bill',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayMeetingsProvider
              .overrideWith((ref) => AsyncValue.data([meeting])),
          todayRemindersProvider
              .overrideWith((ref) => AsyncValue.data([reminder])),
        ],
        child: const MaterialApp(home: HomeLandingScreen()),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    // Ensure any lingering loading frame is cleared
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Pay bill'), findsWidgets);
    expect(find.text('Coffee chat'), findsWidgets);
  });

  testWidgets('TodayAgenda shows skeleton then data', (tester) async {
    // First pump with loading state
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayMeetingsProvider.overrideWith((_) => const AsyncValue.loading()),
          todayRemindersProvider
              .overrideWith((_) => const AsyncValue.loading()),
        ],
        child: const MaterialApp(home: HomeLandingScreen()),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('agenda_skeleton')), findsWidgets);

    // Re-pump with data state
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayMeetingsProvider.overrideWith((_) => AsyncValue.data([
                Meeting(
                    id: 'm1',
                    startAt: DateTime(2025, 1, 1, 9, 0),
                    title: 'Standup'),
              ])),
          todayRemindersProvider.overrideWith((_) => AsyncValue.data([
                Reminder(
                    id: 'r1',
                    dueAt: DateTime(2025, 1, 1, 8, 30),
                    text: 'Send report'),
              ])),
        ],
        child: const MaterialApp(home: HomeLandingScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byKey(const Key('agenda_skeleton')), findsNothing);
    expect(find.text('Send report'), findsOneWidget);
    expect(find.text('Standup'), findsOneWidget);
  });
}
