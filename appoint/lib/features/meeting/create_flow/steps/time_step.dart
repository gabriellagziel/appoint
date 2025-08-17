import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers.dart';

class TimeStep extends ConsumerWidget {
  const TimeStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMeetingFlowControllerProvider);
    final ctrl = ref.read(createMeetingFlowControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('When is it happening?',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(children: [
          OutlinedButton(
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                firstDate: now,
                lastDate: now.add(const Duration(days: 365)),
                initialDate: state.start ?? now,
              );
              if (picked == null) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(state.start ?? now),
              );
              if (time == null) return;
              final start = DateTime(picked.year, picked.month, picked.day,
                  time.hour, time.minute);
              final end = start.add(const Duration(hours: 1));
              ctrl.setTime(start: start, end: end);
            },
            child: const Text('Pick date & time'),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'none', child: Text('No repeat')),
              PopupMenuItem(value: 'daily', child: Text('Repeat: Daily')),
              PopupMenuItem(value: 'weekly', child: Text('Repeat: Weekly')),
              PopupMenuItem(value: 'monthly', child: Text('Repeat: Monthly')),
            ],
            onSelected: (v) {
              ctrl.setRecurrence(v);
            },
            child: const Text('Recurrence'),
          ),
        ]),
        const SizedBox(height: 12),
        Text(
          'Current: '
          '${state.start == null ? '-' : DateFormat('EEE, MMM d • HH:mm').format(state.start!)}'
          ' → '
          '${state.end == null ? '-' : DateFormat('HH:mm').format(state.end!)}',
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Flexible window (optional)',
                hintText: 'e.g., after 5pm, sometime next week',
              ),
              onChanged: (v) =>
                  ctrl.setFlexibleNote(v.trim().isEmpty ? null : v.trim()),
            ),
          ),
        ]),
      ],
    );
  }
}
