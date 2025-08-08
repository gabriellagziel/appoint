import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/saved_group.dart';
import '../../../models/group_usage_insight.dart';
import '../../../models/user_group.dart';
import 'saved_groups_service.dart';

class GroupSuggestion {
  final UserGroup group;
  final double score;
  final SavedGroup? savedGroup;
  final GroupInsightSummary? insights;

  const GroupSuggestion({
    required this.group,
    required this.score,
    this.savedGroup,
    this.insights,
  });
}

class GroupSuggestionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SavedGroupsService _savedGroupsService = SavedGroupsService();

  /// Get suggested groups for a user
  Future<List<GroupSuggestion>> getSuggestedGroups(String userId,
      {int limit = 5}) async {
    try {
      // Get user's groups
      final userGroups = await _getUserGroups(userId);
      if (userGroups.isEmpty) return [];

      // Get saved groups for scoring
      final savedGroups = await _savedGroupsService.getSavedGroups(userId);
      final savedGroupsMap = {for (var sg in savedGroups) sg.groupId: sg};

      // Calculate scores and create suggestions
      final suggestions = <GroupSuggestion>[];

      for (final group in userGroups) {
        final savedGroup = savedGroupsMap[group.id];

        final score = _scoreGroup(
          useCount: savedGroup?.useCount ?? 0,
          sinceLastUse: savedGroup != null
              ? DateTime.now().difference(savedGroup.lastUsedAt)
              : const Duration(days: 365),
          convRate: 0.3, // Default conversion rate
          pinned: savedGroup?.pinned ?? false,
        );

        suggestions.add(GroupSuggestion(
          group: group,
          score: score,
          savedGroup: savedGroup,
        ));
      }

      // Sort by score (highest first) and take top results
      suggestions.sort((a, b) => b.score.compareTo(a.score));

      return suggestions.take(limit).toList();
    } catch (e) {
      print('Error getting suggested groups: $e');
      return [];
    }
  }

  /// Score a group based on usage patterns
  double _scoreGroup({
    required int useCount,
    required Duration sinceLastUse,
    required double convRate,
    required bool pinned,
  }) {
    const useCountWeight = 0.4;
    const recencyWeight = 0.25;
    const convRateWeight = 0.25;
    const pinnedBonus = 0.1;

    // Normalize use count (0-10 uses = 0-1 score)
    final normalizedUseCount = (useCount / 10.0).clamp(0.0, 1.0);

    // Normalize recency (0 days = 1.0, 7 days = 0.6, 30 days = 0.2, >90 = 0.05)
    final daysSinceLastUse = sinceLastUse.inDays;
    final normalizedRecency = _normalizeRecency(daysSinceLastUse);

    // Normalize conversion rate (0-1)
    final normalizedConvRate = convRate.clamp(0.0, 1.0);

    // Calculate weighted score
    final weightedScore = (normalizedUseCount * useCountWeight) +
        (normalizedRecency * recencyWeight) +
        (normalizedConvRate * convRateWeight);

    // Add pinned bonus
    final finalScore = weightedScore + (pinned ? pinnedBonus : 0.0);

    return finalScore.clamp(0.0, 1.0);
  }

  /// Normalize recency score
  double _normalizeRecency(int days) {
    if (days == 0) return 1.0;
    if (days <= 7) return 0.6;
    if (days <= 30) return 0.2;
    if (days <= 90) return 0.05;
    return 0.01;
  }

  /// Get user's groups
  Future<List<UserGroup>> _getUserGroups(String userId) async {
    try {
      final query = await _firestore
          .collection('user_groups')
          .where('members', arrayContains: userId)
          .where('isActive', isEqualTo: true)
          .get();

      return query.docs
          .map((doc) => UserGroup.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting user groups: $e');
      return [];
    }
  }

  /// Log a usage event
  Future<void> logUsageEvent({
    required String userId,
    required String groupId,
    required GroupUsageEvent event,
    String? meetingId,
    String? source,
  }) async {
    try {
      await _firestore.collection('analytics_group_usage').add({
        'userId': userId,
        'groupId': groupId,
        'meetingId': meetingId,
        'event': event.name,
        'source': source,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error logging usage event: $e');
    }
  }
}
