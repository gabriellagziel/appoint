import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/group_sharing_service.dart';
import '../../../models/user_group.dart';
import '../../auth/providers/auth_provider.dart';

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

// Provider for current user's groups
final currentUserGroupsProvider = FutureProvider<List<UserGroup>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState == null || authState.user == null) {
    return [];
  }
  final groupsAsync = ref.watch(userGroupsProvider(authState.user!.uid));
  return groupsAsync.when(
    data: (groups) => groups,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for a specific group
final groupProvider =
    FutureProvider.family<UserGroup?, String>((ref, groupId) async {
  final service = ref.read(groupSharingServiceProvider);
  return await service.getGroupById(groupId);
});
