import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';
import '../models/create_meeting_state.dart';
import '../../../../services/analytics_service.dart';
import '../../../../services/ad_gate.dart';
import '../../../../services/pwa_after_create.dart';
import '../../../../services/user_flags.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  Widget _row(String label, String value, VoidCallback onEdit) => ListTile(
        title: Text(label),
        subtitle: Text(value.isEmpty ? '—' : value),
        trailing: TextButton(onPressed: onEdit, child: const Text('Edit')),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(REDACTED_TOKEN);
    final ctrl = ref.read(REDACTED_TOKEN.notifier);
    // final steps = ctrl.steps; // no longer needed here

    final type = state.type?.name ?? '—';
    final when = (state.start != null) ? '${state.start} → ${state.end}' : '—';
    final where = state.virtualUrl?.isNotEmpty == true
        ? 'Virtual: ${state.virtualUrl}'
        : (state.locationAddress ?? '—');

    // Validation summary
    final missing = <String>[];
    if (state.title.trim().isEmpty) missing.add('Title');
    if (state.start == null || state.end == null) missing.add('Time');
    final needsLocation =
        (state.virtualUrl == null || state.virtualUrl!.isEmpty) &&
            state.type != MeetingType.openCall;
    if (needsLocation &&
        (state.locationAddress == null || state.locationAddress!.isEmpty)) {
      missing.add('Location or Virtual URL');
    }
    final isValid = missing.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Type', type, () {
          ctrl.setInfo(title: state.title); // ensure notify
          ctrl.goTo(MeetingStep.info);
        }),
        _row('Title', state.title, () {
          ctrl.goTo(MeetingStep.info);
        }),
        _row('When', when, () {
          ctrl.goTo(MeetingStep.time);
        }),
        _row('Where', where, () {
          final isVirtual = state.virtualUrl?.isNotEmpty == true;
          final step =
              isVirtual ? MeetingStep.virtualUrl : MeetingStep.location;
          ctrl.goTo(step);
        }),
        _row('Participants', '${state.participantIds.length}', () {
          ctrl.goTo(MeetingStep.participants);
        }),
        if (!isValid)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Missing: ${missing.join(', ')}',
                style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: isValid
              ? () async {
                  // Ads gate: skip for premium users and all minors
                  final flags = await UserFlags.load();
                  bool adOk = true;
                  if (!flags.isPremium && !flags.isMinor) {
                    adOk = await AdGate.show(context);
                  }
                  if (!adOk) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Ad was not completed. Please try again.')),
                      );
                    }
                    return;
                  }
                  final id = await ctrl.submit();
                  if (id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Could not create meeting. Check required fields.')),
                    );
                    return;
                  }
                  await Analytics.log('create_meeting_submitted', {
                    'id': id,
                    'type': state.type?.name,
                    'participants': state.participantIds.length + 1,
                    'hasVirtual': state.virtualUrl?.isNotEmpty ?? false,
                    'hasLocation': (state.locationAddress != null),
                  });
                  // PWA A2HS cadence prompt (every 3rd meeting if not installed)
                  await PwaAfterCreate.maybePrompt(context);
                  if (!context.mounted) return;
                  try {
                    // Prefer GoRouter if available
                    // ignore: avoid_dynamic_calls
                    // Use dynamic access to avoid hard dep
                    // on GoRouter in this file.
                    // If it throws, fall back to Navigator.
                    // ignore: invalid_use_of_protected_member
                    (GoRouter.of(context)).go('/meeting/$id');
                  } catch (_) {
                    Navigator.of(context).pushReplacementNamed('/meeting/$id');
                  }
                }
              : null,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
