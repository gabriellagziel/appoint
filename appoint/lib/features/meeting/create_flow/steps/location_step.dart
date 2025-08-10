import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class LocationStep extends ConsumerWidget {
  const LocationStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMeetingFlowControllerProvider);
    final ctrl = ref.read(createMeetingFlowControllerProvider.notifier);
    final addrCtrl = TextEditingController(text: state.locationAddress ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'Address (free text)')),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => ctrl.setLocation(address: addrCtrl.text),
          child: const Text('Save location'),
        ),
      ],
    );
  }
}


