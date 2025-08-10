import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/create_meeting_state.dart';
import '../providers.dart';

class InfoStep extends ConsumerWidget {
  const InfoStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(REDACTED_TOKEN);
    final ctrl = ref.read(REDACTED_TOKEN.notifier);
    final titleCtrl = TextEditingController(text: state.title);
    final descCtrl = TextEditingController(text: state.description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<MeetingType>(
          value: state.type,
          hint: const Text('Select meeting type'),
          onChanged: (t) => ctrl.setType(t!),
          items: MeetingType.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
              .toList(),
        ),
        const SizedBox(height: 12),
        TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
        const SizedBox(height: 8),
        TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ctrl.setInfo(title: titleCtrl.text, description: descCtrl.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}


