import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/booking_draft_provider.dart';

/// A chat-driven booking flow widget.
class ChatFlowWidget extends ConsumerStatefulWidget {
  const ChatFlowWidget({final Key? key}) : super(key: key);

  @override
  ChatFlowWidgetState createState() => ChatFlowWidgetState();
}

class ChatFlowWidgetState extends ConsumerState<ChatFlowWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(final BuildContext context) {
    final messages = ref.watch(bookingDraftProvider).chatMessages;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Booking')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (final context, final index) {
                final msg = messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Card(
                      color: msg.isUser ? Colors.blue[100] : Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (final _) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;
    ref.read(bookingDraftProvider.notifier).addUserMessage(input);
    _controller.clear();
    // Scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
