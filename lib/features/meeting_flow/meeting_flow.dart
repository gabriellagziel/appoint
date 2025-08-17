import 'package:flutter/material.dart';
import '../../core/preview_flags.dart';
import 'steps/greet_step.dart';
import 'steps/type_step.dart';
import 'steps/participants_step.dart';
import 'steps/review_step.dart';

class MeetingFlow extends StatefulWidget {
  const MeetingFlow({super.key});

  @override
  State<MeetingFlow> createState() => _MeetingFlowState();
}

class _MeetingFlowState extends State<MeetingFlow> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    final flags = PreviewFlags.fromEnvironmentAndUrl();
    index = flags.skipSetup ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    void goNext() {
      if (index < 3) {
        setState(() => index += 1);
      }
    }

    final steps = <Widget>[
      GreetStep(onNext: goNext),
      TypeStep(onNext: goNext),
      ParticipantsStep(onNext: goNext),
      ReviewStep(onConfirm: () {}),
    ];

    print('[[FLOW]] MeetingFlow BUILD (index=$index)');
    return Scaffold(body: SafeArea(child: steps[index]));
  }
}
