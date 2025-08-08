import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';

class MeetingActionsBar extends ConsumerWidget {
  final String meetingId;
  const MeetingActionsBar({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: get userId from auth provider
    const userId = 'CURRENT_USER_ID';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(spacing: 8, children: [
          ElevatedButton(onPressed: () => ref.read(meetingControllerProvider(meetingId).notifier).rsvp(userId, 'accepted'), child: const Text('Accept')),
          OutlinedButton(onPressed: () => ref.read(meetingControllerProvider(meetingId).notifier).rsvp(userId, 'declined'), child: const Text('Decline')),
          TextButton(onPressed: () => ref.read(meetingControllerProvider(meetingId).notifier).markArrived(userId, true), child: const Text("I've Arrived")),
          TextButton(
            onPressed: () async {
              final reason = await showDialog<String>(context: context, builder: (_) {
                String v = '';
                return AlertDialog(
                  title: const Text("I'm late"),
                  content: TextField(onChanged: (t)=> v = t, decoration: const InputDecoration(hintText: 'Optional reason')),
                  actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancel')),
                    ElevatedButton(onPressed: ()=> Navigator.pop(context, v), child: const Text('Send'))],
                );
              });
              if (reason != null) {
                // naive: store reason via chat system
                await ref.read(meetingControllerProvider(meetingId).notifier).sendMessage(userId, "I'm late${reason.isNotEmpty ? ': $reason' : ''}");
              }
            },
            child: const Text("I'm Late"),
          ),
        ]),
      ),
    );
  }
}
