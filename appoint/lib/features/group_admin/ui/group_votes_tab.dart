import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import removed; votes are provided by provider types
import 'package:appoint/features/group_admin/providers/group_admin_providers.dart';
import 'package:appoint/features/auth/providers/auth_provider.dart';
import 'package:appoint/features/group_admin/ui/widgets/vote_card.dart';

class GroupVotesTab extends ConsumerWidget {
  final String groupId;

  const GroupVotesTab({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final votesAsync = ref.watch(groupVotesProvider(groupId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState?.user?.uid;

    return votesAsync.when(
      data: (votes) {
        if (votes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.how_to_vote_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No votes found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Votes will appear here when they are created',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final openVotes = votes.where((vote) => vote.status == 'open').toList();
        final closedVotes =
            votes.where((vote) => vote.status == 'closed').toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Open Votes Section
              if (openVotes.isNotEmpty) ...[
                Text(
                  'Open Votes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...openVotes.map((vote) => VoteCard(
                      vote: vote,
                      currentUserId: currentUserId,
                      onCastBallot: (yes) =>
                          _castBallot(context, ref, vote.id, yes),
                      onCloseVote: () => _closeVote(context, ref, vote.id),
                    )),
                const SizedBox(height: 24),
              ],

              // Closed Votes Section
              if (closedVotes.isNotEmpty) ...[
                Text(
                  'Closed Votes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...closedVotes.map((vote) => VoteCard(
                      vote: vote,
                      currentUserId: currentUserId,
                      onCastBallot: null, // Can't vote on closed votes
                      onCloseVote: null, // Can't close already closed votes
                    )),
              ],

              // No votes message
              if (openVotes.isEmpty && closedVotes.isEmpty)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_vote_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No votes found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Votes will appear here when they are created',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Failed to load votes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(groupVotesProvider(groupId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _castBallot(
      BuildContext context, WidgetRef ref, String voteId, bool yes) async {
    try {
      await ref.read(groupVoteActionsProvider.notifier).castBallot(voteId, yes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vote cast: ${yes ? 'Yes' : 'No'}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cast vote: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _closeVote(
      BuildContext context, WidgetRef ref, String voteId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close Vote'),
        content: const Text(
            'Are you sure you want to close this vote? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Close'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(groupVoteActionsProvider.notifier).closeVote(voteId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vote closed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to close vote: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
