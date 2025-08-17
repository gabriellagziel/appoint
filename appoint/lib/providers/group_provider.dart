import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_group.dart';
import '../models/group_invite.dart';
import '../services/group_sharing_service.dart';
import '../services/group_manager.dart';
import '../services/group_permission_service.dart';
import '../services/group_membership_service.dart';
import '../services/group_invite_service.dart';
import '../services/group_analytics_service.dart';
import '../services/group_notification_service.dart';
import '../services/group_security_service.dart';

// Service providers
final groupSharingServiceProvider = Provider<GroupSharingService>((ref) {
  return GroupSharingService();
});

final groupManagerProvider = Provider<GroupManager>((ref) {
  return GroupManager();
});

final groupPermissionServiceProvider = Provider<GroupPermissionService>((ref) {
  return GroupPermissionService();
});

final groupMembershipServiceProvider = Provider<GroupMembershipService>((ref) {
  return GroupMembershipService();
});

final groupInviteServiceProvider = Provider<GroupInviteService>((ref) {
  return GroupInviteService();
});

final groupAnalyticsServiceProvider = Provider<GroupAnalyticsService>((ref) {
  return GroupAnalyticsService();
});

final groupNotificationServiceProvider =
    Provider<GroupNotificationService>((ref) {
  return GroupNotificationService();
});

final groupSecurityServiceProvider = Provider<GroupSecurityService>((ref) {
  return GroupSecurityService();
});

// State providers
final userGroupsProvider =
    FutureProvider.family<List<UserGroup>, String>((ref, userId) async {
  final service = ref.read(groupSharingServiceProvider);
  return await service.getUserGroups(userId);
});

final userAdminGroupsProvider =
    FutureProvider.family<List<UserGroup>, String>((ref, userId) async {
  final service = ref.read(groupManagerProvider);
  return await service.getUserAdminGroups(userId);
});

final groupDetailsProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, groupId) async {
  final service = ref.read(groupManagerProvider);
  return await service.getGroupDetails(groupId);
});

final groupStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final service = ref.read(groupManagerProvider);
  return await service.getGroupStats(groupId);
});

final groupAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final service = ref.read(groupAnalyticsServiceProvider);
  return await service.getGroupAnalytics(groupId);
});

final userGroupAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final service = ref.read(groupAnalyticsServiceProvider);
  return await service.getUserGroupAnalytics(userId);
});

final groupInvitesProvider =
    FutureProvider.family<List<GroupInvite>, String>((ref, groupId) async {
  final service = ref.read(groupInviteServiceProvider);
  return await service.getActiveInvites(groupId);
});

final userNotificationsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, userId) async {
  final service = ref.read(groupNotificationServiceProvider);
  return await service.getUserNotifications(userId);
});

final notificationStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final service = ref.read(groupNotificationServiceProvider);
  return await service.getNotificationStats(userId);
});

final groupPermissionStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final service = ref.read(groupPermissionServiceProvider);
  return await service.getGroupPermissionStats(groupId);
});

final groupSecurityStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final service = ref.read(groupSecurityServiceProvider);
  return await service.getSecurityStats(groupId);
});

// Action providers
final createGroupProvider =
    FutureProvider.family<String, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupManagerProvider);
  final creatorId = params['creatorId'] as String;
  final name = params['name'] as String;
  final description = params['description'] as String?;
  final imageUrl = params['imageUrl'] as String?;
  final initialMembers = params['initialMembers'] as List<String>?;
  final initialAdmins = params['initialAdmins'] as List<String>?;
  final maxInviteUses = params['maxInviteUses'] as int? ?? -1;
  final inviteExpiresIn = params['inviteExpiresIn'] as Duration?;

  final group = await service.createGroup(
    creatorId: creatorId,
    name: name,
    description: description,
    imageUrl: imageUrl,
    initialMembers: initialMembers,
    initialAdmins: initialAdmins,
    maxInviteUses: maxInviteUses,
    inviteExpiresIn: inviteExpiresIn,
  );

  // Invalidate related providers
  ref.invalidate(userGroupsProvider(creatorId));
  ref.invalidate(userAdminGroupsProvider(creatorId));

  return group.id;
});

