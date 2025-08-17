import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class VirtualUrlStep extends ConsumerWidget {
  const VirtualUrlStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMeetingFlowControllerProvider);
    final ctrl = ref.read(createMeetingFlowControllerProvider.notifier);
    final urlCtrl = TextEditingController(text: state.virtualUrl ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            controller: urlCtrl,
            decoration: const InputDecoration(
                labelText: 'Virtual meeting URL (Meet/Zoom)')),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => ctrl.setVirtualUrl(urlCtrl.text),
          child: const Text('Save URL'),
        ),
      ],
    );
  }
}
