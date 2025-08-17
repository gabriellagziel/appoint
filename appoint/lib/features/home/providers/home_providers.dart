// lib/features/home/providers/home_providers.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ===== Models (assumes you already have Meeting/Reminder models) =====
// If your models live elsewhere, just import them and delete these stubs.
class Meeting {
  final String id;
  final DateTime startAt;
  final String title;
  Meeting({required this.id, required this.startAt, required this.title});

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Meeting(
      id: doc.id,
      startAt: (d['startAt'] as Timestamp).toDate().toLocal(),
      title: (d['title'] as String?) ?? 'Meeting',
    );
  }
}

class Reminder {
  final String id;
  final DateTime dueAt;
  final String text;
  Reminder({required this.id, required this.dueAt, required this.text});

  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Reminder(
      id: doc.id,
      dueAt: (d['dueAt'] as Timestamp).toDate().toLocal(),
      text: (d['text'] as String?) ?? 'Reminder',
    );
  }
}

// Union for merged agenda
@immutable
class AgendaItem {
  final DateTime at;
  final Meeting? meeting;
  final Reminder? reminder;
  final String kind; // 'meeting' | 'reminder'

  const AgendaItem._(this.at, this.meeting, this.reminder, this.kind);
  factory AgendaItem.meeting(Meeting m) =>
      AgendaItem._(m.startAt, m, null, 'meeting');
  factory AgendaItem.reminder(Reminder r) =>
      AgendaItem._(r.dueAt, null, r, 'reminder');
}

// ===== Feature flag to switch between dummy and real data =====
final useRealAgendaProvider = Provider<bool>((_) {
  const v = String.fromEnvironment('USE_REAL_AGENDA', defaultValue: 'false');
  return v.toLowerCase() == 'true';
});

// ===== Auth (current user) =====
final firebaseUserProvider = StreamProvider<User?>((_) {
  return FirebaseAuth.instance.authStateChanges();
});

// ===== Dummy (kept for tests / offline dev) =====
final _dummyMeetingsProvider = Provider<List<Meeting>>((_) => <Meeting>[
      Meeting(
          id: 'm1',
          startAt: DateTime.now().copyWith(hour: 9, minute: 0),
          title: 'Standup'),
    ]);
final _dummyRemindersProvider = Provider<List<Reminder>>((_) => <Reminder>[
      Reminder(
          id: 'r1',
          dueAt: DateTime.now().copyWith(hour: 8, minute: 30),
          text: 'Send report'),
    ]);

// ===== Real Firestore sources (auto-wired when USE_REAL_AGENDA=true) =====
final _todayMeetingsFsProvider =
    StreamProvider.autoDispose<List<Meeting>>((ref) async* {
  final user = await ref.watch(firebaseUserProvider.future);
  if (user == null) {
    yield const <Meeting>[];
    return;
  }
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final dayEnd = dayStart.add(const Duration(days: 1));

  final qs = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('meetings')
      .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
      .where('startAt', isLessThan: Timestamp.fromDate(dayEnd))
      .orderBy('startAt')
      .snapshots();

  await for (final snap in qs) {
    yield snap.docs.map((d) => Meeting.fromFirestore(d)).toList();
  }
});

final _todayRemindersFsProvider =
    StreamProvider.autoDispose<List<Reminder>>((ref) async* {
  final user = await ref.watch(firebaseUserProvider.future);
  if (user == null) {
    yield const <Reminder>[];
    return;
  }
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final dayEnd = dayStart.add(const Duration(days: 1));

  final qs = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('reminders')
      .where('dueAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
      .where('dueAt', isLessThan: Timestamp.fromDate(dayEnd))
      .orderBy('dueAt')
      .snapshots();

  await for (final snap in qs) {
    yield snap.docs.map((d) => Reminder.fromFirestore(d)).toList();
  }
});

// ===== Public providers used by UI =====

// Expose “todayMeetingsProvider” and “todayRemindersProvider” with seamless switch.
// If USE_REAL_AGENDA=true -> take Firestore streams; else -> dummy lists.
final todayMeetingsProvider = Provider<AsyncValue<List<Meeting>>>((ref) {
  final real = ref.watch(useRealAgendaProvider);
  if (real) return ref.watch(_todayMeetingsFsProvider);
  return AsyncValue.data(ref.watch(_dummyMeetingsProvider));
});

final todayRemindersProvider = Provider<AsyncValue<List<Reminder>>>((ref) {
  final real = ref.watch(useRealAgendaProvider);
  if (real) return ref.watch(_todayRemindersFsProvider);
  return AsyncValue.data(ref.watch(_dummyRemindersProvider));
});

// Merged agenda (meeting + reminder) with ascending time
final mergedAgendaProvider = Provider<AsyncValue<List<AgendaItem>>>((ref) {
  final m = ref.watch(todayMeetingsProvider);
  final r = ref.watch(todayRemindersProvider);

  if (m is AsyncData<List<Meeting>> && r is AsyncData<List<Reminder>>) {
    final items = <AgendaItem>[
      ...m.value.map(AgendaItem.meeting),
      ...r.value.map(AgendaItem.reminder),
    ]..sort((a, b) {
        final cmp = a.at.compareTo(b.at);
        if (cmp != 0) return cmp;
        // Tie-breaker: reminders before meetings at the same minute
        final aRem = a.reminder != null;
        final bRem = b.reminder != null;
        return (aRem == bRem) ? 0 : (aRem ? -1 : 1);
      });
    return AsyncValue.data(items);
  }
  if (m is AsyncError) {
    final err = m.error ?? 'error';
    final st = m.stackTrace ?? StackTrace.current;
    return AsyncValue.error(err, st);
  }
  if (r is AsyncError) {
    final err = r.error ?? 'error';
    final st = r.stackTrace ?? StackTrace.current;
    return AsyncValue.error(err, st);
  }
  return const AsyncValue.loading();
});

// Suggestions – simple heuristic (kept)
class Suggestion {
  final String label;
  final IconData icon;
  final String route;

  const Suggestion(
      {required this.label, required this.icon, required this.route});
}

final suggestionsProvider = Provider<List<Suggestion>>((ref) {
  final now = DateTime.now();
  final isWeekendSoon = now.weekday >= DateTime.thursday;
  final hasOverdue = false;
  final hasLargeSlot = true;

  final suggestions = <Suggestion>[];
  if (hasOverdue) {
    suggestions.add(const Suggestion(
        label: 'Catch up on overdue',
        icon: Icons.notifications_active,
        route: '/reminders'));
  }
  if (hasLargeSlot) {
    suggestions.add(const Suggestion(
        label: 'Plan a quick coffee?',
        icon: Icons.local_cafe,
        route: '/meeting/create'));
  }
  if (isWeekendSoon) {
    suggestions.add(const Suggestion(
        label: 'Family plan for the weekend',
        icon: Icons.family_restroom,
        route: '/meeting/create'));
  }
  return suggestions;
});
