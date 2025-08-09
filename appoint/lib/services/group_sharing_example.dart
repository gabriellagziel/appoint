import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group_sharing_service.dart';
import '../models/user_group.dart';
import '../models/group_invite.dart';

// Provider for GroupSharingService
final groupSharingServiceProvider = Provider<GroupSharingService>((ref) {
  return GroupSharingService();
});

// Provider for user's groups
final userGroupsProvider =
    FutureProvider.family<List<UserGroup>, String>((ref, userId) async {
  final service = ref.read(groupSharingServiceProvider);
  return await service.getUserGroups(userId);
});

// Provider for specific group
final groupProvider =
    FutureProvider.family<UserGroup?, String>((ref, groupId) async {
  final service = ref.read(groupSharingServiceProvider);
  return await service.getGroupById(groupId);
});

// Provider for group invite
final groupInviteProvider =
    FutureProvider.family<GroupInvite?, String>((ref, code) async {
  final service = ref.read(groupSharingServiceProvider);
  return await service.getGroupInvite(code);
});

/// Example usage of Group Sharing Foundation
class GroupSharingExample {
  final GroupSharingService _service = GroupSharingService();

  /// Create a new group with invite code
  Future<String> createGroupExample(String userId) async {
    try {
      final inviteCode = await _service.createGroupInvite(
        userId,
        groupName: "My Family Group",
        description: "A group for sharing appointments with family",
        maxUses: 10,
        expiresIn: const Duration(days: 7),
      );

      print('Group created with invite code: $inviteCode');
      return inviteCode;
    } catch (e) {
      print('Error creating group: $e');
      rethrow;
    }
  }

  /// Join a group using invite code
  Future<UserGroup> joinGroupExample(String inviteCode, String userId) async {
    try {
      final group = await _service.joinGroupFromCode(inviteCode, userId);
      print('Successfully joined group: ${group.name}');
      return group;
    } catch (e) {
      print('Error joining group: $e');
      rethrow;
    }
  }

  /// Get user's groups
  Future<List<UserGroup>> getUserGroupsExample(String userId) async {
    try {
      final groups = await _service.getUserGroups(userId);
      print('Found ${groups.length} groups for user');
      return groups;
    } catch (e) {
      print('Error getting user groups: $e');
      rethrow;
    }
  }

  /// Leave a group
  Future<void> leaveGroupExample(String groupId, String userId) async {
    try {
      await _service.leaveGroup(groupId, userId);
      print('Successfully left group');
    } catch (e) {
      print('Error leaving group: $e');
      rethrow;
    }
  }

  /// Delete a group (admin only)
  Future<void> deleteGroupExample(String groupId, String userId) async {
    try {
      await _service.deleteGroup(groupId, userId);
      print('Successfully deleted group');
    } catch (e) {
      print('Error deleting group: $e');
      rethrow;
    }
  }

  /// Check if user is admin
  Future<bool> isAdminExample(String groupId, String userId) async {
    try {
      final isAdmin = await _service.isUserGroupAdmin(groupId, userId);
      print('User is admin: $isAdmin');
      return isAdmin;
    } catch (e) {
      print('Error checking admin status: $e');
      rethrow;
    }
  }

  /// Create share link
  String createShareLinkExample(String groupCode) {
    final shareLink = _service.createGroupShareLink(groupCode);
    print('Share link: $shareLink');
    return shareLink;
  }
}

/// Widget example using Riverpod providers
class GroupSharingWidget extends ConsumerWidget {
  final String userId;

  const GroupSharingWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGroupsAsync = ref.watch(userGroupsProvider(userId));

    return userGroupsAsync.when(
      data: (groups) {
        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return ListTile(
              title: Text(group.name),
              subtitle: Text('${group.memberCount} members'),
              trailing: group.admins.contains(userId)
                  ? const Icon(Icons.admin_panel_settings)
                  : null,
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}


