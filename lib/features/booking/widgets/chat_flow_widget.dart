import 'package:appoint/models/playtime_chat.dart';
import 'package:appoint/providers/booking_draft_provider.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A chat-driven booking flow widget with typing indicators and read receipts.
class ChatFlowWidget extends ConsumerStatefulWidget {

  const ChatFlowWidget({
    required this.auth, super.key,
  });
  /// [auth] is injected for testability.
  final AuthService auth;

  @override
  ChatFlowWidgetState createState() => ChatFlowWidgetState(auth);
}

class ChatFlowWidgetState extends ConsumerState<ChatFlowWidget> {

  ChatFlowWidgetState(this._auth);
  // Injected instead of direct FirebaseAuth.instance
  final AuthService _auth;

  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  static const int maxMessageLength = 500;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final messages = draft.chatMessages;
    final isOtherUserTyping = draft.isOtherUserTyping;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Booking')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<User?>(
              future: _auth.currentUser(),
              builder: (context, snapshot) {
                final currentUser = snapshot.data;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length + (isOtherUserTyping ? 1 : 0),
                  itemBuilder: (context, final index) {
                    if (index == messages.length && isOtherUserTyping) {
                      return _buildTypingIndicator();
                    }

                    final msg = messages[index];
                    final isUser = currentUser?.uid == msg.senderId;

                    // Mark message as read if it's from another user and not already read
                    if (!isUser &&
                        currentUser?.uid != null &&
                        !msg.readBy.contains(currentUser!.uid)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref
                            .read(bookingDraftProvider.notifier)
                            .markMessageAsRead(msg.id);
                      });
                    }

                    return _buildMessageBubble(msg, isUser, currentUser?.uid);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() => Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Typing',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTypingDots(),
              ],
            ),
          ),
        ),
      ),
    );

  Widget _buildTypingDots() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600 + (i * 200)),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );

  Widget _buildMessageBubble(
      ChatMessage msg, bool isUser, String? currentUserId,) {
    final hasBeenRead =
        currentUserId != null && msg.readBy.contains(currentUserId);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Stack(
          children: [
            Card(
              color: isUser ? Colors.blue[100] : Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  msg.content,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87),
                ),
              ),
            ),
            if (isUser && hasBeenRead)
              Positioned(
                bottom: 4,
                right: 4,
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.green[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    final currentLength = _controller.text.length;
    final isOverLimit = currentLength > maxMessageLength;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: 'Message input field',
                  hint: 'Type your message here',
                  child: TextField(
                    controller: _controller,
                    maxLength: maxMessageLength,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: const OutlineInputBorder(),
                      errorText: isOverLimit ? 'Message too long' : null,
                      counterText: '$currentLength/$maxMessageLength',
                    ),
                    onChanged: (value) {
                      setState(() {}); // Rebuild to update counter
                    },
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                label: 'Send message',
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      currentLength > 0 && !isOverLimit ? _sendMessage : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isEmpty || input.length > maxMessageLength) return;

    ref.read(bookingDraftProvider.notifier).addUserMessage(input);
    _controller.clear();

    // Scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
