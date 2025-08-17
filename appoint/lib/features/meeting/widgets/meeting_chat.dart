import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';
import '../../../services/auth/auth_providers.dart';

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
    final userId = ref.watch(currentUserIdProvider);

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
                Expanded(
                    child: TextField(
                        controller: _c,
                        decoration:
                            const InputDecoration(hintText: 'Message...'))),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: (userId == null || _c.text.trim().isEmpty)
                      ? null
                      : () {
                          final t = _c.text.trim();
                          ref
                              .read(meetingControllerProvider(widget.meetingId)
                                  .notifier)
                              .sendMessage(userId, t);
                          _c.clear();
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
