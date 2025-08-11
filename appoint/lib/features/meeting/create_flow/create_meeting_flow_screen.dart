import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'models/create_meeting_state.dart';
import 'widgets/step_header.dart';
import 'steps/info_step.dart';
import 'steps/participants_step.dart';
import 'steps/time_step.dart';
import 'steps/location_step.dart';
import 'steps/virtual_url_step.dart';
import 'steps/extras_step.dart';
import 'steps/review_step.dart';

class CreateMeetingFlowScreen extends ConsumerWidget {
  const CreateMeetingFlowScreen({super.key});

  Widget _bodyFor(MeetingStep step) {
    switch (step) {
      case MeetingStep.info:
        return const InfoStep();
      case MeetingStep.participants:
        return const ParticipantsStep();
      case MeetingStep.time:
        return const TimeStep();
      case MeetingStep.location:
        return const LocationStep();
      case MeetingStep.virtualUrl:
        return const VirtualUrlStep();
      case MeetingStep.extras:
        return const ExtrasStep();
      case MeetingStep.review:
        return const ReviewStep();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(REDACTED_TOKEN);
    final notifier = ref.read(REDACTED_TOKEN.notifier);
    final steps = notifier.steps;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Meeting')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StepHeader(steps: steps, currentIndex: state.currentIndex),
            const SizedBox(height: 16),
            Expanded(
                child: SingleChildScrollView(
                    child: _bodyFor(steps[state.currentIndex]))),
            const SizedBox(height: 12),
            Row(
              children: [
                if (state.currentIndex > 0)
                  OutlinedButton(
                      onPressed: notifier.back, child: const Text('Back')),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (state.currentIndex == steps.length - 1) {
                      if (notifier.canSubmit) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      notifier.next();
                    }
                  },
                  child: Text(state.currentIndex == steps.length - 1
                      ? 'Create'
                      : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
