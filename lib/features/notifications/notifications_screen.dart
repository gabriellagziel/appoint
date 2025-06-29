import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/notification_provider.dart';
import '../../models/notification_item.dart';

/// Basic screen that displays local mock notifications.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(localNotificationsProvider);
    final service = ref.read(localNotificationServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final NotificationItem item = notifications[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.body),
                  trailing: Text(item.timestamp.toIso8601String()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: service.clearNotifications,
        child: const Icon(Icons.clear),
      ),
    );
  }
}
