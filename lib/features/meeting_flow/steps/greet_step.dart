import 'package:flutter/material.dart';
import '../widgets/mobile_flow_scaffold.dart';

class GreetStep extends StatelessWidget {
  final VoidCallback? onNext;
  const GreetStep({super.key, this.onNext});
  @override
  Widget build(BuildContext context) {
    return MobileFlowScaffold(
      title: 'בוקר טוב, גבריאל',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Ready to start a meeting?'),
        ],
      ),
      bottom: FilledButton(
        onPressed: onNext,
        child: const Text('המשך'),
      ),
    );
  }
}
