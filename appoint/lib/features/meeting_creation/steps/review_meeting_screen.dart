import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../models/meeting_types.dart';
import '../../meeting_share/widgets/share_to_group_button.dart';

class ReviewMeetingScreen extends ConsumerWidget {
  final VoidCallback onCreateMeeting;

  const ReviewMeetingScreen({
    super.key,
    required this.onCreateMeeting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingState = ref.watch(createMeetingFlowControllerProvider);
    final selectedGroup = meetingState.selectedGroup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Meeting Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Meeting Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meeting Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    _buildDetailRow('Title', meetingState.title),

                    // Description
                    if (meetingState.description.isNotEmpty)
                      _buildDetailRow('Description', meetingState.description),

                    // Date & Time
                    if (meetingState.dateTime != null)
                      _buildDetailRow(
                          'Date & Time', meetingState.dateTime!.toString()),

                    // Duration
                    _buildDetailRow(
                        'Duration', '${meetingState.duration.inHours} hours'),

                    // Meeting Type
                    _buildDetailRow(
                        'Type', meetingState.meetingType.displayName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Participants Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Participants',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Spacer(),
                        Text(
                          '${meetingState.participants.length}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.group,
                                color: Theme.of(context).primaryColor),
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
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Participants List
                    if (meetingState.participants.length <= 5) ...[
                      ...meetingState.participants
                          .map((participantId) => ListTile(
                                leading: CircleAvatar(
                                  child: Text(participantId
                                      .substring(0, 2)
                                      .toUpperCase()),
                                ),
                                title: Text(participantId),
                                subtitle: const Text('Participant'),
                              )),
                    ] else ...[
                      ...meetingState.participants
                          .take(4)
                          .map((participantId) => ListTile(
                                leading: CircleAvatar(
                                  child: Text(participantId
                                      .substring(0, 2)
                                      .toUpperCase()),
                                ),
                                title: Text(participantId),
                                subtitle: const Text('Participant'),
                              )),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            '+${meetingState.participants.length - 4}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        title: Text(
                            'and ${meetingState.participants.length - 4} more'),
                        subtitle: const Text('Participants'),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Action Buttons
            Column(
              children: [
                // Create Meeting Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ref
                            .read(createMeetingFlowControllerProvider.notifier)
                            .isValid
                        ? onCreateMeeting
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Create Meeting'),
                  ),
                ),

                // Share to Group Button (if group is selected)
                if (meetingState.selectedGroup != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showShareDialog(context, ref),
                      icon: const Icon(Icons.share),
                      label: const Text('Share to Group'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, WidgetRef ref) {
    final meetingState = ref.read(createMeetingFlowControllerProvider);
    final selectedGroup = meetingState.selectedGroup;

    if (selectedGroup == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Meeting'),
        content: Text('Share this meeting with ${selectedGroup.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // In a real app, this would create the meeting first
              // For now, we'll just show a placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meeting created and shared!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
