import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_providers.dart';

class TodayAgenda extends ConsumerWidget {
  const TodayAgenda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agenda = ref.watch(mergedAgendaProvider);

    return agenda.when(
      loading: () => const _AgendaSkeleton(),
      error: (e, _) => Text('Couldn’t load agenda: $e'),
      data: (items) {
        if (items.isEmpty) {
          return _EmptyToday(
            onCreateMeeting: () => context.push('/meeting/create'),
            onAddReminder: () => context.push('/reminders/create'),
          );
        }
        return ListView.separated(
          key: const Key('agenda_list'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 16),
          itemBuilder: (context, i) {
            final a = items[i];
            final timeStr =
                TimeOfDay.fromDateTime(a.at.toLocal()).format(context);
            final isMeeting = a.meeting != null;
            final title = isMeeting ? (a.meeting!.title) : (a.reminder!.text);
            final icon = isMeeting
                ? Icons.event_available
                : Icons.notifications_active_outlined;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isMeeting) {
                  // use meeting id when available
                }
              },
              child: ListTile(
                key: Key('agenda_item_$i'),
                leading: CircleAvatar(child: Icon(icon)),
                title: Text(title),
                subtitle: Text(timeStr),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      },
    );
  }
}

class _AgendaSkeleton extends StatelessWidget {
  const _AgendaSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('agenda_skeleton'),
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 8),
                    Container(
                        height: 10,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  final VoidCallback onCreateMeeting;
  final VoidCallback onAddReminder;
  const _EmptyToday(
      {required this.onCreateMeeting, required this.onAddReminder});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      key: const Key('agenda_empty_state'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined),
          const Text('Nothing for today yet.'),
          FilledButton.icon(
            key: const Key('cta_create_meeting'),
            icon: const Icon(Icons.add_circle),
            label: const Text('Create meeting'),
            onPressed: onCreateMeeting,
          ),
          OutlinedButton(
              onPressed: onAddReminder, child: const Text('Add reminder')),
        ],
      ),
    );
  }
}
