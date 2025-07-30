import 'package:appoint/providers/user_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Basic screen that displays user notifications.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsAsync.when(
        data: (notifications) => notifications.isEmpty
            ? const Center(child: Text('No notifications'))
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, final index) {
                  final item = notifications[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.body),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
