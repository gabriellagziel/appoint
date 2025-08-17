import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../../../models/user_group.dart';

class ParticipantsPreviewWidget extends ConsumerWidget {
  const ParticipantsPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingState = ref.watch(createMeetingFlowControllerProvider);
    final participants = meetingState.participants;
    final selectedGroup = meetingState.selectedGroup;

    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Participants',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Text(
                  '${participants.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Group Info (if group is selected)
            if (selectedGroup != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedGroup.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                          if (selectedGroup.description != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              selectedGroup.description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tooltip(
                      message: 'Participants added from group',
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Participants List
            if (participants.length <= 5) ...[
              // Show all participants if 5 or fewer
              ...participants.map((participantId) => _buildParticipantTile(
                    context,
                    participantId,
                    ref,
                  )),
            ] else ...[
              // Show first 4 participants + "and X more"
              ...participants
                  .take(4)
                  .map((participantId) => _buildParticipantTile(
                        context,
                        participantId,
                        ref,
                      )),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    '+${participants.length - 4}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'and ${participants.length - 4} more',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    // Show full participants list
                    _showAllParticipantsDialog(
                        context, participants, selectedGroup);
                  },
                  icon: const Icon(Icons.expand_more),
                ),
              ),
            ],

            // Clear Group Button
            if (selectedGroup != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(createMeetingFlowControllerProvider.notifier)
                        .clearGroup();
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Group Selection'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(
      BuildContext context, String participantId, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        child: Text(
          participantId.substring(0, 2).toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(participantId),
      subtitle: const Text('Participant'),
      trailing: IconButton(
        onPressed: () {
          ref
              .read(createMeetingFlowControllerProvider.notifier)
              .removeParticipant(participantId);
        },
        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
      ),
    );
  }

  void _showAllParticipantsDialog(BuildContext context,
      List<String> participants, UserGroup? selectedGroup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.people, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('All Participants'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedGroup != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.group, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'From group: ${selectedGroup.name}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ...participants.map((participantId) => ListTile(
                    leading: CircleAvatar(
                      child: Text(participantId.substring(0, 2).toUpperCase()),
                    ),
                    title: Text(participantId),
                    subtitle: const Text('Participant'),
                  )),
            ],
          ),
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
}
