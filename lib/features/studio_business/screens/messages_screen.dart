import 'package:appoint/providers/studio_business_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO(username): Implement this featuren
            },
          ),
        ],
      ),
      body: messagesAsync.when(
        data: (messages) {
          if (messages.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, final index) {
              final message = messages[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(message['subject'] ?? 'No Subject'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From: ${message['senderName'] ?? 'Unknown'}'),
                      Text('Date: ${message['createdAt'] ?? 'Unknown'}'),
                      if (message['content'] != null)
                        Text(
                          message['content'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      _handleMessageAction(context, message['id'], value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'reply',
                        child: Text('Reply'),
                      ),
                      const PopupMenuItem(
                        value: 'forward',
                        child: Text('Forward'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  void _handleMessageAction(
      BuildContext context, final String messageId, final String action,) {
    switch (action) {
      case 'reply':
        // TODO(username): Implement this featuren
        break;
      case 'forward':
        // TODO(username): Implement this featuren
        break;
      case 'delete':
        _showDeleteConfirmation(context, messageId);
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, final String messageId,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO(username): Implement this featurentext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
