import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/models/notification_settings.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/notification_provider.dart';
import 'package:appoint/providers/user_settings_provider.dart';
import 'package:appoint/providers/fcm_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tokenAsync = ref.watch(fcmTokenProvider);
    final settingsAsync = ref.watch(notificationSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettings)),
      body: settingsAsync.when(
        data: (settings) => tokenAsync.when(
            data: (token) => Padding(
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
                        final newSettings = NotificationSettings(push: v);
                        await ref
                            .read(userSettingsServiceProvider)
                            .updateSettings(uid, newSettings);
                      },
                    ),
                    if (token != null) SelectableText(l10n.fcmToken(token as Object)),
                  ],
                ),
              ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, final _) => Center(child: Text('Error: $e')),
          ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
