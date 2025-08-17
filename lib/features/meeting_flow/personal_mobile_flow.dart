import 'package:flutter/material.dart';
import 'steps/greet_step.dart';
import 'steps/type_step.dart';
import 'steps/participants_step.dart';
import 'steps/review_step.dart';
import '../../core/preview_flags.dart';

class PersonalMobileFlow extends StatefulWidget {
  const PersonalMobileFlow({super.key});
  @override
  State<PersonalMobileFlow> createState() => _PersonalMobileFlowState();
}

class _PersonalMobileFlowState extends State<PersonalMobileFlow> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    final flags = PreviewFlags.fromEnvironmentAndUrl();
    if (flags.skipSetup) index = 1;
  }

  @override
  Widget build(BuildContext context) {
    print('[[FLOW]] PersonalMobileFlow BUILD (index=$index)');
    final steps = <Widget>[
      const GreetStep(),
      const TypeStep(),
      const ParticipantsStep(),
      const ReviewStep(),
    ];
    return Stack(children: const [
      // The actual UI
      // Note: keeping a simple scaffold like MeetingFlow for parity
      // but adding a banner overlay to disambiguate.
      // We use a separate file/class name to avoid barrel export conflicts.
      // The scaffold below is inlined for clarity.
    ]);
  }
}

