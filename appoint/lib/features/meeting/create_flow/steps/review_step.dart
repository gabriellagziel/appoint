import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/create_meeting_state.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  Widget _row(String label, String value, VoidCallback onEdit) => ListTile(
        title: Text(label),
        subtitle: Text(value.isEmpty ? '—' : value),
        trailing: TextButton(onPressed: onEdit, child: const Text('Edit')),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMeetingFlowControllerProvider);
    final ctrl = ref.read(createMeetingFlowControllerProvider.notifier);
    final steps = ctrl.steps;

    final type = state.type?.name ?? '—';
    final when = (state.start != null)
        ? '${state.start} → ${state.end}'
        : '—';
    final where = state.virtualUrl?.isNotEmpty == true
        ? 'Virtual: ${state.virtualUrl}'
        : (state.locationAddress ?? '—');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Type', type, () {
          final i = steps.indexOf(MeetingStep.info);
          if (i >= 0) ctrl.state = state.copyWith(currentIndex: i);
        }),
        _row('Title', state.title, () {
          final i = steps.indexOf(MeetingStep.info);
          if (i >= 0) ctrl.state = state.copyWith(currentIndex: i);
        }),
        _row('When', when, () {
          final i = steps.indexOf(MeetingStep.time);
          if (i >= 0) ctrl.state = state.copyWith(currentIndex: i);
        }),
        _row('Where', where, () {
          final isVirtual = state.virtualUrl?.isNotEmpty == true;
          final step = isVirtual ? MeetingStep.virtualUrl : MeetingStep.location;
          final i = steps.indexOf(step);
          if (i >= 0) ctrl.state = state.copyWith(currentIndex: i);
        }),
        _row('Participants', '${state.participantIds.length}', () {
          final i = steps.indexOf(MeetingStep.participants);
          if (i >= 0) ctrl.state = state.copyWith(currentIndex: i);
        }),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () async {
            final id = await ctrl.submit();
            if (id == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Could not create meeting. Check required fields.')),
              );
              return;
            }
            if (context.mounted) {
              // Adjust to your real route as needed
              Navigator.of(context).pushReplacementNamed('/meeting/$id');
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}


