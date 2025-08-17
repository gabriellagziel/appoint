import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/group_policy.dart';
import 'package:appoint/features/group_admin/providers/group_admin_providers.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/features/auth/providers/auth_provider.dart';
import 'package:appoint/features/group_admin/ui/widgets/policy_switch_tile.dart';

class GroupPolicyTab extends ConsumerStatefulWidget {
  final String groupId;

  const GroupPolicyTab({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupPolicyTab> createState() => _GroupPolicyTabState();
}

class _GroupPolicyTabState extends ConsumerState<GroupPolicyTab> {
  GroupPolicy? _currentPolicy;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final policyAsync = ref.watch(groupPolicyProvider(widget.groupId));
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState?.user?.uid;

    return policyAsync.when(
      data: (policy) {
        _currentPolicy = policy;

        return membersAsync.when(
          data: (members) {
            final currentUserMember = members.firstWhere(
              (member) => member.userId == currentUserId,
              orElse: () => GroupMember(
                userId: currentUserId ?? '',
                role: GroupRole.member,
                joinedAt: DateTime.now(),
              ),
            );

            final canManagePolicy = currentUserMember.role.canManagePolicy();

            if (!canManagePolicy) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Policy Management Restricted',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You need admin permissions to manage group policies',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Policy Overview Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.policy,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                'Group Policies',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Configure how your group operates and manages permissions',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Policy Settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          PolicySwitchTile(
                            title: 'Members Can Invite',
                            subtitle:
                                'Allow regular members to invite new people to the group',
                            value: policy.membersCanInvite,
                            onChanged: (value) =>
                                _updatePolicy('membersCanInvite', value),
                            icon: Icons.person_add,
                          ),
                          const Divider(),
                          PolicySwitchTile(
                            title: 'Require Vote for Admin',
                            subtitle:
                                'Require group voting to promote members to admin',
                            value: policy.requireVoteForAdmin,
                            onChanged: (value) =>
                                _updatePolicy('requireVoteForAdmin', value),
                            icon: Icons.how_to_vote,
                          ),
                          const Divider(),
                          PolicySwitchTile(
                            title: 'Allow Non-Members RSVP',
                            subtitle:
                                'Allow people who aren\'t members to RSVP to events',
                            value: policy.allowNonMembersRSVP,
                            onChanged: (value) =>
                                _updatePolicy('allowNonMembersRSVP', value),
                            icon: Icons.event_available,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Policy Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Policy Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildPolicyInfo(context, policy),
                        ],
                      ),
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
                  'Failed to load members',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(groupMembersProvider(widget.groupId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
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
              'Failed to load policy',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(groupPolicyProvider(widget.groupId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyInfo(BuildContext context, GroupPolicy policy) {
    return Column(
      children: [
        _buildInfoRow(
          context,
          'Last Updated',
          _formatDate(policy.lastUpdated),
          Icons.update,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          'Updated By',
          policy.updatedBy ?? 'Unknown',
          Icons.person,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          'Policy Version',
          policy.version.toString(),
          Icons.info,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _updatePolicy(String field, bool value) async {
    if (_currentPolicy == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPolicy = _currentPolicy!.copyWith(
        membersCanInvite: field == 'membersCanInvite'
            ? value
            : _currentPolicy!.membersCanInvite,
        requireVoteForAdmin: field == 'requireVoteForAdmin'
            ? value
            : _currentPolicy!.requireVoteForAdmin,
        allowNonMembersRSVP: field == 'allowNonMembersRSVP'
            ? value
            : _currentPolicy!.allowNonMembersRSVP,
        lastUpdated: DateTime.now(),
        updatedBy: ref.read(authStateProvider)?.user?.uid,
        version: _currentPolicy!.version + 1,
      );

      await ref
          .read(groupPolicyActionsProvider.notifier)
          .updatePolicy(widget.groupId, updatedPolicy);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Policy updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update policy: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
