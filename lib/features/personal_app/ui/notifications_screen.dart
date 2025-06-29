import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/user_notifications_provider.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/loading_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/empty_state.dart';

/// Displays a list of notifications for the current user.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return AppScaffold(
      title: 'Notifications',
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState(
              title: 'No Notifications',
              description: 'You are all caught up',
              icon: Icons.notifications_none,
            );
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                title: Text(n.title),
                subtitle: Text(n.body),
              );
            },
          );
        },
        loading: () => const LoadingState(),
        error: (_, __) => const ErrorState(
          title: 'Error',
          description: 'Failed to load notifications',
        ),
      ),
    );
  }
}
