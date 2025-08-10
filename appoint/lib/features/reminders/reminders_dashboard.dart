import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class RemindersDashboard extends ConsumerWidget {
  const RemindersDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersStreamProvider);
    final svc = ref.read(reminderServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: reminders.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No reminders yet'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final r = items[i];
              final done = r['done'] == true;
              return ListTile(
                title: Text(r['text'] ?? ''),
                subtitle: Text(r['when']?.toDate().toString() ?? ''),
                trailing: Checkbox(
                  value: done,
                  onChanged: (v) => svc.toggleDone(r['id'], v ?? false),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/reminders/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}


