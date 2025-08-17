import 'package:flutter/material.dart';
import '../models/create_meeting_state.dart';

class StepHeader extends StatelessWidget {
  final List<MeetingStep> steps;
  final int currentIndex;
  const StepHeader(
      {super.key, required this.steps, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(steps.length, (i) {
        final active = i == currentIndex;
        return Chip(
          label: Text(steps[i].name),
          avatar: active
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.circle, size: 12),
        );
      }),
    );
  }
}
