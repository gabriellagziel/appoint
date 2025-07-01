import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/providers/calendar_provider.dart';

class CalendarViewScreen extends ConsumerWidget {
  const CalendarViewScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final googleAsync = ref.watch(googleEventsProvider);
    final outlookAsync = ref.watch(outlookEventsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: googleAsync.when(
        data: (final gEvents) {
          return outlookAsync.when(
            data: (final oEvents) {
              final events = [...gEvents, ...oEvents];
              events.sort((final a, final b) => a.startTime.compareTo(b.startTime));
              if (events.isEmpty) {
                return const Center(child: Text('No events'));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (final context, final index) {
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
            error: (final _, final __) => const Center(child: Text('Error loading events')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final _, final __) => const Center(child: Text('Error loading events')),
      ),
    );
  }
}
