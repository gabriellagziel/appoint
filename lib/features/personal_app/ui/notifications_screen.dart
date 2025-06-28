import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/user_notifications_provider.dart';

/// Displays a list of notifications for the current user.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsAsync.when(
        data: (notifications) => ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final n = notifications[index];
            return ListTile(
              title: Text(n.title),
              subtitle: Text(n.body),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Failed to load notifications')),
      ),
    );
  }
}
