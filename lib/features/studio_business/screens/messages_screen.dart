import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/studio_business_providers.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement this featuren
            },
          ),
        ],
      ),
      body: messagesAsync.when(
        data: (final messages) {
          if (messages.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (final context, final index) {
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
                    onSelected: (final value) {
                      _handleMessageAction(context, message['id'], value);
                    },
                    itemBuilder: (final context) => [
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
        error: (final error, final stack) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  void _handleMessageAction(
      final BuildContext context, final String messageId, final String action) {
    switch (action) {
      case 'reply':
        // TODO: Implement this featuren
        break;
      case 'forward':
        // TODO: Implement this featuren
        break;
      case 'delete':
        _showDeleteConfirmation(context, messageId);
        break;
    }
  }

  void _showDeleteConfirmation(
      final BuildContext context, final String messageId) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement this featurentext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
