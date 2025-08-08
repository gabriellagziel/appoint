import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/models/group_policy.dart';
import 'package:appoint/models/group_vote.dart';
import 'package:appoint/models/group_audit_event.dart';
import 'package:appoint/services/group_admin_service.dart';
import 'package:appoint/services/group_vote_service.dart';
import 'package:appoint/services/group_policy_service.dart';
import 'package:appoint/services/group_audit_service.dart';

// Group Members Provider
final groupMembersProvider = FutureProvider.family<List<GroupMember>, String>(
  (ref, groupId) async {
    final service = ref.read(groupAdminServiceProvider);
    return await service.getGroupMembers(groupId);
  },
);

// Group Policy Provider
final groupPolicyProvider = FutureProvider.family<GroupPolicy, String>(
  (ref, groupId) async {
    final service = ref.read(groupPolicyServiceProvider);
    return await service.getGroupPolicy(groupId);
  },
);

// Group Votes Provider
final groupVotesProvider = FutureProvider.family<List<GroupVote>, String>(
  (ref, groupId) async {
    final service = ref.read(groupVoteServiceProvider);
    return await service.getGroupVotes(groupId);
  },
);

// Group Audit Provider
final groupAuditProvider = FutureProvider.family<List<GroupAuditEvent>, String>(
  (ref, groupId) async {
    final service = ref.read(groupAuditServiceProvider);
    return await service.getGroupAuditEvents(groupId);
  },
);

// Service Providers
final groupAdminServiceProvider = Provider<GroupAdminService>((ref) {
  return GroupAdminService();
});

final groupVoteServiceProvider = Provider<GroupVoteService>((ref) {
  return GroupVoteService();
});

final groupPolicyServiceProvider = Provider<GroupPolicyService>((ref) {
  return GroupPolicyService();
});

final groupAuditServiceProvider = Provider<GroupAuditService>((ref) {
  return GroupAuditService();
});

// Action Providers
class GroupAdminActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> promoteToAdmin(String groupId, String userId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupAdminServiceProvider);
      await service.promoteToAdmin(groupId, userId);
      ref.invalidate(groupMembersProvider(groupId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> demoteAdmin(String groupId, String userId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupAdminServiceProvider);
      await service.demoteAdmin(groupId, userId);
      ref.invalidate(groupMembersProvider(groupId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> transferOwnership(String groupId, String userId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupAdminServiceProvider);
      await service.transferOwnership(groupId, userId);
      ref.invalidate(groupMembersProvider(groupId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> removeMember(String groupId, String userId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupAdminServiceProvider);
      await service.removeMember(groupId, userId);
      ref.invalidate(groupMembersProvider(groupId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final groupAdminActionsProvider =
    AsyncNotifierProvider<GroupAdminActionsNotifier, void>(
  () => GroupAdminActionsNotifier(),
);

// Policy Actions
class GroupPolicyActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updatePolicy(String groupId, GroupPolicy patch) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupPolicyServiceProvider);
      await service.updatePolicy(groupId, patch);
      ref.invalidate(groupPolicyProvider(groupId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final groupPolicyActionsProvider =
    AsyncNotifierProvider<GroupPolicyActionsNotifier, void>(
  () => GroupPolicyActionsNotifier(),
);

// Vote Actions
class GroupVoteActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> openVote(
      String groupId, String action, String targetUserId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupVoteServiceProvider);
      await service.openVote(groupId, action, targetUserId);
      ref.invalidate(groupVotesProvider(groupId));
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> castBallot(String voteId, bool yes) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupVoteServiceProvider);
      await service.castBallot(voteId, yes);
      // Invalidate all group votes to refresh the list
      ref.invalidate(groupVotesProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> closeVote(String voteId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(groupVoteServiceProvider);
      await service.closeVote(voteId);
      ref.invalidate(groupVotesProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final groupVoteActionsProvider =
    AsyncNotifierProvider<GroupVoteActionsNotifier, void>(
  () => GroupVoteActionsNotifier(),
);
