import 'package:appoint/features/messaging/models/message.dart';
import 'package:appoint/features/messaging/services/messaging_service.dart';
import 'package:appoint/features/messaging/widgets/message_bubble.dart';
import 'package:appoint/features/messaging/widgets/attachment_picker.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final chatAsync = ref.watch(chatProvider(widget.chatId));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));

    return Scaffold(
      appBar: _buildAppBar(chatAsync, l10n),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text('Failed to load messages'),
                    const SizedBox(height: 8),
                    Text(error.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(messagesProvider(widget.chatId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (messages) {
                _messages = messages;
                return _buildMessagesList(messages, l10n);
              },
            ),
          ),
          
          // Message input
          _buildMessageInput(l10n),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AsyncValue<Chat?> chatAsync, AppLocalizations l10n) {
    return AppBar(
      title: chatAsync.when(
        loading: () => const Text('Loading...'),
        error: (error, stack) => const Text('Chat'),
        data: (chat) {
          if (chat == null) return const Text('Chat');
          
          return Row(
            children: [
              if (chat.avatar != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(chat.avatar!),
                  radius: 16,
                )
              else
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                  radius: 16,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name ?? 'Chat',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (chat.lastMessage != null)
                      Text(
                        'Last message ${_formatTime(chat.lastMessage!.timestamp)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showChatOptions(),
        ),
      ],
    );
  }

  Widget _buildMessagesList(List<Message> messages, AppLocalizations l10n) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Start the conversation!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: MessageBubble(
            message: message,
            isMe: isMe,
            onTap: () => _onMessageTap(message),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _isSending ? null : _sendAttachment,
            color: Colors.grey[600],
          ),
          
          // Message input
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: l10n.typeMessage ?? 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send button
          IconButton(
            icon: _isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _isTyping ? Icons.send : Icons.mic,
                    color: _isTyping ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
            onPressed: _isSending ? null : (_isTyping ? _sendMessage : _startVoiceMessage),
          ),
        ],
      ),
    );
  }

  void _onMessageTap(Message message) {
    // Handle message tap (show options, reply, etc.)
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildMessageOptions(message),
    );
  }

  Widget _buildMessageOptions(Message message) {
    final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement reply functionality
            },
          ),
          if (isMe) ...[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(message);
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement copy functionality
            },
          ),
        ],
      ),
    );
  }

  void _deleteMessage(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final service = ref.read(messagingServiceProvider);
                await service.deleteMessage(message.id, widget.chatId);
              } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete message: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text('Mute Chat'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement mute functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive Chat'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement archive functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Chat', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete chat functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startVoiceMessage() {
    // TODO: Implement voice message functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice messages coming soon!')),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 