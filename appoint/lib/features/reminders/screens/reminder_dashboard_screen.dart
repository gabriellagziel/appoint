import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/reminder_controller.dart';
import '../models/reminder_model.dart';
import 'create_reminder_screen.dart';

class ReminderDashboardScreen extends ConsumerStatefulWidget {
  const ReminderDashboardScreen({super.key});

  @override
  ConsumerState<ReminderDashboardScreen> createState() =>
      _ReminderDashboardScreenState();
}

class _ReminderDashboardScreenState
    extends ConsumerState<ReminderDashboardScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    // Load reminders when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reminderControllerProvider.notifier).loadReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(reminderControllerProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);
    final upcomingReminders = ref.watch(upcomingRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateReminderScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip('all', 'All', reminders.length),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      _buildFilterChip('today', 'Today', todayReminders.length),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip(
                      'overdue', 'Overdue', overdueReminders.length),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip(
                      'upcoming', 'Upcoming', upcomingReminders.length),
                ),
              ],
            ),
          ),

          // Reminders List
          Expanded(
            child: _buildRemindersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label, int count) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
      },
    );
  }

  Widget _buildRemindersList() {
    final reminders = ref.watch(reminderControllerProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);
    final upcomingReminders = ref.watch(upcomingRemindersProvider);

    List<Reminder> filteredReminders;
    switch (_selectedFilter) {
      case 'today':
        filteredReminders = todayReminders;
        break;
      case 'overdue':
        filteredReminders = overdueReminders;
        break;
      case 'upcoming':
        filteredReminders = upcomingReminders;
        break;
      default:
        filteredReminders = reminders;
    }

    if (filteredReminders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReminders.length,
      itemBuilder: (context, index) {
        final reminder = filteredReminders[index];
        return _buildReminderCard(reminder);
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_selectedFilter) {
      case 'today':
        message = 'No reminders for today';
        icon = Icons.today;
        break;
      case 'overdue':
        message = 'No overdue reminders';
        icon = Icons.schedule;
        break;
      case 'upcoming':
        message = 'No upcoming reminders';
        icon = Icons.upcoming;
        break;
      default:
        message = 'No reminders yet';
        icon = Icons.note_add;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first reminder to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateReminderScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Reminder'),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: reminder.priority.color.withValues(alpha: 0.1),
          child: Icon(
            reminder.priority.icon,
            color: reminder.priority.color,
          ),
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            decoration: reminder.status == ReminderStatus.completed
                ? TextDecoration.lineThrough
                : null,
            fontWeight: reminder.status == ReminderStatus.completed
                ? FontWeight.normal
                : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description != null) ...[
              Text(
                reminder.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: reminder.isOverdue ? Colors.red : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  reminder.formattedDueDate,
                  style: TextStyle(
                    color: reminder.isOverdue ? Colors.red : Colors.grey[600],
                    fontWeight: reminder.isOverdue
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (reminder.assignedTo != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Assigned to ${reminder.assignedTo}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ],
            ),
            if (reminder.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: reminder.tags
                    .map((tag) => Chip(
                          label:
                              Text(tag, style: const TextStyle(fontSize: 10)),
                          backgroundColor: Colors.grey[200],
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleReminderAction(value, reminder),
          itemBuilder: (context) => [
            if (reminder.status != ReminderStatus.completed)
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
        onTap: () {
          // Show reminder details
          _showReminderDetails(reminder);
        },
      ),
    );
  }

  void _handleReminderAction(String action, Reminder reminder) {
    final controller = ref.read(reminderControllerProvider.notifier);

    switch (action) {
      case 'complete':
        controller.markComplete(reminder.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder marked as complete'),
            backgroundColor: Colors.green,
          ),
        );
        break;
      case 'edit':
        // TODO: Navigate to edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality coming soon')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(reminder);
        break;
    }
  }

  void _showDeleteConfirmation(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: Text('Are you sure you want to delete "${reminder.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(reminderControllerProvider.notifier)
                  .deleteReminder(reminder.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reminder deleted'),
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

  void _showReminderDetails(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reminder.description != null) ...[
              Text(reminder.description!),
              const SizedBox(height: 16),
            ],
            _buildDetailRow('Due Date', reminder.formattedDueDate),
            _buildDetailRow('Priority', _getPriorityLabel(reminder.priority)),
            _buildDetailRow('Status', _getStatusLabel(reminder.status)),
            if (reminder.recurrence != ReminderRecurrence.none)
              _buildDetailRow(
                  'Recurrence', _getRecurrenceLabel(reminder.recurrence)),
            if (reminder.assignedTo != null)
              _buildDetailRow('Assigned To', reminder.assignedTo!),
            if (reminder.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Tags:', style: Theme.of(context).textTheme.titleSmall),
              Wrap(
                spacing: 4,
                children: reminder.tags
                    .map((tag) => Chip(
                          label:
                              Text(tag, style: const TextStyle(fontSize: 10)),
                          backgroundColor: Colors.grey[200],
                        ))
                    .toList(),
              ),
            ],
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

  String _getPriorityLabel(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.low:
        return 'Low';
      case ReminderPriority.medium:
        return 'Medium';
      case ReminderPriority.high:
        return 'High';
      case ReminderPriority.urgent:
        return 'Urgent';
    }
  }

  String _getStatusLabel(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.pending:
        return 'Pending';
      case ReminderStatus.completed:
        return 'Completed';
      case ReminderStatus.overdue:
        return 'Overdue';
      case ReminderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getRecurrenceLabel(ReminderRecurrence recurrence) {
    switch (recurrence) {
      case ReminderRecurrence.none:
        return 'None';
      case ReminderRecurrence.daily:
        return 'Daily';
      case ReminderRecurrence.weekly:
        return 'Weekly';
      case ReminderRecurrence.monthly:
        return 'Monthly';
      case ReminderRecurrence.custom:
        return 'Custom';
    }
  }
}
