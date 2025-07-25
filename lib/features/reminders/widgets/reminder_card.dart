import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    this.onTap,
    this.onComplete,
    this.onSnooze,
    this.onDelete,
    this.showActions = true,
  });

  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onSnooze;
  final VoidCallback? onDelete;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isOverdue = _isOverdue;
    final timeUntil = _timeUntilTrigger;

    return Dismissible(
      key: Key(reminder.id),
      background: _buildSwipeBackground(context, isLeading: true),
      secondaryBackground: _buildSwipeBackground(context, isLeading: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onComplete?.call();
        } else {
          onDelete?.call();
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: reminder.status == ReminderStatus.snoozed ? 1 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isOverdue 
                ? Colors.red.withOpacity(0.3)
                : _getTypeColor(reminder.type).withOpacity(0.2),
            width: isOverdue ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with type icon and priority
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(reminder.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(reminder.type),
                        color: _getTypeColor(reminder.type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isOverdue ? Colors.red[700] : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (reminder.description.isNotEmpty)
                            Text(
                              reminder.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (reminder.priority != null)
                      _buildPriorityBadge(reminder.priority!, context),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Time and location info
                Row(
                  children: [
                    if (reminder.triggerTime != null) ...[
                      Icon(
                        isOverdue ? Icons.warning : Icons.schedule,
                        size: 16,
                        color: isOverdue 
                            ? Colors.red 
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatTriggerTime(reminder.triggerTime!, l10n),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOverdue 
                                ? Colors.red 
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isOverdue ? FontWeight.w500 : null,
                          ),
                        ),
                      ),
                    ],
                    if (reminder.location != null) ...[
                      if (reminder.triggerTime != null) const SizedBox(width: 12),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          reminder.location!.name ?? reminder.location!.address,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),

                // Status badges and time until
                if (timeUntil != null || reminder.status == ReminderStatus.snoozed) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (timeUntil != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isOverdue 
                                ? Colors.red.withOpacity(0.1)
                                : theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            timeUntil,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isOverdue 
                                  ? Colors.red 
                                  : theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (reminder.status == ReminderStatus.snoozed) ...[
                        if (timeUntil != null) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.snooze,
                                size: 12,
                                color: Colors.orange[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.snoozed,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Action buttons
                if (showActions) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (reminder.status.isActive) ...[
                        TextButton.icon(
                          onPressed: onSnooze,
                          icon: const Icon(Icons.snooze, size: 16),
                          label: Text(l10n.snooze),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            textStyle: theme.textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: onComplete,
                          icon: const Icon(Icons.check, size: 16),
                          label: Text(l10n.complete),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            textStyle: theme.textTheme.labelMedium,
                          ),
                        ),
                      ] else if (reminder.status == ReminderStatus.completed) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.completed,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Tags
                if (reminder.tags != null && reminder.tags!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: reminder.tags!.take(3).map((tag) => Chip(
                      label: Text(
                        tag,
                        style: theme.textTheme.labelSmall,
                      ),
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeading}) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLeading ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isLeading ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLeading ? Icons.check : Icons.delete,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            isLeading ? l10n.complete : l10n.delete,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(ReminderPriority priority, BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    IconData icon;

    switch (priority) {
      case ReminderPriority.low:
        color = Colors.blue;
        icon = Icons.keyboard_arrow_down;
        break;
      case ReminderPriority.medium:
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case ReminderPriority.high:
        color = Colors.red;
        icon = Icons.keyboard_arrow_up;
        break;
      case ReminderPriority.urgent:
        color = Colors.red;
        icon = Icons.priority_high;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Color _getTypeColor(ReminderType type) {
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

  IconData _getTypeIcon(ReminderType type) {
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

  String _formatTriggerTime(DateTime triggerTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = triggerTime.difference(now);
    
    if (difference.isNegative) {
      // Overdue
      final overdueDifference = now.difference(triggerTime);
      if (overdueDifference.inDays > 0) {
        return l10n.overdueDays(overdueDifference.inDays);
      } else if (overdueDifference.inHours > 0) {
        return l10n.overdueHours(overdueDifference.inHours);
      } else {
        return l10n.overdueMinutes(overdueDifference.inMinutes);
      }
    }

    // Format the date/time
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final triggerDate = DateTime(triggerTime.year, triggerTime.month, triggerTime.day);

    final timeFormat = DateFormat.jm();
    final dateFormat = DateFormat.MMMd();

    if (triggerDate == today) {
      return '${l10n.today} ${timeFormat.format(triggerTime)}';
    } else if (triggerDate == tomorrow) {
      return '${l10n.tomorrow} ${timeFormat.format(triggerTime)}';
    } else if (difference.inDays < 7) {
      final dayFormat = DateFormat.EEEE();
      return '${dayFormat.format(triggerTime)} ${timeFormat.format(triggerTime)}';
    } else {
      return '${dateFormat.format(triggerTime)} ${timeFormat.format(triggerTime)}';
    }
  }

  bool get _isOverdue {
    if (reminder.triggerTime == null || !reminder.status.isActive) return false;
    return reminder.triggerTime!.isBefore(DateTime.now());
  }

  String? get _timeUntilTrigger {
    if (reminder.triggerTime == null || !reminder.status.isActive) return null;
    
    final now = DateTime.now();
    final difference = reminder.triggerTime!.difference(now);
    
    if (difference.isNegative) {
      return null; // Handled by overdue display
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}