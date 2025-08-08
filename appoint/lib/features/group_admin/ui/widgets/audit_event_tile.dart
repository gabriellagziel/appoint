import 'package:flutter/material.dart';
import 'package:appoint/models/group_audit_event.dart';

class AuditEventTile extends StatelessWidget {
  final GroupAuditEvent event;
  final bool isLast;

  const AuditEventTile({
    super.key,
    required this.event,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getEventColor(),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Event content
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getEventIcon(),
                        color: _getEventColor(),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getEventTitle(),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Text(
                        _formatTime(event.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getEventDescription(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (event.metadata.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildMetadata(context),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: event.metadata.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(
                  '${entry.key}: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                ),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getEventIcon() {
    switch (event.type) {
      case AuditEventType.roleChanged:
        return Icons.swap_horiz;
      case AuditEventType.policyChanged:
        return Icons.settings;
      case AuditEventType.memberRemoved:
        return Icons.person_remove;
      case AuditEventType.voteOpened:
        return Icons.how_to_vote;
      case AuditEventType.voteClosed:
        return Icons.check_circle;
      case AuditEventType.memberJoined:
        return Icons.person_add;
      case AuditEventType.memberInvited:
        return Icons.mail;
      default:
        return Icons.info;
    }
  }

  Color _getEventColor() {
    switch (event.type) {
      case AuditEventType.roleChanged:
        return Colors.blue;
      case AuditEventType.policyChanged:
        return Colors.orange;
      case AuditEventType.memberRemoved:
        return Colors.red;
      case AuditEventType.voteOpened:
        return Colors.green;
      case AuditEventType.voteClosed:
        return Colors.purple;
      case AuditEventType.memberJoined:
        return Colors.teal;
      case AuditEventType.memberInvited:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String _getEventTitle() {
    switch (event.type) {
      case AuditEventType.roleChanged:
        return 'Role Changed';
      case AuditEventType.policyChanged:
        return 'Policy Updated';
      case AuditEventType.memberRemoved:
        return 'Member Removed';
      case AuditEventType.voteOpened:
        return 'Vote Opened';
      case AuditEventType.voteClosed:
        return 'Vote Closed';
      case AuditEventType.memberJoined:
        return 'Member Joined';
      case AuditEventType.memberInvited:
        return 'Member Invited';
      default:
        return 'Event';
    }
  }

  String _getEventDescription() {
    switch (event.type) {
      case AuditEventType.roleChanged:
        return '${event.actorUserId} changed ${event.targetUserId}\'s role';
      case AuditEventType.policyChanged:
        return '${event.actorUserId} updated group policy';
      case AuditEventType.memberRemoved:
        return '${event.actorUserId} removed ${event.targetUserId} from the group';
      case AuditEventType.voteOpened:
        return '${event.actorUserId} opened a vote for ${event.targetUserId}';
      case AuditEventType.voteClosed:
        return 'Vote was closed';
      case AuditEventType.memberJoined:
        return '${event.targetUserId} joined the group';
      case AuditEventType.memberInvited:
        return '${event.actorUserId} invited ${event.targetUserId}';
      default:
        return 'An event occurred';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
