import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/features/group_admin/providers/group_admin_providers.dart';
import 'package:appoint/features/auth/providers/auth_provider.dart';
import 'package:appoint/features/group_admin/ui/widgets/member_row.dart';

class GroupMembersTab extends ConsumerWidget {
  final String groupId;

  const GroupMembersTab({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState?.user?.uid;

    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No members found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Get current user's role
        final currentUserMember = members.firstWhere(
          (member) => member.userId == currentUserId,
          orElse: () => GroupMember(
            userId: currentUserId ?? '',
            role: GroupRole.member,
            joinedAt: DateTime.now(),
          ),
        );

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return MemberRow(
              member: member,
              isCurrentUser: member.userId == currentUserId,
              currentUserRole: currentUserMember.role,
              onPromote: () => _promoteToAdmin(context, ref, member),
              onDemote: () => _demoteAdmin(context, ref, member),
              onRemove: () => _removeMember(context, ref, member),
              onTransferOwner: () => _transferOwnership(context, ref, member),
            );
          },
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

  Future<void> _promoteToAdmin(
      BuildContext context, WidgetRef ref, GroupMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promote to Admin'),
        content:
            Text('Are you sure you want to promote ${member.userId} to admin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Promote'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .promoteToAdmin(groupId, member.userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.userId} promoted to admin'),
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
      BuildContext context, WidgetRef ref, GroupMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demote Admin'),
        content:
            Text('Are you sure you want to demote ${member.userId} to member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Demote'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .demoteAdmin(groupId, member.userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.userId} demoted to member'),
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

  Future<void> _removeMember(
      BuildContext context, WidgetRef ref, GroupMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
            'Are you sure you want to remove ${member.userId} from the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .removeMember(groupId, member.userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.userId} removed from group'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _transferOwnership(
      BuildContext context, WidgetRef ref, GroupMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Ownership'),
        content: Text(
            'Are you sure you want to transfer group ownership to ${member.userId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Transfer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(groupAdminActionsProvider.notifier)
          .transferOwnership(groupId, member.userId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ownership transferred to ${member.userId}'),
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
}
