import 'package:appoint/providers/user_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/widgets/async_value_widget.dart';
import 'package:appoint/widgets/empty_state.dart';

/// Basic screen that displays user notifications.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: AsyncValueWidget(
        value: notificationsAsync,
        loading: const Center(child: CircularProgressIndicator()),
        empty: () => const EmptyState(
          title: 'No notifications',
          description: 'You have no notifications at the moment.',
        ),
        data: (notifications) => ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.body),
            );
          },
        ),
      ),
    );
  }
}
