import 'package:appoint/features/messaging/models/message.dart';
import 'package:appoint/features/messaging/models/chat.dart';
import 'package:appoint/features/messaging/services/messaging_service.dart';
import 'package:appoint/features/messaging/widgets/message_bubble.dart';
import 'package:appoint/features/messaging/widgets/attachment_picker.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

final messagingServiceProvider = Provider<MessagingService>((ref) => MessagingService());

final messagesProvider = StreamProvider.family<List<Message>, String>(
  (ref, chatId) {
    final service = ref.read(messagingServiceProvider);
    return service.getMessages(chatId);
  },
);

final chatProvider = StreamProvider.family<Chat?, String>(
  (ref, chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return Chat.fromJson({...doc.data()!, 'id': doc.id});
    });
  },
);

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
    this.initialChat,
  });

  final String chatId;
  final Chat? initialChat;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isTyping = false;
  bool _isSending = false;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    setState(() {
      _isTyping = _messageController.text.isNotEmpty;
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    try {
      final service = ref.read(messagingServiceProvider);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final message = Message(
        id: '',
        senderId: user.uid,
        chatId: widget.chatId,
        content: _messageController.text.trim(),
        type: MessageType.text,
        timestamp: DateTime.now(),
      );

      await service.sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _sendAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        await _uploadAndSendAttachment(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  Future<void> _uploadAndSendAttachment(File file) async {
    setState(() {
      _isSending = true;
    });

    try {
      final service = ref.read(messagingServiceProvider);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Upload attachment
      final attachment = await service.uploadAttachment(file, widget.chatId);

      // Create message with attachment
      final message = Message(
        id: '',
        senderId: user.uid,
        chatId: widget.chatId,
        content: 'Sent ${attachment.name}',
        type: _getMessageType(attachment.type),
        timestamp: DateTime.now(),
        attachments: [attachment],
      );

      await service.sendMessage(message);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send attachment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  MessageType _getMessageType(AttachmentType attachmentType) {
    switch (attachmentType) {
      case AttachmentType.image:
        return MessageType.image;
      case AttachmentType.video:
        return MessageType.video;
      case AttachmentType.audio:
        return MessageType.audio;
      case AttachmentType.document:
      case AttachmentType.location:
        return MessageType.file;
    }
  }

  void _scrollToBottom() {
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
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.chatId));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        title: chatAsync.when(
          data: (chat) => Text(chat?.name ?? 'Chat'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Chat'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(messagesProvider(widget.chatId)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                _messages = messages;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message,
                      isMe: message.senderId == FirebaseAuth.instance.currentUser?.uid,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _isSending ? null : _sendAttachment,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _isSending ? null : (_isTyping ? _sendMessage : _startVoiceMessage),
            child: Icon(
              _isTyping ? Icons.send : Icons.mic,
              color: _isTyping ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _startVoiceMessage() {
    // TODO: Implement voice message recording
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice messages coming soon!')),
    );
  }
} 