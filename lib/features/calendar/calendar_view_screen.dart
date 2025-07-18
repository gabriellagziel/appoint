import 'dart:core';

import 'package:appoint/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewScreen extends ConsumerWidget {
  const CalendarViewScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final googleAsync = ref.watch(googleEventsProvider);
    final outlookAsync = ref.watch(outlookEventsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: googleAsync.when(
        data: (gEvents) => outlookAsync.when(
            data: (oEvents) {
              final events = [...gEvents, ...oEvents];
              events.sort(
                  (a, final b) => a.startTime.compareTo(b.startTime),);
              if (events.isEmpty) {
                return const Center(child: Text('No events'));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, final index) {
                  final event = events[index];
                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text('${event.startTime} - ${event.endTime}'),
                    trailing: Text(event.location ?? ''),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, final __) =>
                const Center(child: Text('Error loading events')),
          ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, final __) =>
            const Center(child: Text('Error loading events')),
      ),
    );
  }
}
