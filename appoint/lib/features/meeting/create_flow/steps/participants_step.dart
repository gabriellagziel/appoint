import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class ParticipantsStep extends ConsumerWidget {
  const ParticipantsStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMeetingFlowControllerProvider);
    final ctrl = ref.read(createMeetingFlowControllerProvider.notifier);
    final candidates = const ['alice@x.com', 'bob@x.com', 'carol@x.com', 'dave@x.com'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick participants'),
        const SizedBox(height: 8),
        ...candidates.map((p) {
          final on = state.participantIds.contains(p);
          return CheckboxListTile(
            value: on,
            title: Text(p),
            onChanged: (_) {
              final set = state.participantIds.toList();
              if (on) {
                set.remove(p);
              } else {
                set.add(p);
              }
              ctrl.setParticipants(set);
            },
          );
        }),
      ],
    );
  }
}


