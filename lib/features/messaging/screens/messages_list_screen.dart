import 'package:appoint/features/messaging/models/message.dart';
// import 'package:appoint/features/messaging/services/messaging_service.dart'; // Unused
import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingServiceProvider =
    Provider<MessagingService>((ref) => MessagingService());

final userChatsProvider = StreamProvider<List<Chat>>((ref) {
  final service = ref.read(messagingServiceProvider);
  return service.getUserChats();
});

class MessagesListScreen extends ConsumerWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final chatsAsync = ref.watch(userChatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsDialog(context),
          ),
        ],
      ),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              const Text('Failed to load messages'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userChatsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (chats) => _buildChatsList(context, ref, chats, l10n),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewChat(context, ref),
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildChatsList(BuildContext context, WidgetRef ref, List<Chat> chats,
      AppLocalizations l10n) {
    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _startNewChat(context, ref),
              icon: const Icon(Icons.chat),
              label: const Text('New Message'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatTile(context, ref, chat);
      },
    );
  }

  Widget _buildChatTile(BuildContext context, WidgetRef ref, Chat chat) {
    final isUnread = chat.lastMessage != null && !chat.lastMessage!.isRead;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            chat.avatar != null ? NetworkImage(chat.avatar!) : null,
        backgroundColor: chat.avatar == null ? Colors.grey[300] : null,
        child: chat.avatar == null
            ? Icon(Icons.person, color: Colors.grey[600])
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.name ?? 'Chat',
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (chat.isMuted)
            Icon(Icons.volume_off, size: 16, color: Colors.grey[500]),
        ],
      ),
      subtitle: chat.lastMessage != null
          ? Text(
              chat.lastMessage!.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isUnread ? Colors.black87 : Colors.grey[600],
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
            )
          : Text(
              'No messages yet',
              style: TextStyle(color: Colors.grey[500]),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.updatedAt),
            style: TextStyle(
              fontSize: 12,
              color: isUnread ? Colors.blue : Colors.grey[500],
            ),
          ),
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () => _openChat(context, chat),
      onLongPress: () => _showChatOptions(context, chat),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  void _openChat(BuildContext context, Chat chat) {
    Navigator.pushNamed(context, '/chat/${chat.id}');
  }

  void _startNewChat(BuildContext context, WidgetRef ref) async {
    try {
      // Show dialog to select chat type
      final chatType = await showDialog<ChatType>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('New Chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Direct Message'),
                subtitle: const Text('Chat with a specific person'),
                onTap: () => Navigator.pop(context, ChatType.direct),
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Group Chat'),
                subtitle: const Text('Create a group conversation'),
                onTap: () => Navigator.pop(context, ChatType.group),
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Business Chat'),
                subtitle: const Text('Chat with a business'),
                onTap: () => Navigator.pop(context, ChatType.business),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      if (chatType != null) {
        final service = ref.read(messagingServiceProvider);

        // For now, create a demo chat
        final chatId = await service.createChat(
          participants: ['demo_user_1', 'demo_user_2'],
          type: chatType,
          name: 'New Chat',
        );

        if (context.mounted) {
          Navigator.pushNamed(context, '/chat/$chatId');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Messages'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search conversations...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (query) => _performSearch(context, query),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _performSearch(context, searchController.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _performSearch(BuildContext context, String query) {
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search term')),
      );
      return;
    }

    Navigator.pop(context);

    // Navigate to search results screen
    Navigator.pushNamed(
      context,
      '/messages/search',
      arguments: {'query': query},
    );
  }

  void _archiveAllChats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive All Chats'),
        content: const Text(
          'Are you sure you want to archive all chats? This action can be undone from settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual archive all functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All chats archived')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Archive All'),
          ),
        ],
      ),
    );
  }

  void _clearAllChats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Chats'),
        content: const Text(
          'Are you sure you want to clear all chats? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual clear all functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All chats cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _pinChat(BuildContext context, Chat chat) {
    // TODO: Implement actual pin functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat "${chat.name ?? 'Chat'}" pinned')),
    );
  }

  void _toggleMute(BuildContext context, Chat chat) {
    // TODO: Implement actual mute/unmute functionality
    final action = chat.isMuted ? 'unmuted' : 'muted';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat "${chat.name ?? 'Chat'}" $action')),
    );
  }

  void _archiveChat(BuildContext context, Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Chat'),
        content: Text(
          'Are you sure you want to archive "${chat.name ?? 'Chat'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual archive functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Chat "${chat.name ?? 'Chat'}" archived')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _deleteChat(BuildContext context, Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text(
          'Are you sure you want to delete "${chat.name ?? 'Chat'}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Chat "${chat.name ?? 'Chat'}" deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive All'),
              onTap: () {
                Navigator.pop(context);
                _archiveAllChats(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear All'),
              onTap: () {
                Navigator.pop(context);
                _clearAllChats(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Message Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings/messages');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context, Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pin),
              title: Text('Pin ${chat.name ?? 'Chat'}'),
              onTap: () {
                Navigator.pop(context);
                _pinChat(context, chat);
              },
            ),
            ListTile(
              leading: Icon(chat.isMuted ? Icons.volume_up : Icons.volume_off),
              title: Text(chat.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                Navigator.pop(context);
                _toggleMute(context, chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                _archiveChat(context, chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteChat(context, chat);
              },
            ),
          ],
        ),
      ),
    );
  }
}
