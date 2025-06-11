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
              events.sort((a, b) => a.start.compareTo(b.start));
              if (events.isEmpty) {
                return const Center(child: Text('No events'));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final e = events[index];
                  return ListTile(
                    title: Text(e.title),
                    subtitle: Text(
                        '${e.start} - ${e.end} (${e.provider})'),
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
