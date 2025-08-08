import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_group.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../providers/group_participants_provider.dart';
import 'group_selector_tile.dart';

class SelectGroupDialog extends ConsumerWidget {
  final Function(UserGroup) onGroupSelected;

  const SelectGroupDialog({
    super.key,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(currentUserGroupsProvider);
    final meetingState = ref.watch(REDACTED_TOKEN);

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.group,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select a Group',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a group to add all its members as meeting participants',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Groups List
            Expanded(
              child: groupsAsync.when(
                data: (groups) {
                  if (groups.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final isSelected =
                          meetingState.selectedGroup?.id == group.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GroupSelectorTile(
                          group: group,
                          isSelected: isSelected,
                          onTap: () {
                            ref
                                .read(REDACTED_TOKEN
                                    .notifier)
                                .selectGroup(group);
                            onGroupSelected(group);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load groups',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(currentUserGroupsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                if (meetingState.selectedGroup != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(REDACTED_TOKEN.notifier)
                            .clearGroup();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Clear Selection'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.group_add,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Groups Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'You need to create or join a group first before you can use group-based meetings.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to group management
              // context.go('/groups');
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Group'),
          ),
        ],
      ),
    );
  }
}


