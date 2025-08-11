import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers.dart';

class RemindersDashboard extends ConsumerWidget {
  const RemindersDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersStreamProvider);
    final form = ref.read(reminderFormProvider.notifier);

    Widget _badge(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(text),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: reminders.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No reminders yet'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => context.push('/reminders/create'),
                    child: const Text('Create a Reminder'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final r = items[i];
              final done = r['done'] == true;
              DateTime? when;
              final rawWhen = r['when'];
              try {
                if (rawWhen is DateTime) {
                  when = rawWhen;
                } else if (rawWhen != null && rawWhen.toString().isNotEmpty) {
                  // Firestore Timestamp has toDate(); guard reflectively
                  final dyn = rawWhen;
                  if (dyn is dynamic && (dyn as dynamic).toDate != null) {
                    when = (dyn as dynamic).toDate();
                  }
                }
              } catch (_) {
                when = null;
              }
              return ListTile(
                title: Text(r['text'] ?? ''),
                subtitle: Text(when?.toLocal().toString() ?? 'No time set'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((r['recurrence']?.toString() ?? 'none') != 'none')
                      _badge(r['recurrence'].toString()),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: done,
                      onChanged: (v) => form.markDone(r, v ?? false),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          debugPrint('Reminders error: $e\n$st');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Couldn't load reminders."),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.refresh(remindersStreamProvider),
                child: const Text('Retry'),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/reminders/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
