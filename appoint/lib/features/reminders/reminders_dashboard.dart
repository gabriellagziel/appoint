import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers.dart';
import 'services/reminder_service.dart';
import 'package:intl/intl.dart';
import '../settings/providers/settings_providers.dart';
import '../../services/analytics_service.dart';

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
          // Fire and forget: dashboard opened
          // ignore: discarded_futures
          // For web, just call without awaiting.
          // We avoid unawaited import; ignore the future explicitly.
          // ignore: unused_result
          Analytics.log('reminder_list_opened');
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
                  // Firestore Timestamp via dynamic; call toDate if present
                  final dyn = rawWhen;
                  try {
                    // ignore: avoid_dynamic_calls
                    when = (dyn as dynamic).toDate();
                  } catch (_) {
                    when = null;
                  }
                }
              } catch (_) {
                when = null;
              }
              final recurrence = (r['recurrence']?.toString() ?? 'none');
              final next = ReminderService.nextOccurrence(when, recurrence);
              final subtitleParts = <String>[];
              if (when != null) {
                subtitleParts.add(DateFormat.yMMMd().add_Hm().format(when));
              }
              if (recurrence != 'none' && next != null) {
                subtitleParts.add(
                    '• Repeats $recurrence — next ${DateFormat.E().add_Hm().format(next)}');
              }
              final settingsAsync = ref.watch(userSettingsStreamProvider);
              final snoozeTooltip = settingsAsync.maybeWhen(
                data: (s) => 'Snooze ${s.defaultSnoozeMinutes}m',
                orElse: () => 'Snooze 15m',
              );

              return ListTile(
                title: Text(r['text'] ?? ''),
                subtitle: Text(subtitleParts.isEmpty
                    ? 'No time set'
                    : subtitleParts.join(' ')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (recurrence != 'none') _badge(recurrence),
                    PopupMenuButton<int>(
                      tooltip: 'More',
                      onSelected: (m) =>
                          form.snooze(r, by: Duration(minutes: m)),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 5, child: Text('Snooze 5m')),
                        PopupMenuItem(value: 10, child: Text('Snooze 10m')),
                        PopupMenuItem(value: 15, child: Text('Snooze 15m')),
                        PopupMenuItem(value: 30, child: Text('Snooze 30m')),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                    IconButton(
                      tooltip: snoozeTooltip,
                      onPressed: () => form.snooze(r),
                      icon: const Icon(Icons.snooze),
                    ),
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
