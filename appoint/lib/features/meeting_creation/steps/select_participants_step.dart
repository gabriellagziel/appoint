import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../widgets/participants_preview_widget.dart';
import '../widgets/select_group_dialog.dart';
import '../widgets/group_suggestions_bar.dart';
import '../widgets/saved_group_chip.dart';
import '../../../models/user_group.dart';

class SelectParticipantsStep extends ConsumerWidget {
  final VoidCallback onNext;

  const SelectParticipantsStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingState = ref.watch(REDACTED_TOKEN);
    final participants = meetingState.participants;
    final selectedGroup = meetingState.selectedGroup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Participants'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who will attend?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Group Suggestions Bar
            const GroupSuggestionsBar(),
            const SizedBox(height: 16),

            // Saved Groups Bar
            const SavedGroupsBar(),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddParticipantDialog(context, ref),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Individual'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showSelectGroupDialog(context, ref),
                    icon: const Icon(Icons.group),
                    label: const Text('Select Group'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Meeting Type Info
            if (selectedGroup != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Meeting Type: Event (Group selected)',
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

            // Participants Preview
            Expanded(
              child: participants.isEmpty
                  ? const Center(
                      child: Text('No participants selected'),
                    )
                  : const ParticipantsPreviewWidget(),
            ),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: participants.isNotEmpty ? onNext : null,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddParticipantDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Participant'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Participant ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final participantId = controller.text.trim();
              if (participantId.isNotEmpty) {
                ref
                    .read(REDACTED_TOKEN.notifier)
                    .addParticipant(participantId);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSelectGroupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SelectGroupDialog(
        onGroupSelected: (UserGroup group) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Added ${group.memberCount} participants from ${group.name}'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
