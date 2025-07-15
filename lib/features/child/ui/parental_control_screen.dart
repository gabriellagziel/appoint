import 'package:appoint/features/child/providers/child_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that allows parents to manage basic controls for their child.
class ParentalControlScreen extends ConsumerWidget {
  const ParentalControlScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final settings = ref.watch(childSettingsProvider);
    final notifier = ref.read(childSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parental Controls'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Allow Playtime'),
              value: settings.playtimeEnabled,
              onChanged: notifier.togglePlaytime,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: settings.notificationsEnabled,
              onChanged: notifier.toggleNotifications,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Content Filter'),
              value: settings.contentFilterEnabled,
              onChanged: notifier.toggleContentFilter,
            ),
          ],
        ),
      ),
    );
  }
}
