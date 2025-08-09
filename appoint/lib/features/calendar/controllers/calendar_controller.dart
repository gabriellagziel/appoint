import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../models/agenda_item.dart';

// Calendar state sealed class
sealed class CalendarState {
  const CalendarState();

  T when<T>({
    required T Function() loading,
    required T Function(List<AgendaItem> agenda) data,
    required T Function(String errorMsg) errorCallback,
  }) {
    return switch (this) {
      CalendarLoading() => loading(),
      CalendarData(agenda: final agenda) => data(agenda),
      CalendarError(error: final error) => errorCallback(error),
    };
  }
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarData extends CalendarState {
  final List<AgendaItem> agenda;

  const CalendarData(this.agenda);
}

class CalendarError extends CalendarState {
  final String error;

  const CalendarError(this.error);
}

class CalendarController extends StateNotifier<CalendarState> {
  CalendarController() : super(const CalendarLoading());

  /// Load today's agenda
  Future<void> loadTodayAgenda() async {
    state = const CalendarLoading();

    try {
      // Mock data for now - in production this would fetch from Firebase
      final agenda = await _fetchMockAgenda();

      // Sort by time
      agenda.sort((a, b) => a.time.compareTo(b.time));

      state = CalendarData(agenda);
    } catch (e) {
      state = CalendarError(e.toString());
    }
  }

  /// Fetch mock agenda data
  Future<List<AgendaItem>> _fetchMockAgenda() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      // Mock meetings
      AgendaItem(
        id: 'meeting_1',
        title: 'Team Standup',
        time: today.add(const Duration(hours: 9, minutes: 0)),
        type: AgendaItemType.meeting,
        metadata: {
          'participants': ['Alice', 'Bob', 'Charlie'],
          'location': 'Conference Room A',
        },
      ),
      AgendaItem(
        id: 'meeting_2',
        title: 'Client Presentation',
        time: today.add(const Duration(hours: 14, minutes: 30)),
        type: AgendaItemType.meeting,
        metadata: {
          'participants': ['David', 'Eve'],
          'location': 'Zoom Meeting',
        },
      ),
      // Mock reminders
      AgendaItem(
        id: 'reminder_1',
        title: 'Submit weekly report',
        time: today.add(const Duration(hours: 17, minutes: 0)),
        type: AgendaItemType.reminder,
        metadata: {
          'priority': 'high',
          'category': 'work',
        },
      ),
      AgendaItem(
        id: 'reminder_2',
        title: 'Call mom',
        time: today.add(const Duration(hours: 19, minutes: 0)),
        type: AgendaItemType.reminder,
        metadata: {
          'priority': 'medium',
          'category': 'personal',
        },
      ),
    ];
  }

  /// Refresh agenda
  Future<void> refresh() async {
    await loadTodayAgenda();
  }
}

// Riverpod provider
final calendarControllerProvider =
    StateNotifierProvider<CalendarController, CalendarState>((ref) {
  final controller = CalendarController();
  // Load agenda on first access
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.loadTodayAgenda();
  });
  return controller;
});
