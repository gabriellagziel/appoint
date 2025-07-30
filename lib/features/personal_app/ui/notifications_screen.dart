import 'package:appoint/providers/user_notifications_provider.dart';
import 'package:appoint/widgets/app_scaffold.dart';
import 'package:appoint/widgets/empty_state.dart';
import 'package:appoint/widgets/error_state.dart';
import 'package:appoint/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays a list of notifications for the current user.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
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
            itemBuilder: (context, final index) {
              final n = notifications[index];
              return ListTile(
                title: Text(n.title),
                subtitle: Text(n.body),
              );
            },
          );
        },
        loading: () => const LoadingState(),
        error: (_, final __) => const ErrorState(
          title: 'Error',
          description: 'Failed to load notifications',
        ),
      ),
    );
  }
}
