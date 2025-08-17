import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_providers.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsStreamProvider);
    final controller = ref.read(userSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Text('Failed to load settings'),
          data: (settings) {
            const options = [10, 15, 30];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Default snooze for reminders',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: options.map((m) {
                    final selected = m == settings.defaultSnoozeMinutes;
                    return ChoiceChip(
                      label: Text('$m min'),
                      selected: selected,
                      onSelected: (_) => controller.setDefaultSnooze(m),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text('Currently: ${settings.defaultSnoozeMinutes} min',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                const Text(
                    'Applies to Snooze on reminders. You can still adjust per reminder.'),
              ],
            );
          },
        ),
      ),
    );
  }
}
