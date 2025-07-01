import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/l10n/app_localizations.dart';

import 'package:appoint/providers/notification_provider.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (final context, final index) {
          final n = notifications[index];
          return ListTile(
            title: Text(n.title),
            subtitle: Text(n.body),
          );
        },
      ),
    );
  }
}
