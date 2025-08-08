import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service for logging playtime analytics events
class PlaytimeAnalyticsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _eventsCollection = 'playtime_analytics';

  /// Log a playtime session creation attempt
  static Future<void> logSessionCreateAttempt({
    required String userId,
    required String gameId,
    required String sessionType, // virtual, live
    required bool success,
    String? errorReason,
    Map<String, dynamic>? metadata,
  }) async {
    await _logEvent(
      event: 'playtime_session_create_attempt',
      userId: userId,
      data: {
        'gameId': gameId,
        'sessionType': sessionType,
        'success': success,
        'errorReason': errorReason,
        'metadata': metadata ?? {},
      },
    );
  }

  /// Log parent approval action
  static Future<void> logParentApproval({
    required String parentId,
    required String sessionId,
    required String action, // approved, declined
    required String childUserId,
    String? reason,
  }) async {
    await _logEvent(
      event: 'playtime_parent_approval',
      userId: parentId,
      data: {
        'sessionId': sessionId,
        'action': action,
        'childUserId': childUserId,
        'reason': reason,
      },
    );
  }

  /// Log age restriction violation
  static Future<void> logAgeRestrictionViolation({
    required String userId,
    required String gameId,
    required int userAge,
    required int gameMinAge,
    required String violationType, // under_age, coppa_violation
  }) async {
    await _logEvent(
      event: 'playtime_age_restriction_violation',
      userId: userId,
      data: {
        'gameId': gameId,
        'userAge': userAge,
        'gameMinAge': gameMinAge,
        'violationType': violationType,
      },
    );
  }

  /// Log safety flag raised
  static Future<void> logSafetyFlag({
    required String sessionId,
    required String
        flagType, // inappropriate_content, user_report, auto_detection
    required String reportedBy,
    String? reason,
    Map<String, dynamic>? evidence,
  }) async {
    await _logEvent(
      event: 'playtime_safety_flag',
      userId: reportedBy,
      data: {
        'sessionId': sessionId,
        'flagType': flagType,
        'reason': reason,
        'evidence': evidence ?? {},
      },
    );
  }

  /// Log session join/leave events
  static Future<void> logSessionParticipation({
    required String userId,
    required String sessionId,
    required String action, // joined, left, kicked
    String? reason,
  }) async {
    await _logEvent(
      event: 'playtime_session_participation',
      userId: userId,
      data: {
        'sessionId': sessionId,
        'action': action,
        'reason': reason,
      },
    );
  }

  /// Log game popularity and usage
  static Future<void> logGameUsage({
    required String gameId,
    required String userId,
    required String action, // selected, started, completed
    int? sessionDuration,
  }) async {
    await _logEvent(
      event: 'playtime_game_usage',
      userId: userId,
      data: {
        'gameId': gameId,
        'action': action,
        'sessionDuration': sessionDuration,
      },
    );
  }

  /// Log parent preference changes
  static Future<void> logParentPreferenceUpdate({
    required String parentId,
    required Map<String, dynamic> oldPreferences,
    required Map<String, dynamic> newPreferences,
  }) async {
    await _logEvent(
      event: 'playtime_parent_preference_update',
      userId: parentId,
      data: {
        'oldPreferences': oldPreferences,
        'newPreferences': newPreferences,
        'changes': _calculatePreferenceChanges(oldPreferences, newPreferences),
      },
    );
  }

  /// Core logging method
  static Future<void> _logEvent({
    required String event,
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final eventData = {
        'event': event,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': _getPlatform(),
        'data': data,
      };

      // In development, also log to console
      if (kDebugMode) {
        print('📊 Playtime Analytics: $event');
        print('   User: $userId');
        print('   Data: $data');
      }

      await _firestore.collection(_eventsCollection).add(eventData);
    } catch (e) {
      // Don't let analytics failures break the app
      if (kDebugMode) {
        print('❌ Analytics logging failed: $e');
      }
    }
  }

  /// Get current platform
  static String _getPlatform() {
    if (kIsWeb) return 'web';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
    if (defaultTargetPlatform == TargetPlatform.android) return 'android';
    if (defaultTargetPlatform == TargetPlatform.macOS) return 'macos';
    if (defaultTargetPlatform == TargetPlatform.windows) return 'windows';
    return 'unknown';
  }

  /// Calculate what changed between preference sets
  static Map<String, dynamic> _calculatePreferenceChanges(
    Map<String, dynamic> oldPrefs,
    Map<String, dynamic> newPrefs,
  ) {
    final changes = <String, dynamic>{};

    for (final key in {...oldPrefs.keys, ...newPrefs.keys}) {
      final oldValue = oldPrefs[key];
      final newValue = newPrefs[key];

      if (oldValue != newValue) {
        changes[key] = {
          'from': oldValue,
          'to': newValue,
        };
      }
    }

    return changes;
  }

  /// Get analytics for a specific user (for dashboard)
  static Future<List<Map<String, dynamic>>> getUserAnalytics(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? eventType,
  }) async {
    try {
      Query query = _firestore
          .collection(_eventsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true);

      if (eventType != null) {
        query = query.where('event', isEqualTo: eventType);
      }

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.limit(100).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to fetch user analytics: $e');
      }
      return [];
    }
  }

  /// Get popular games analytics
  static Future<List<Map<String, dynamic>>> getPopularGames({
    Duration period = const Duration(days: 7),
  }) async {
    try {
      final startDate = DateTime.now().subtract(period);

      final snapshot = await _firestore
          .collection(_eventsCollection)
          .where('event', isEqualTo: 'playtime_game_usage')
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .get();

      // Aggregate game usage data
      final gameStats = <String, Map<String, dynamic>>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final gameId = data['data']['gameId'] as String?;
        final action = data['data']['action'] as String?;

        if (gameId != null) {
          gameStats[gameId] ??= {
            'gameId': gameId,
            'selections': 0,
            'starts': 0,
            'completions': 0,
            'totalDuration': 0,
          };

          if (action == 'selected') gameStats[gameId]!['selections']++;
          if (action == 'started') gameStats[gameId]!['starts']++;
          if (action == 'completed') {
            gameStats[gameId]!['completions']++;
            final duration = data['data']['sessionDuration'] as int?;
            if (duration != null) {
              gameStats[gameId]!['totalDuration'] += duration;
            }
          }
        }
      }

      // Sort by popularity (selections + starts)
      final sortedGames = gameStats.values.toList()
        ..sort((a, b) {
          final scoreA = a['selections'] + a['starts'];
          final scoreB = b['selections'] + b['starts'];
          return scoreB.compareTo(scoreA);
        });

      return sortedGames;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to fetch popular games: $e');
      }
      return [];
    }
  }
}
