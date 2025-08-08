import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/saved_group.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../../../models/group_usage_insight.dart';
import '../../group_suggestions/providers/group_suggestions_providers.dart';
import '../../auth/providers/auth_provider.dart';

class SavedGroupChip extends ConsumerWidget {
  final SavedGroup savedGroup;
  final VoidCallback onTap;

  const SavedGroupChip({
    super.key,
    required this.savedGroup,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: savedGroup.pinned
            ? Colors.orange.withValues(alpha: 0.1)
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        child: Icon(
          savedGroup.pinned ? Icons.push_pin : Icons.bookmark,
          size: 16,
          color: savedGroup.pinned
              ? Colors.orange
              : Theme.of(context).primaryColor,
        ),
      ),
      label: Text(
        savedGroup.getDisplayName(null),
        style: TextStyle(
          fontSize: 12,
          fontWeight: savedGroup.pinned ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onPressed: () => _onTap(context, ref),
      backgroundColor: savedGroup.pinned
          ? Colors.orange.withValues(alpha: 0.05)
          : Theme.of(context).primaryColor.withValues(alpha: 0.05),
      side: BorderSide(
        color: savedGroup.pinned
            ? Colors.orange.withValues(alpha: 0.3)
            : Theme.of(context).primaryColor.withValues(alpha: 0.2),
      ),
      tooltip: savedGroup.pinned ? 'Pinned group' : 'Saved group',
    );
  }

  void _onTap(BuildContext context, WidgetRef ref) async {
    try {
      final authState = ref.read(authStateProvider);
      if (authState?.user == null) return;

      // Touch the group (update usage stats)
      ref.read(touchGroupProvider((
        userId: authState!.user!.uid,
        groupId: savedGroup.groupId,
      )));

      // Log usage event
      ref.read(logUsageEventProvider((
        userId: authState.user!.uid,
        groupId: savedGroup.groupId,
        event: GroupUsageEvent.createdWithGroup,
        meetingId: null,
        source: 'saved_group_chip',
      )));

      // Call the onTap callback
      onTap();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error using saved group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class SavedGroupsBar extends ConsumerWidget {
  const SavedGroupsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedGroupsAsync = ref.watch(savedGroupsChipsProvider);

    return savedGroupsAsync.when(
      data: (savedGroups) {
        if (savedGroups.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 16,
                  color: Colors.orange[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Saved Groups',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[600],
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showAllSavedGroups(context, ref),
                  child: const Text('View all'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: savedGroups.length,
                itemBuilder: (context, index) {
                  final savedGroup = savedGroups[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SavedGroupChip(
                      savedGroup: savedGroup,
                      onTap: () =>
                          _onSavedGroupTapped(context, ref, savedGroup),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorState(context, error),
    );
  }

  void _showAllSavedGroups(BuildContext context, WidgetRef ref) {
    // TODO: Implement modal to show all saved groups
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View all saved groups - Coming soon!'),
      ),
    );
  }

  void _onSavedGroupTapped(
      BuildContext context, WidgetRef ref, SavedGroup savedGroup) async {
    try {
      final authState = ref.read(authStateProvider);
      if (authState?.user == null) return;

      // Get the group details and add to meeting
      // This would require fetching the group from the group service
      // For now, we'll just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Using ${savedGroup.getDisplayName(null)}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error using saved group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Colors.red[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Failed to load saved groups',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red[600],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
