import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/calendar_provider.dart';

class CalendarViewScreen extends ConsumerWidget {
  const CalendarViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAsync = ref.watch(googleEventsProvider);
    final outlookAsync = ref.watch(outlookEventsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: googleAsync.when(
        data: (gEvents) {
          return outlookAsync.when(
            data: (oEvents) {
              final events = [...gEvents, ...oEvents];
              events.sort((a, b) => a.startTime.compareTo(b.startTime));
              if (events.isEmpty) {
                return const Center(child: Text('No events'));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
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
            error: (_, __) => const Center(child: Text('Error loading events')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading events')),
      ),
    );
  }
}
