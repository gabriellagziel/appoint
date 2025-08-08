import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/group_suggestions_service.dart';
import '../services/saved_groups_service.dart';
import '../../../models/saved_group.dart';
import '../../../models/group_usage_insight.dart';
import '../../../models/user_group.dart';
import '../../auth/providers/auth_provider.dart';

// Service providers
final savedGroupsServiceProvider = Provider<SavedGroupsService>((ref) {
  return SavedGroupsService();
});

final groupSuggestionsServiceProvider =
    Provider<GroupSuggestionsService>((ref) {
  return GroupSuggestionsService();
});

// Saved groups providers
final savedGroupsProvider =
    FutureProvider.family<List<SavedGroup>, String>((ref, userId) async {
  final service = ref.read(savedGroupsServiceProvider);
  return await service.getSavedGroupsSorted(userId);
});

final currentUserSavedGroupsProvider =
    FutureProvider<List<SavedGroup>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState == null || authState.user == null) {
    return [];
  }
  final savedGroupsAsync = ref.watch(savedGroupsProvider(authState.user!.uid));
  return savedGroupsAsync.when(
    data: (groups) => groups,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Group suggestions providers
final suggestedGroupsProvider =
    FutureProvider.family<List<GroupSuggestion>, String>((ref, userId) async {
  final service = ref.read(groupSuggestionsServiceProvider);
  return await service.getSuggestedGroups(userId);
});

final currentUserSuggestedGroupsProvider =
    FutureProvider<List<GroupSuggestion>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState == null || authState.user == null) {
    return [];
  }
  final suggestionsAsync =
      ref.watch(suggestedGroupsProvider(authState.user!.uid));
  return suggestionsAsync.when(
    data: (suggestions) => suggestions,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Action providers
final pinGroupProvider =
    FutureProvider.family<bool, ({String userId, String groupId, bool pinned})>(
        (ref, params) async {
  final service = ref.read(savedGroupsServiceProvider);
  return await service.pinGroup(params.userId, params.groupId, params.pinned);
});

final aliasGroupProvider = FutureProvider.family<bool,
    ({String userId, String groupId, String alias})>((ref, params) async {
  final service = ref.read(savedGroupsServiceProvider);
  return await service.aliasGroup(params.userId, params.groupId, params.alias);
});

final touchGroupProvider =
    FutureProvider.family<bool, ({String userId, String groupId})>(
        (ref, params) async {
  final service = ref.read(savedGroupsServiceProvider);
  return await service.touchGroup(params.userId, params.groupId);
});

final saveGroupProvider =
    FutureProvider.family<bool, ({String userId, String groupId})>(
        (ref, params) async {
  final service = ref.read(savedGroupsServiceProvider);
  return await service.saveGroup(params.userId, params.groupId);
});

final removeSavedGroupProvider =
    FutureProvider.family<bool, ({String userId, String groupId})>(
        (ref, params) async {
  final service = ref.read(savedGroupsServiceProvider);
  return await service.removeSavedGroup(params.userId, params.groupId);
});

// Analytics providers
final logUsageEventProvider = FutureProvider.family<
    void,
    ({
      String userId,
      String groupId,
      GroupUsageEvent event,
      String? meetingId,
      String? source,
    })>((ref, params) async {
  final service = ref.read(groupSuggestionsServiceProvider);
  await service.logUsageEvent(
    userId: params.userId,
    groupId: params.groupId,
    event: params.event,
    meetingId: params.meetingId,
    source: params.source,
  );
});

// Feature flags
final featureGroupSuggestionsProvider = StateProvider<bool>((ref) => true);
final featureSavedGroupsProvider = StateProvider<bool>((ref) => true);

// Combined providers for UI
final groupSuggestionsBarProvider =
    FutureProvider<List<GroupSuggestion>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState == null || authState.user == null) {
    return [];
  }
  final suggestionsAsync =
      ref.watch(suggestedGroupsProvider(authState.user!.uid));
  return suggestionsAsync.when(
    data: (suggestions) => suggestions,
    loading: () => [],
    error: (_, __) => [],
  );
});

final savedGroupsChipsProvider = FutureProvider<List<SavedGroup>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState == null || authState.user == null) {
    return [];
  }
  final savedGroupsAsync = ref.watch(savedGroupsProvider(authState.user!.uid));
  return savedGroupsAsync.when(
    data: (groups) => groups.take(3).toList(), // Show only first 3 for chips
    loading: () => [],
    error: (_, __) => [],
  );
});
