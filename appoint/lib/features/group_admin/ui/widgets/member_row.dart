import 'package:flutter/material.dart';
import 'package:appoint/models/group_role.dart';

class MemberRow extends StatelessWidget {
  final GroupMember member;
  final bool isCurrentUser;
  final GroupRole currentUserRole;
  final VoidCallback? onPromote;
  final VoidCallback? onDemote;
  final VoidCallback? onRemove;
  final VoidCallback? onTransferOwner;

  const MemberRow({
    super.key,
    required this.member,
    required this.isCurrentUser,
    required this.currentUserRole,
    this.onPromote,
    this.onDemote,
    this.onRemove,
    this.onTransferOwner,
  });

  @override
  Widget build(BuildContext context) {
    final canManageRoles = currentUserRole.canManageRoles();
    final canRemoveMembers = currentUserRole.canRemoveMembers();
    final canTransferOwnership = currentUserRole.canTransferOwnership();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(member.role),
          child: Text(
            member.userId.substring(0, 2).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                member.userId,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            if (isCurrentUser)
              const Chip(
                label: Text('You'),
                backgroundColor: Colors.blue,
                labelStyle: TextStyle(color: Colors.white, fontSize: 12),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.role.displayName,
              style: TextStyle(
                color: _getRoleColor(member.role),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Joined ${_formatDate(member.joinedAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canManageRoles &&
                member.role == GroupRole.member &&
                onPromote != null)
              IconButton(
                onPressed: onPromote,
                icon: const Icon(Icons.arrow_upward, color: Colors.green),
                tooltip: 'Promote to Admin',
              ),
            if (canManageRoles &&
                member.role == GroupRole.admin &&
                onDemote != null)
              IconButton(
                onPressed: onDemote,
                icon: const Icon(Icons.arrow_downward, color: Colors.orange),
                tooltip: 'Demote to Member',
              ),
            if (canRemoveMembers && !isCurrentUser && onRemove != null)
              IconButton(
                onPressed: onRemove,
                icon:
                    const Icon(Icons.remove_circle_outline, color: Colors.red),
                tooltip: 'Remove Member',
              ),
            if (canTransferOwnership &&
                !isCurrentUser &&
                onTransferOwner != null)
              IconButton(
                onPressed: onTransferOwner,
                icon: const Icon(Icons.swap_horiz, color: Colors.purple),
                tooltip: 'Transfer Ownership',
              ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(GroupRole role) {
    switch (role) {
      case GroupRole.owner:
        return Colors.purple;
      case GroupRole.admin:
        return Colors.orange;
      case GroupRole.member:
        return Colors.blue;
    }
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
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks weeks ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    }
  }
}
