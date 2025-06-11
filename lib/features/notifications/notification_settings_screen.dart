import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/notification_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(fcmTokenProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: tokenAsync.when(
        data: (token) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: token != null,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 8),
                SelectableText('FCM Token: ${token ?? 'unavailable'}'),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error fetching token')),
      ),
    );
  }
}
