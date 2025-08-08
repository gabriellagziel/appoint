import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';

class MeetingChecklist extends ConsumerWidget {
  final String meetingId;
  final Map<String, dynamic> meeting;
  const MeetingChecklist({super.key, required this.meetingId, required this.meeting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = (meeting['checklist'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    if (items.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Column(
        children: items.map((i) {
          final id = i['id']?.toString() ?? '';
          final label = i['label']?.toString() ?? id;
          final done = i['done'] == true;
          return CheckboxListTile(
            title: Text(label),
            value: done,
            onChanged: (v) => ref.read(meetingControllerProvider(meetingId).notifier).toggleChecklistItem(id, v ?? false),
          );
        }).toList(),
      ),
    );
  }
}
