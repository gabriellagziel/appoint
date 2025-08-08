import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/features/group_admin/providers/group_admin_providers.dart';
import 'package:appoint/features/auth/providers/auth_provider.dart';

class GroupAdminTab extends ConsumerWidget {
  final String groupId;

  const GroupAdminTab({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final policyAsync = ref.watch(groupPolicyProvider(groupId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState?.user?.uid;

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

        return policyAsync.when(
          data: (policy) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildQuickActions(
                              context, ref, members, currentUserMember, policy),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Role Management Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role Management',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildRoleManagement(
                              context, ref, members, currentUserMember),
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
                  'Failed to load policy',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(groupPolicyProvider(groupId)),
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
              'Failed to load members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(groupMembersProvider(groupId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref,
      List<GroupMember> members, GroupMember currentUser, GroupPolicy policy) {
    final canManageRoles = currentUser.role.canManageRoles();
    final nonAdminMembers =
        members.where((m) => m.role == GroupRole.member).toList();
    final adminMembers =
        members.where((m) => m.role == GroupRole.admin).toList();

    return Column(
      children: [
        // Promote Member to Admin
        if (canManageRoles && nonAdminMembers.isNotEmpty)
          _buildActionTile(
            context,
            title: 'Promote Member to Admin',
            subtitle: '${nonAdminMembers.length} members available',
            icon: Icons.arrow_upward,
            color: Colors.green,
            onTap: () =>
                _showPromoteDialog(context, ref, nonAdminMembers, policy),
          ),

        // Demote Admin to Member
        if (canManageRoles && adminMembers.isNotEmpty)
          _buildActionTile(
            context,
            title: 'Demote Admin to Member',
            subtitle: '${adminMembers.length} admins available',
            icon: Icons.arrow_downward,
            color: Colors.orange,
            onTap: () => _showDemoteDialog(context, ref, adminMembers),
          ),

        // Transfer Ownership
        if (currentUser.role.canTransferOwnership())
          _buildActionTile(
            context,
            title: 'Transfer Ownership',
            subtitle: 'Transfer group ownership to another member',
            icon: Icons.swap_horiz,
            color: Colors.purple,
            onTap: () => _showTransferDialog(context, ref, members),
          ),

        if (!canManageRoles)
          _buildActionTile(
            context,
            title: 'No Actions Available',
            subtitle: 'You need admin permissions to manage roles',
            icon: Icons.lock,
            color: Colors.grey,
            onTap: null,
          ),
      ],
    );
  }

  Widget _buildRoleManagement(BuildContext context, WidgetRef ref,
      List<GroupMember> members, GroupMember currentUser) {
    final roleStats = _calculateRoleStats(members);

    return Column(
      children: [
        // Role Statistics
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Owners',
                roleStats.owners.toString(),
                Colors.purple,
                Icons.crown,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                context,
                'Admins',
                roleStats.admins.toString(),
                Colors.orange,
                Icons.admin_panel_settings,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                context,
                'Members',
                roleStats.members.toString(),
                Colors.blue,
                Icons.people,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Role Distribution Chart
        _buildRoleChart(context, roleStats),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.arrow_forward_ios) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleChart(BuildContext context, RoleStats stats) {
    final total = stats.owners + stats.admins + stats.members;
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role Distribution',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 1.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (stats.owners > 0)
              Expanded(
                flex: stats.owners,
                child: Container(
                  height: 8,
                  color: Colors.purple,
                ),
              ),
            if (stats.admins > 0)
              Expanded(
                flex: stats.admins,
                child: Container(
                  height: 8,
                  color: Colors.orange,
                ),
              ),
            if (stats.members > 0)
              Expanded(
                flex: stats.members,
                child: Container(
                  height: 8,
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showPromoteDialog(BuildContext context, WidgetRef ref,
      List<GroupMember> members, GroupPolicy policy) {
    String? selectedUserId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Promote Member to Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (policy.requireVoteForAdmin)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Policy requires voting for admin promotions',
                          style: TextStyle(color: Colors.orange[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              DropdownButtonFormField<String>(
                value: selectedUserId,
                decoration: const InputDecoration(
                  labelText: 'Select Member',
                  border: OutlineInputBorder(),
                ),
                items: members.map((member) {
                  return DropdownMenuItem(
                    value: member.userId,
                    child: Text(member.userId),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedUserId = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedUserId == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      if (policy.requireVoteForAdmin) {
                        _openVoteForPromotion(context, ref, selectedUserId!);
                      } else {
                        _promoteMember(context, ref, selectedUserId!);
                      }
                    },
              child:
                  Text(policy.requireVoteForAdmin ? 'Start Vote' : 'Promote'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDemoteDialog(
      BuildContext context, WidgetRef ref, List<GroupMember> members) {
    String? selectedUserId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Demote Admin to Member'),
          content: DropdownButtonFormField<String>(
            value: selectedUserId,
            decoration: const InputDecoration(
              labelText: 'Select Admin',
              border: OutlineInputBorder(),
            ),
            items: members.map((member) {
              return DropdownMenuItem(
                value: member.userId,
                child: Text(member.userId),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedUserId = value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedUserId == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _demoteAdmin(context, ref, selectedUserId!);
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Demote'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferDialog(
      BuildContext context, WidgetRef ref, List<GroupMember> members) {
    String? selectedUserId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Transfer Ownership'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedUserId,
                decoration: const InputDecoration(
                  labelText: 'Select New Owner',
                  border: OutlineInputBorder(),
                ),
                items: members
                    .where((m) => m.role != GroupRole.owner)
                    .map((member) {
                  return DropdownMenuItem(
                    value: member.userId,
                    child: Text(member.userId),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedUserId = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedUserId == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _transferOwnership(context, ref, selectedUserId!);
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openVoteForPromotion(
      BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref
          .read(groupVoteActionsProvider.notifier)
          .openVote(groupId, 'promote_admin', userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vote opened for promoting $userId to admin'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open vote: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _promoteMember(
      BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .promoteToAdmin(groupId, userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$userId promoted to admin'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to promote user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _demoteAdmin(
      BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .demoteAdmin(groupId, userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$userId demoted to member'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to demote user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _transferOwnership(
      BuildContext context, WidgetRef ref, String userId) async {
    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .transferOwnership(groupId, userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ownership transferred to $userId'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to transfer ownership: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  RoleStats _calculateRoleStats(List<GroupMember> members) {
    int owners = 0, admins = 0, members = 0;

    for (final member in members) {
      switch (member.role) {
        case GroupRole.owner:
          owners++;
          break;
        case GroupRole.admin:
          admins++;
          break;
        case GroupRole.member:
          members++;
          break;
      }
    }

    return RoleStats(owners: owners, admins: admins, members: members);
  }
}

class RoleStats {
  final int owners;
  final int admins;
  final int members;

  RoleStats({
    required this.owners,
    required this.admins,
    required this.members,
  });
}
