import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';

class MeetingChecklist extends ConsumerWidget {
  final String meetingId;
  final Map<String, dynamic> meeting;
  const MeetingChecklist(
      {super.key, required this.meetingId, required this.meeting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        (meeting['checklist'] as List?)?.cast<Map<String, dynamic>>() ??
            const [];

    return Card(
      child: Column(
        children: [
          if (items.isNotEmpty)
            ...items.map((i) {
              final id = i['id']?.toString() ?? '';
              final label = i['label']?.toString() ?? id;
              final done = i['done'] == true;
              return CheckboxListTile(
                title: Text(label),
                value: done,
                onChanged: (v) => ref
                    .read(meetingControllerProvider(meetingId).notifier)
                    .toggleChecklistItem(id, v ?? false),
                secondary: IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () => ref
                      .read(meetingControllerProvider(meetingId).notifier)
                      .removeChecklistItem(id),
                ),
              );
            }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Add checklist item...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        ref
                            .read(meetingControllerProvider(meetingId).notifier)
                            .addChecklistItem(text.trim());
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Checklist Item'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter item text...',
                          ),
                          autofocus: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.text.trim().isNotEmpty) {
                                ref
                                    .read(meetingControllerProvider(meetingId)
                                        .notifier)
                                    .addChecklistItem(controller.text.trim());
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







