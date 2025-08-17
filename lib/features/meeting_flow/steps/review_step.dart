import 'package:flutter/material.dart';
import '../widgets/mobile_flow_scaffold.dart';

class ReviewStep extends StatelessWidget {
  final VoidCallback? onConfirm;
  const ReviewStep({super.key, this.onConfirm});
  @override
  Widget build(BuildContext context) {
    return MobileFlowScaffold(
      title: 'סקירה ואישור',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Review and confirm'),
        ],
      ),
      bottom: FilledButton(
        onPressed: onConfirm,
        child: const Text('אשר'),
      ),
    );
  }
}
