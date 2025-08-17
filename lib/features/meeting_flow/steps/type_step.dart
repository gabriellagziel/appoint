import 'package:flutter/material.dart';
import '../widgets/mobile_flow_scaffold.dart';

class TypeStep extends StatelessWidget {
  final VoidCallback? onNext;
  const TypeStep({super.key, this.onNext});
  @override
  Widget build(BuildContext context) {
    return MobileFlowScaffold(
      title: 'בחר סוג פגישה',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Choose meeting type'),
        ],
      ),
      bottom: FilledButton(
        onPressed: onNext,
        child: const Text('המשך'),
      ),
    );
  }
}
