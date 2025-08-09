import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupMemberTile extends ConsumerWidget {
  final String memberId;
  final bool isAdmin;
  final bool isCurrentUser;
  final String groupId;
  final VoidCallback onMemberRemoved;

  const GroupMemberTile({
    super.key,
    required this.memberId,
    required this.isAdmin,
    required this.isCurrentUser,
    required this.groupId,
    required this.onMemberRemoved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            isAdmin ? Theme.of(context).primaryColor : Colors.grey[300],
        child: Text(
          memberId.substring(0, 2).toUpperCase(),
          style: TextStyle(
            color: isAdmin ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              memberId,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight:
                        isCurrentUser ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ),
          if (isCurrentUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'You',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        isAdmin ? 'Admin' : 'Member',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color:
                  isAdmin ? Theme.of(context).primaryColor : Colors.grey[600],
              fontWeight: isAdmin ? FontWeight.w500 : FontWeight.normal,
            ),
      ),
      trailing: isAdmin
          ? Icon(
              Icons.admin_panel_settings,
              color: Theme.of(context).primaryColor,
              size: 20,
            )
          : null,
    );
  }
}
