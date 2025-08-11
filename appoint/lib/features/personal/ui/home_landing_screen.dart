import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeLandingScreen extends ConsumerWidget {
  const HomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi there 👋',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Quick actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/groups'),
                  icon: const Icon(Icons.group),
                  label: const Text('My Groups'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/create/meeting'),
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('New Meeting'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/reminders/create'),
                  icon: const Icon(Icons.alarm_add),
                  label: const Text('Set Reminder'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
