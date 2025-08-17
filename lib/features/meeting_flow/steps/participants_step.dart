import 'package:flutter/material.dart';
import '../widgets/mobile_flow_scaffold.dart';

class ParticipantsStep extends StatelessWidget {
  final VoidCallback? onNext;
  const ParticipantsStep({super.key, this.onNext});
  @override
  Widget build(BuildContext context) {
    return MobileFlowScaffold(
      title: 'בחר משתתפים',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Select participants'),
        ],
      ),
      bottom: FilledButton(
        onPressed: onNext,
        child: const Text('המשך'),
      ),
    );
  }
}
