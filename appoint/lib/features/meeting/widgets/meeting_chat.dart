import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';

class MeetingChat extends ConsumerStatefulWidget {
  final String meetingId;
  const MeetingChat({super.key, required this.meetingId});

  @override
  ConsumerState<MeetingChat> createState() => _MeetingChatState();
}

class _MeetingChatState extends ConsumerState<MeetingChat> {
  final _c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(meetingControllerProvider(widget.meetingId));
    // TODO: get userId from auth provider
    const userId = 'CURRENT_USER_ID';

    return Card(
      child: Column(
        children: [
          ListView.builder(
            itemCount: state.chat.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              final msg = state.chat[i];
              return ListTile(
                title: Text(msg['text'] ?? ''),
                subtitle: Text(msg['senderId'] ?? ''),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _c, decoration: const InputDecoration(hintText: 'Message...'))),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final t = _c.text.trim();
                    if (t.isNotEmpty) {
                      ref.read(meetingControllerProvider(widget.meetingId).notifier).sendMessage(userId, t);
                      _c.clear();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