final joinGroupProvider =
    FutureProvider.family<UserGroup, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupMembershipServiceProvider);
  final inviteCode = params['inviteCode'] as String;
  final userId = params['userId'] as String;

  final group = await service.joinGroup(inviteCode, userId);

  // Invalidate related providers
  ref.invalidate(userGroupsProvider(userId));
  ref.invalidate(groupDetailsProvider(group.id));
  ref.invalidate(groupStatsProvider(group.id));

  return group;
});

final leaveGroupProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupMembershipServiceProvider);
  final groupId = params['groupId'] as String;
  final userId = params['userId'] as String;

  await service.leaveGroup(groupId, userId);

  // Invalidate related providers
  ref.invalidate(userGroupsProvider(userId));
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
});

final createInviteProvider =
    FutureProvider.family<String, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupInviteServiceProvider);
  final groupId = params['groupId'] as String;
  final creatorId = params['creatorId'] as String;
  final maxUses = params['maxUses'] as int? ?? -1;
  final expiresIn = params['expiresIn'] as Duration?;

  final inviteCode = await service.createInvite(
    groupId,
    creatorId,
    maxUses: maxUses,
    expiresIn: expiresIn,
  );

  // Invalidate related providers
  ref.invalidate(groupInvitesProvider(groupId));

  return inviteCode;
});

final updateGroupProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupManagerProvider);
  final groupId = params['groupId'] as String;
  final name = params['name'] as String?;
  final description = params['description'] as String?;
  final imageUrl = params['imageUrl'] as String?;

  await service.updateGroupDetails(
    groupId,
    name: name,
    description: description,
    imageUrl: imageUrl,
  );

  // Invalidate related providers
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
});

final addGroupMemberProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupMembershipServiceProvider);
  final groupId = params['groupId'] as String;
  final userIds = params['userIds'] as List<String>;
  final performedBy = params['performedBy'] as String;

  await service.addMembers(groupId, userIds, performedBy);

  // Invalidate related providers
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
  for (final userId in userIds) {
    ref.invalidate(userGroupsProvider(userId));
  }
});

final removeGroupMemberProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupMembershipServiceProvider);
  final groupId = params['groupId'] as String;
  final userIds = params['userIds'] as List<String>;
  final performedBy = params['performedBy'] as String;

  await service.removeMembers(groupId, userIds, performedBy);

  // Invalidate related providers
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
  for (final userId in userIds) {
    ref.invalidate(userGroupsProvider(userId));
  }
});

final addGroupAdminProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupMembershipServiceProvider);
  final groupId = params['groupId'] as String;
  final userId = params['userId'] as String;
  final performedBy = params['performedBy'] as String;

  await service.addAdmin(groupId, userId, performedBy);

  // Invalidate related providers
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
  ref.invalidate(userGroupsProvider(userId));
  ref.invalidate(userAdminGroupsProvider(userId));
});

final removeGroupAdminProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupMembershipServiceProvider);
  final groupId = params['groupId'] as String;
  final userId = params['userId'] as String;
  final performedBy = params['performedBy'] as String;

  await service.removeAdmin(groupId, userId, performedBy);

  // Invalidate related providers
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
  ref.invalidate(userGroupsProvider(userId));
  ref.invalidate(userAdminGroupsProvider(userId));
});

final deleteGroupProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupSharingServiceProvider);
  final groupId = params['groupId'] as String;
  final userId = params['userId'] as String;

  await service.deleteGroup(groupId, userId);

  // Invalidate all related providers
  ref.invalidate(userGroupsProvider(userId));
  ref.invalidate(userAdminGroupsProvider(userId));
  ref.invalidate(groupDetailsProvider(groupId));
  ref.invalidate(groupStatsProvider(groupId));
  ref.invalidate(groupAnalyticsProvider(groupId));
  ref.invalidate(groupInvitesProvider(groupId));
});

final markNotificationAsReadProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(groupNotificationServiceProvider);
  final userId = params['userId'] as String;
  final notificationId = params['notificationId'] as String;

  await service.markNotificationAsRead(userId, notificationId);

  // Invalidate related providers
  ref.invalidate(userNotificationsProvider(userId));
  ref.invalidate(notificationStatsProvider(userId));
});
