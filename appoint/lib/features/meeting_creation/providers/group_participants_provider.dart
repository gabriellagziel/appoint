import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/group_sharing_service.dart';
import '../../../models/user_group.dart';
import '../../auth/providers/auth_provider.dart';
import '../../group/providers/group_providers.dart';

// Provider for user's groups
final userGroupsForMeetingProvider =
    FutureProvider.family<List<UserGroup>, String>((ref, userId) async {
  final service = ref.read(groupSharingServiceProvider);
  return await service.getUserGroups(userId);
});

// Provider that automatically gets the current user's groups
final currentUserGroupsProvider = FutureProvider<List<UserGroup>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState == null || authState.user == null) {
    return [];
  }

  final groupsAsync =
      ref.watch(userGroupsForMeetingProvider(authState.user!.uid));
  return groupsAsync.when(
    data: (groups) => groups,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for selected group participants
final selectedGroupParticipantsProvider =
    Provider.family<List<String>, UserGroup>((ref, group) {
  return List<String>.from(group.members);
});
