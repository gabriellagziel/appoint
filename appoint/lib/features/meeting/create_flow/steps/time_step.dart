import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class TimeStep extends ConsumerWidget {
  const TimeStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(REDACTED_TOKEN);
    final ctrl = ref.read(REDACTED_TOKEN.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick time (quick demo values)'),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          ElevatedButton(
              onPressed: () {
                final start = DateTime.now().add(const Duration(hours: 1));
                final end = start.add(const Duration(hours: 1));
                ctrl.setTime(start: start, end: end);
              },
              child: const Text('In 1 hour')),
          ElevatedButton(
              onPressed: () {
                final start = DateTime.now().add(const Duration(days: 1));
                final end = start.add(const Duration(hours: 1));
                ctrl.setTime(start: start, end: end);
              },
              child: const Text('Tomorrow')),
        ]),
        const SizedBox(height: 12),
        Text('Current: ${state.start ?? '-'} → ${state.end ?? '-'}'),
      ],
    );
  }
}


