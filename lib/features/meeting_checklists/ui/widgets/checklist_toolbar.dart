import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_checklist.dart';
import 'package:appoint/features/meeting_checklists/providers/meeting_checklist_providers.dart';

class ChecklistToolbar extends ConsumerWidget {
  final String meetingId;
  final String listId;

  const ChecklistToolbar({
    super.key,
    required this.meetingId,
    required this.listId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(checklistItemsProvider((
      meetingId: meetingId,
      listId: listId,
    )));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: itemsAsync.when(
        data: (items) {
          final doneItems = items.where((item) => item.isDone).length;
          final totalItems = items.length;
          final overdueItems = items.where((item) => item.isOverdue).length;
          final highPriorityItems = items
              .where((item) => item.priority == ChecklistItemPriority.high)
              .length;

          return Row(
            children: [
              // Stats
              Expanded(
                child: Row(
                  children: [
                    _buildStatChip(context, 'Done', '$doneItems/$totalItems',
                        Colors.green),
                    const SizedBox(width: 8),
                    if (overdueItems > 0)
                      _buildStatChip(
                          context, 'Overdue', '$overdueItems', Colors.red),
                    if (highPriorityItems > 0) ...[
                      const SizedBox(width: 8),
                      _buildStatChip(context, 'High Priority',
                          '$highPriorityItems', Colors.orange),
                    ],
                  ],
                ),
              ),

              // Actions
              if (totalItems > 0) ...[
                TextButton.icon(
                  onPressed: () => _markAllDone(context, ref, items),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Mark All Done'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _clearDone(context, ref, items),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Done'),
                ),
              ],
            ],
          );
        },
        loading: () => const SizedBox(height: 48),
        error: (_, __) => const SizedBox(height: 48),
      ),
    );
  }

  Widget _buildStatChip(
      BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markAllDone(
      BuildContext context, WidgetRef ref, List<ChecklistItem> items) async {
    final undoneItems = items.where((item) => !item.isDone).toList();

    if (undoneItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All items are already done')),
      );
      return;
    }

    try {
      for (final item in undoneItems) {
        await ref.read(toggleItemDoneProvider.notifier).toggleItemDone(
              meetingId,
              listId,
              item.id,
              true,
            );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marked ${undoneItems.length} items as done')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark items as done: $e')),
        );
      }
    }
  }

  Future<void> _clearDone(
      BuildContext context, WidgetRef ref, List<ChecklistItem> items) async {
    final doneItems = items.where((item) => item.isDone).toList();

    if (doneItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No done items to clear')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Done Items'),
        content: Text(
            'Are you sure you want to clear ${doneItems.length} done items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        for (final item in doneItems) {
          await ref.read(deleteItemProvider.notifier).deleteItem(
                meetingId,
                listId,
                item.id,
              );
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cleared ${doneItems.length} done items')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear done items: $e')),
          );
        }
      }
    }
  }
}
