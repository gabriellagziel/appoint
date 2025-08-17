import 'package:flutter/material.dart';
import 'package:appoint/models/group_vote.dart';

class VoteCard extends StatelessWidget {
  final GroupVote vote;
  final String? currentUserId;
  final Function(bool)? onCastBallot;
  final VoidCallback? onCloseVote;

  const VoteCard({
    super.key,
    required this.vote,
    this.currentUserId,
    this.onCastBallot,
    this.onCloseVote,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = vote.isOpen;
    final hasVoted =
        currentUserId != null && vote.ballots.containsKey(currentUserId);
    final canVote = isOpen && !hasVoted && onCastBallot != null;
    final canClose = isOpen && onCloseVote != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vote Header
            Row(
              children: [
                Icon(
                  _getVoteIcon(),
                  color: _getVoteColor(),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getVoteTitle(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        _getVoteSubtitle(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            const SizedBox(height: 16),

            // Vote Progress
            _buildProgressSection(context),
            const SizedBox(height: 16),

            // Vote Actions
            if (isOpen) _buildActionButtons(context, canVote, canClose),

            // Vote Results (if closed)
            if (!isOpen) _buildResultsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final isOpen = vote.isOpen;
    final isExpired = (vote.closesAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .isBefore(DateTime.now());

    Color color;
    String text;

    if (isOpen && isExpired) {
      color = Colors.orange;
      text = 'Expired';
    } else if (isOpen) {
      color = Colors.green;
      text = 'Open';
    } else {
      color = Colors.grey;
      text = 'Closed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final totalVotes = vote.totalVotes;
    final yesPercentage = totalVotes > 0 ? (vote.yesVotes / totalVotes) : 0.0;
    final noPercentage = totalVotes > 0 ? (vote.noVotes / totalVotes) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Yes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    vote.yesVotes.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'No',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    vote.noVotes.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    totalVotes.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: yesPercentage,
          backgroundColor: Colors.red[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(yesPercentage * 100).toStringAsFixed(1)}% Yes',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(noPercentage * 100).toStringAsFixed(1)}% No',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, bool canVote, bool canClose) {
    return Row(
      children: [
        if (canVote) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => onCastBallot?.call(true),
              icon: const Icon(Icons.thumb_up, color: Colors.white),
              label: const Text('Vote Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => onCastBallot?.call(false),
              icon: const Icon(Icons.thumb_down, color: Colors.white),
              label: const Text('Vote No'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ] else if (currentUserId != null &&
            vote.ballots.containsKey(currentUserId)) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vote.ballots[currentUserId]!
                        ? Icons.thumb_up
                        : Icons.thumb_down,
                    color: vote.ballots[currentUserId]!
                        ? Colors.green
                        : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'You voted ${vote.ballots[currentUserId]! ? 'Yes' : 'No'}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (canClose) ...[
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onCloseVote,
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    final result = vote.yesCount > vote.noCount ? 'Passed' : 'Failed';
    final resultColor =
        vote.yesCount > vote.noCount ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: resultColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: resultColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            vote.yesCount > vote.noCount ? Icons.check_circle : Icons.cancel,
            color: resultColor,
          ),
          const SizedBox(width: 8),
          Text(
            'Result: ${vote.hasPassed ? 'Passed' : 'Failed'}',
            style: TextStyle(
              color: resultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getVoteIcon() {
    switch (vote.action) {
      case 'promote_admin':
        return Icons.arrow_upward;
      case 'demote_admin':
        return Icons.arrow_downward;
      case 'remove_member':
        return Icons.person_remove;
      default:
        return Icons.how_to_vote;
    }
  }

  Color _getVoteColor() {
    switch (vote.action) {
      case 'promote_admin':
        return Colors.green;
      case 'demote_admin':
        return Colors.orange;
      case 'remove_member':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getVoteTitle() {
    switch (vote.action) {
      case 'promote_admin':
        return 'Promote to Admin';
      case 'demote_admin':
        return 'Demote Admin';
      case 'remove_member':
        return 'Remove Member';
      default:
        return 'Vote';
    }
  }

  String _getVoteSubtitle() {
    return 'Target: ${vote.targetUserId} • Created ${_formatDate(vote.createdAt)}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
