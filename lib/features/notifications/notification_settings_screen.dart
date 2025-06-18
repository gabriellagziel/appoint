import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

import '../../providers/notification_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tokenAsync = ref.watch(fcmTokenProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettings)),
      body: tokenAsync.when(
        data: (token) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(l10n.enableNotifications),
                  value: token != null,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 8),
                SelectableText(l10n.fcmToken(token ?? 'unavailable')),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.errorFetchingToken)),
      ),
    );
  }
}
