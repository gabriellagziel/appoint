import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

import '../../providers/notification_provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/notification_settings.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tokenAsync = ref.watch(fcmTokenProvider);
    final settingsAsync = ref.watch(notificationSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettings)),
      body: settingsAsync.when(
        data: (settings) {
          return tokenAsync.when(
            data: (token) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text(l10n.enableNotifications),
                      value: settings.push,
                      onChanged: (v) async {
                        final uid = ref.read(authProvider).currentUser?.uid;
                        if (uid == null) return;
                        final newSettings =
                            NotificationSettings(push: v, email: settings.email);
                        await ref
                            .read(userSettingsServiceProvider)
                            .updateSettings(uid, newSettings);
                        if (v) {
                          await ref
                              .read(notificationServiceProvider)
                              .saveTokenForUser(uid);
                        }
                        ref.invalidate(notificationSettingsProvider);
                      },
                    ),
                    SwitchListTile(
                      title: Text('Email Notifications'),
                      value: settings.email,
                      onChanged: (v) async {
                        final uid = ref.read(authProvider).currentUser?.uid;
                        if (uid == null) return;
                        final newSettings =
                            NotificationSettings(push: settings.push, email: v);
                        await ref
                            .read(userSettingsServiceProvider)
                            .updateSettings(uid, newSettings);
                        ref.invalidate(notificationSettingsProvider);
                      },
                    ),
                    const SizedBox(height: 8),
                    SelectableText(l10n.fcmToken(token ?? 'unavailable')),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text(l10n.errorFetchingToken)),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error')), 
      ),
    );
  }
}
