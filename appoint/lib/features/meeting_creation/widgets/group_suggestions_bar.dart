import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../group_suggestions/services/group_suggestions_service.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../../group_suggestions/providers/group_suggestions_providers.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../models/group_usage_insight.dart';

class GroupSuggestionsBar extends ConsumerWidget {
  const GroupSuggestionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(groupSuggestionsBarProvider);

    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Suggested Groups',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildSuggestionChip(context, ref, suggestion),
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

  Widget _buildSuggestionChip(
      BuildContext context, WidgetRef ref, GroupSuggestion suggestion) {
    final isPinned = suggestion.savedGroup?.pinned ?? false;

    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: isPinned
            ? Colors.orange.withValues(alpha: 0.1)
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        child: Icon(
          isPinned ? Icons.push_pin : Icons.group,
          size: 16,
          color: isPinned ? Colors.orange : Theme.of(context).primaryColor,
        ),
      ),
      label: Text(
        suggestion.group.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isPinned ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onPressed: () => _onSuggestionSelected(context, ref, suggestion),
      backgroundColor: isPinned
          ? Colors.orange.withValues(alpha: 0.05)
          : Theme.of(context).primaryColor.withValues(alpha: 0.05),
      side: BorderSide(
        color: isPinned
            ? Colors.orange.withValues(alpha: 0.3)
            : Theme.of(context).primaryColor.withValues(alpha: 0.2),
      ),
      tooltip: '${suggestion.group.members.length} members',
    );
  }

  void _onSuggestionSelected(
      BuildContext context, WidgetRef ref, GroupSuggestion suggestion) async {
    try {
      final authState = ref.read(authStateProvider);
      if (authState?.user == null) return;

      // Add group to meeting
      ref
          .read(createMeetingFlowControllerProvider.notifier)
          .selectGroup(suggestion.group);

      // Log usage event
      ref.read(logUsageEventProvider((
        userId: authState!.user!.uid,
        groupId: suggestion.group.id,
        event: GroupUsageEvent.createdWithGroup,
        meetingId: null,
        source: 'suggestions_bar',
      )));

      // Touch the group (update usage stats)
      ref.read(touchGroupProvider((
        userId: authState.user!.uid,
        groupId: suggestion.group.id,
      )));

      // Show success message
      if (context.mounted) {
        final memberCount = suggestion.group.members.length;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Added $memberCount participants from ${suggestion.group.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your top groups will appear here after a few shares',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading suggestions...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              'Failed to load suggestions',
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
