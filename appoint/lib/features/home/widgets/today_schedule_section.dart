import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/reminders/controllers/reminder_controller.dart';

class TodayScheduleSection extends ConsumerWidget {
  const TodayScheduleSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayReminders = ref.watch(todayRemindersProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);

    // TODO: Get today's meetings from meeting controller
    final todayMeetings = <dynamic>[]; // Placeholder for meetings

    final allItems = <_ScheduleItem>[];

    // Add overdue reminders first
    for (final reminder in overdueReminders) {
      allItems.add(_ScheduleItem(
        id: reminder.id,
        title: reminder.title,
        description: reminder.description,
        time: reminder.dueDate,
        type: _ItemType.reminder,
        priority: reminder.priority,
        isOverdue: true,
      ));
    }

    // Add today's reminders
    for (final reminder in todayReminders) {
      allItems.add(_ScheduleItem(
        id: reminder.id,
        title: reminder.title,
        description: reminder.description,
        time: reminder.dueDate,
        type: _ItemType.reminder,
        priority: reminder.priority,
        isOverdue: false,
      ));
    }

    // Add today's meetings
    for (final meeting in todayMeetings) {
      allItems.add(_ScheduleItem(
        id: meeting.id,
        title: meeting.title,
        description: meeting.description,
        time: meeting.startTime,
        type: _ItemType.meeting,
        priority: null,
        isOverdue: false,
      ));
    }

    // Sort by time
    allItems.sort((a, b) => a.time.compareTo(b.time));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Schedule',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${allItems.length} items',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (allItems.isEmpty)
          _buildEmptyState(context)
        else
          _buildScheduleList(context, allItems),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.schedule,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No items scheduled for today',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a meeting or reminder to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context, List<_ScheduleItem> items) {
    return Column(
      children: items.map((item) => _buildScheduleItem(context, item)).toList(),
    );
  }

  Widget _buildScheduleItem(BuildContext context, _ScheduleItem item) {
    final isReminder = item.type == _ItemType.reminder;
    final icon = isReminder ? Icons.notifications : Icons.meeting_room;
    final color = isReminder
        ? (item.isOverdue ? Colors.red : Colors.orange)
        : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: item.isOverdue ? FontWeight.w600 : FontWeight.normal,
            color: item.isOverdue ? Colors.red : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description != null) ...[
              Text(
                item.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: item.isOverdue ? Colors.red : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(item.time),
                  style: TextStyle(
                    color: item.isOverdue ? Colors.red : Colors.grey[600],
                    fontWeight:
                        item.isOverdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (isReminder && item.priority != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    item.priority!.icon,
                    size: 14,
                    color: item.priority!.color,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleItemAction(context, value, item),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            if (isReminder) ...[
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.check),
                    SizedBox(width: 8),
                    Text('Mark Complete'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
            ],
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showItemDetails(context, item),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }

  void _handleItemAction(
      BuildContext context, String action, _ScheduleItem item) {
    switch (action) {
      case 'view':
        _showItemDetails(context, item);
        break;
      case 'complete':
        if (item.type == _ItemType.reminder) {
          // TODO: Mark reminder as complete
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reminder marked as complete'),
              backgroundColor: Colors.green,
            ),
          );
        }
        break;
      case 'edit':
        // TODO: Navigate to edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality coming soon')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, item);
        break;
    }
  }

  void _showItemDetails(BuildContext context, _ScheduleItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.description != null) ...[
              Text(item.description!),
              const SizedBox(height: 16),
            ],
            _buildDetailRow('Time', _formatTime(item.time)),
            _buildDetailRow('Type',
                item.type == _ItemType.reminder ? 'Reminder' : 'Meeting'),
            if (item.isOverdue) _buildDetailRow('Status', 'Overdue'),
            if (item.priority != null)
              _buildDetailRow('Priority', item.priority!.name),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, _ScheduleItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Delete item
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.title} deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

enum _ItemType { meeting, reminder }

class _ScheduleItem {
  final String id;
  final String title;
  final String? description;
  final DateTime time;
  final _ItemType type;
  final dynamic priority; // ReminderPriority for reminders, null for meetings
  final bool isOverdue;

  _ScheduleItem({
    required this.id,
    required this.title,
    this.description,
    required this.time,
    required this.type,
    this.priority,
    required this.isOverdue,
  });
}



