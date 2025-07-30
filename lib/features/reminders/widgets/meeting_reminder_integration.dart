import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/reminder.dart';
import 'package:appoint/features/reminders/providers/reminder_providers.dart';
import 'package:appoint/features/reminders/screens/create_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetingReminderIntegration extends ConsumerStatefulWidget {
  const MeetingReminderIntegration({
    super.key,
    required this.meetingId,
    this.meetingTitle,
    this.meetingDateTime,
    this.meetingLocation,
    this.onRemindersChanged,
    this.expanded = false,
  });

  final String meetingId;
  final String? meetingTitle;
  final DateTime? meetingDateTime;
  final String? meetingLocation;
  final Function(List<Reminder>)? onRemindersChanged;
  final bool expanded;

  @override
  ConsumerState<MeetingReminderIntegration> createState() => REDACTED_TOKEN();
}

class REDACTED_TOKEN extends ConsumerState<MeetingReminderIntegration> {
  bool _isExpanded = false;
  List<Reminder> _meetingReminders = [];

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expanded;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final meetingReminders = ref.watch(userRemindersProvider(
      ReminderQueryParams(
        type: ReminderType.meetingRelated,
        activeOnly: true,
      ),
    ));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.alarm_add,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              l10n.meetingReminders,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: meetingReminders.whenOrNull(
              data: (reminders) {
                final count = reminders.where((r) => r.meetingId == widget.meetingId).length;
                return Text(count > 0 
                    ? l10n.reminderCount(count)
                    : l10n.noRemindersSet);
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: _addQuickReminder,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.quickAdd),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ),
              ],
            ),
          ),
          
          if (_isExpanded) ...[
            const Divider(height: 1),
            _buildExpandedContent(context, meetingReminders),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, AsyncValue<List<Reminder>> meetingRemindersAsync) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick reminder options
          Text(
            l10n.quickReminderOptions,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getQuickReminderOptions(l10n).map((option) => 
              ActionChip(
                avatar: Icon(option.icon, size: 16),
                label: Text(option.title),
                onPressed: () => _createQuickReminder(option),
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
            ).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Existing reminders for this meeting
          meetingRemindersAsync.when(
            data: (allReminders) {
              final meetingReminders = allReminders
                  .where((r) => r.meetingId == widget.meetingId)
                  .toList();
              
              if (meetingReminders.isEmpty) {
                return _buildEmptyState(context);
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.currentReminders,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  ...meetingReminders.map((reminder) => _buildReminderListItem(
                    context, 
                    reminder,
                  )),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Text(
              l10n.errorLoadingReminders,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Add custom reminder button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _createCustomReminder,
              icon: const Icon(Icons.add_alarm),
              label: Text(l10n.addCustomReminder),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.alarm_off,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noRemindersForMeeting,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.addReminderToStayOrganized,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderListItem(BuildContext context, Reminder reminder) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getReminderTypeColor(reminder.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getReminderTypeIcon(reminder.type),
            color: _getReminderTypeColor(reminder.type),
            size: 20,
          ),
        ),
        title: Text(
          reminder.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: reminder.triggerTime != null
            ? Text(_formatReminderTime(reminder.triggerTime!, l10n))
            : reminder.location != null
                ? Text(reminder.location!.name ?? reminder.location!.address)
                : null,
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit, size: 20),
                title: Text(l10n.edit),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: const Icon(Icons.delete, size: 20),
                title: Text(l10n.delete),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (action) => _handleReminderAction(action, reminder),
        ),
      ),
    );
  }

  List<QuickReminderOption> _getQuickReminderOptions(AppLocalizations l10n) {
    if (widget.meetingDateTime == null) {
      return [
        QuickReminderOption(
          title: l10n.fifteenMinutesBefore,
          icon: Icons.schedule,
          duration: const Duration(minutes: -15),
        ),
        QuickReminderOption(
          title: l10n.oneHourBefore,
          icon: Icons.schedule,
          duration: const Duration(hours: -1),
        ),
        QuickReminderOption(
          title: l10n.oneDayBefore,
          icon: Icons.calendar_today,
          duration: const Duration(days: -1),
        ),
      ];
    }

    return [
      QuickReminderOption(
        title: l10n.fifteenMinutesBefore,
        icon: Icons.schedule,
        triggerTime: widget.meetingDateTime!.subtract(const Duration(minutes: 15)),
      ),
      QuickReminderOption(
        title: l10n.oneHourBefore,
        icon: Icons.schedule,
        triggerTime: widget.meetingDateTime!.subtract(const Duration(hours: 1)),
      ),
      QuickReminderOption(
        title: l10n.oneDayBefore,
        icon: Icons.calendar_today,
        triggerTime: widget.meetingDateTime!.subtract(const Duration(days: 1)),
      ),
      QuickReminderOption(
        title: l10n.dayOfMeeting,
        icon: Icons.today,
        triggerTime: DateTime(
          widget.meetingDateTime!.year,
          widget.meetingDateTime!.month,
          widget.meetingDateTime!.day,
          9, // 9 AM on the day of meeting
        ),
      ),
    ];
  }

  void _addQuickReminder() {
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet<QuickReminderOption>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addQuickReminder,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._getQuickReminderOptions(l10n).map((option) => ListTile(
              leading: Icon(option.icon),
              title: Text(option.title),
              onTap: () {
                Navigator.of(context).pop(option);
              },
            )),
          ],
        ),
      ),
    ).then((option) {
      if (option != null) {
        _createQuickReminder(option);
      }
    });
  }

  void _createQuickReminder(QuickReminderOption option) {
    final l10n = AppLocalizations.of(context)!;
    
    ref.read(REDACTED_TOKEN.notifier).createReminder(
      title: '${widget.meetingTitle ?? l10n.meeting} - ${option.title}',
      description: l10n.automaticReminderForMeeting(widget.meetingTitle ?? l10n.meeting),
      type: ReminderType.meetingRelated,
      triggerTime: option.triggerTime,
      meetingId: widget.meetingId,
      priority: ReminderPriority.medium,
      notificationsEnabled: true,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.reminderAdded),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _createCustomReminder() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateReminderScreen(
          initialType: ReminderType.meetingRelated,
          meetingId: widget.meetingId,
        ),
      ),
    );
  }

  void _handleReminderAction(String action, Reminder reminder) {
    switch (action) {
      case 'edit':
        // Navigate to edit reminder screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateReminderScreen(
              initialType: reminder.type,
              meetingId: widget.meetingId,
            ),
          ),
        );
        break;
      case 'delete':
        _deleteReminder(reminder);
        break;
    }
  }

  void _deleteReminder(Reminder reminder) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteReminder),
        content: Text(l10n.deleteReminderConfirmation(reminder.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(reminderActionNotifierProvider.notifier).deleteReminder(reminder.id);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reminderDeleted),
          ),
        );
      }
    });
  }

  Color _getReminderTypeColor(ReminderType type) {
    switch (type) {
      case ReminderType.timeBased:
        return Colors.blue;
      case ReminderType.locationBased:
        return Colors.green;
      case ReminderType.meetingRelated:
        return Colors.purple;
      case ReminderType.personal:
        return Colors.orange;
    }
  }

  IconData _getReminderTypeIcon(ReminderType type) {
    switch (type) {
      case ReminderType.timeBased:
        return Icons.schedule;
      case ReminderType.locationBased:
        return Icons.location_on;
      case ReminderType.meetingRelated:
        return Icons.event;
      case ReminderType.personal:
        return Icons.person;
    }
  }

  String _formatReminderTime(DateTime time, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = time.difference(now);
    
    if (difference.isNegative) {
      return l10n.overdue;
    }
    
    if (difference.inDays > 0) {
      return l10n.inDays(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.inHours(difference.inHours);
    } else {
      return l10n.inMinutes(difference.inMinutes);
    }
  }
}

class QuickReminderOption {
  const QuickReminderOption({
    required this.title,
    required this.icon,
    this.triggerTime,
    this.duration,
  });

  final String title;
  final IconData icon;
  final DateTime? triggerTime;
  final Duration? duration;
}