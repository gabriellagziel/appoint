import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/models/usage_limit.dart';
import 'package:appoint/services/notification_service.dart';

class EnhancedPlaytimeService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NotificationService _notificationService;

  // Session tracking
  Timer? _sessionTimer;
  DateTime? _currentSessionStart;
  String? _currentSessionId;
  int _currentSessionDuration = 0;

  // Usage limits cache
  Map<String, UsageLimit> _usageLimitsCache = {};

  EnhancedPlaytimeService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required NotificationService notificationService,
  }) : _firestore = firestore, 
       _auth = auth,
       _notificationService = notificationService;

  /// Start a new playtime session
  Future<PlaytimeSession> startPlaytimeSession({
    String? activityType,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Check if user is allowed to start playtime
      await _checkPlaytimePermissions(userId);

      // Check usage limits before starting
      final canStart = await _checkUsageLimits(userId);
      if (!canStart.allowed) {
        throw PlaytimeLimitException(canStart.reason);
      }

      // End any existing session first
      if (_currentSessionId != null) {
        await endCurrentSession();
      }

      // Create new session
      final session = PlaytimeSession(
        id: _generateSessionId(),
        userId: userId,
        startTime: DateTime.now(),
        activityType: activityType ?? 'general',
        platform: Platform.operatingSystem,
        metadata: metadata ?? {},
      );

      // Save to Firestore
      await _firestore.collection('playtime_sessions').doc(session.id).set(session.toJson());

      // Update current session tracking
      _currentSessionId = session.id;
      _currentSessionStart = session.startTime;
      _currentSessionDuration = 0;

      // Start session timer
      _startSessionTimer();

      // Notify parents if required
      await _notifyParentsOfSessionStart(userId, session);

      // Log session start
      await _logPlaytimeAction('session_started', {
        'sessionId': session.id,
        'userId': userId,
        'activityType': activityType,
      });

      return session;
    } catch (e) {
      await _logPlaytimeAction('session_start_failed', {
        'userId': _auth.currentUser?.uid,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// End the current playtime session
  Future<PlaytimeSession?> endCurrentSession() async {
    if (_currentSessionId == null || _currentSessionStart == null) {
      return null;
    }

    try {
      final endTime = DateTime.now();
      final duration = endTime.difference(_currentSessionStart!);

      // Stop session timer
      _sessionTimer?.cancel();
      _sessionTimer = null;

      // Update session in Firestore
      await _firestore.collection('playtime_sessions').doc(_currentSessionId!).update({
        'endTime': Timestamp.fromDate(endTime),
        'duration': duration.inMinutes,
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the updated session
      final sessionDoc = await _firestore.collection('playtime_sessions').doc(_currentSessionId!).get();
      final session = PlaytimeSession.fromJson(sessionDoc.data()!);

      // Update daily usage statistics
      await _updateDailyUsageStats(_auth.currentUser!.uid, duration);

      // Notify parents of session end
      await _notifyParentsOfSessionEnd(_auth.currentUser!.uid, session);

      // Log session end
      await _logPlaytimeAction('session_ended', {
        'sessionId': _currentSessionId,
        'userId': _auth.currentUser?.uid,
        'duration': duration.inMinutes,
      });

      // Clear current session
      _currentSessionId = null;
      _currentSessionStart = null;
      _currentSessionDuration = 0;

      return session;
    } catch (e) {
      await _logPlaytimeAction('session_end_failed', {
        'sessionId': _currentSessionId,
        'userId': _auth.currentUser?.uid,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get current session status
  Map<String, dynamic> getCurrentSessionStatus() {
    if (_currentSessionId == null || _currentSessionStart == null) {
      return {
        'isActive': false,
        'sessionId': null,
        'duration': 0,
      };
    }

    final currentDuration = DateTime.now().difference(_currentSessionStart!);
    return {
      'isActive': true,
      'sessionId': _currentSessionId,
      'duration': currentDuration.inMinutes,
      'startTime': _currentSessionStart!.toIso8601String(),
    };
  }

  /// Set or update usage limits for a user
  Future<void> setUsageLimit(String userId, UsageLimit limit) async {
    try {
      await _firestore.collection('usage_limits').doc('${userId}_${limit.type}').set(limit.toJson());
      
      // Update cache
      _usageLimitsCache['${userId}_${limit.type}'] = limit;

      await _logPlaytimeAction('usage_limit_set', {
        'userId': userId,
        'limitType': limit.type,
        'limitValue': limit.limitMinutes,
      });
    } catch (e) {
      await _logPlaytimeAction('usage_limit_set_failed', {
        'userId': userId,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get usage limits for a user
  Future<List<UsageLimit>> getUserUsageLimits(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('usage_limits')
          .where('userId', isEqualTo: userId)
          .get();

      final limits = snapshot.docs.map((doc) => UsageLimit.fromJson(doc.data())).toList();
      
      // Update cache
      for (final limit in limits) {
        _usageLimitsCache['${userId}_${limit.type}'] = limit;
      }

      return limits;
    } catch (e) {
      debugPrint('Failed to get usage limits: $e');
      return [];
    }
  }

  /// Request additional playtime from parent
  Future<void> requestAdditionalTime(String reason, int additionalMinutes) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create request
      final requestId = _generateRequestId();
      await _firestore.collection('playtime_requests').doc(requestId).set({
        'id': requestId,
        'userId': userId,
        'reason': reason,
        'additionalMinutes': additionalMinutes,
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
        'currentSessionId': _currentSessionId,
      });

      // Notify parents
      await _notifyParentsOfTimeRequest(userId, requestId, reason, additionalMinutes);

      await _logPlaytimeAction('additional_time_requested', {
        'userId': userId,
        'requestId': requestId,
        'additionalMinutes': additionalMinutes,
      });
    } catch (e) {
      await _logPlaytimeAction('additional_time_request_failed', {
        'userId': _auth.currentUser?.uid,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Parent approves/denies additional time request
  Future<void> respondToTimeRequest(String requestId, bool approved, {String? parentNote}) async {
    try {
      final parentId = _auth.currentUser?.uid;
      if (parentId == null) throw Exception('Parent not authenticated');

      // Update request
      await _firestore.collection('playtime_requests').doc(requestId).update({
        'status': approved ? 'approved' : 'denied',
        'parentId': parentId,
        'parentNote': parentNote,
        'respondedAt': FieldValue.serverTimestamp(),
      });

      if (approved) {
        // Get request details
        final requestDoc = await _firestore.collection('playtime_requests').doc(requestId).get();
        final requestData = requestDoc.data()!;
        final childUserId = requestData['userId'];
        final additionalMinutes = requestData['additionalMinutes'] as int;

        // Grant additional time by creating temporary limit override
        await _grantAdditionalTime(childUserId, additionalMinutes);

        // Notify child of approval
        await _notificationService.sendNotificationToUser(
          childUserId,
          'Additional Playtime Approved',
          'Your parent approved ${additionalMinutes} more minutes of playtime!',
        );
      } else {
        // Notify child of denial
        final requestDoc = await _firestore.collection('playtime_requests').doc(requestId).get();
        final childUserId = requestDoc.data()!['userId'];
        
        await _notificationService.sendNotificationToUser(
          childUserId,
          'Additional Playtime Denied',
          parentNote ?? 'Your parent did not approve additional playtime at this time.',
        );
      }

      await _logPlaytimeAction('time_request_responded', {
        'requestId': requestId,
        'parentId': parentId,
        'approved': approved,
      });
    } catch (e) {
      await _logPlaytimeAction('time_request_response_failed', {
        'requestId': requestId,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get usage statistics for a user
  Future<Map<String, dynamic>> getUserUsageStats(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final end = endDate ?? DateTime.now();

      // Get sessions within date range
      final sessionsQuery = await _firestore
          .collection('playtime_sessions')
          .where('userId', isEqualTo: userId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('startTime', descending: true)
          .get();

      final sessions = sessionsQuery.docs.map((doc) => PlaytimeSession.fromJson(doc.data())).toList();

      // Calculate statistics
      final stats = _calculateUsageStatistics(sessions, start, end);
      
      return stats;
    } catch (e) {
      debugPrint('Failed to get usage stats: $e');
      return {};
    }
  }

  /// Export usage report (CSV format)
  Future<String> exportUsageReport(String userId, DateTime startDate, DateTime endDate) async {
    try {
      final sessionsQuery = await _firestore
          .collection('playtime_sessions')
          .where('userId', isEqualTo: userId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('startTime')
          .get();

      final sessions = sessionsQuery.docs.map((doc) => PlaytimeSession.fromJson(doc.data())).toList();

      // Generate CSV content
      final csvContent = _generateCSVReport(sessions, startDate, endDate);

      await _logPlaytimeAction('usage_report_exported', {
        'userId': userId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'sessionCount': sessions.length,
      });

      return csvContent;
    } catch (e) {
      await _logPlaytimeAction('usage_report_export_failed', {
        'userId': userId,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get family activity dashboard data
  Future<Map<String, dynamic>> getFamilyActivityData(String parentId) async {
    try {
      // Get all children for this parent
      final familyLinksQuery = await _firestore
          .collection('family_links')
          .where('parentId', isEqualTo: parentId)
          .where('status', isEqualTo: 'active')
          .get();

      final childrenIds = familyLinksQuery.docs
          .map((doc) => doc.data()['childId'] as String)
          .toList();

      if (childrenIds.isEmpty) {
        return {'children': [], 'totalSessions': 0, 'totalTime': 0};
      }

      // Get recent sessions for all children
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      final familyActivityData = <String, dynamic>{};
      
      for (final childId in childrenIds) {
        final childStats = await getUserUsageStats(childId, startDate: weekStart, endDate: now);
        familyActivityData[childId] = childStats;
      }

      return familyActivityData;
    } catch (e) {
      debugPrint('Failed to get family activity data: $e');
      return {};
    }
  }

  // Private methods

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      _currentSessionDuration++;
      
      // Check if any usage limits are approaching
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _checkUsageLimitWarnings(userId, _currentSessionDuration);
      }
    });
  }

  Future<UsageLimitCheck> _checkUsageLimits(String userId) async {
    try {
      final limits = await getUserUsageLimits(userId);
      final now = DateTime.now();

      for (final limit in limits) {
        final currentUsage = await _getCurrentUsage(userId, limit.type, now);
        
        if (currentUsage >= limit.limitMinutes) {
          return UsageLimitCheck(
            allowed: false,
            reason: 'Daily ${limit.type} limit of ${limit.limitMinutes} minutes reached',
            remainingTime: 0,
          );
        }
      }

      return const UsageLimitCheck(allowed: true);
    } catch (e) {
      debugPrint('Error checking usage limits: $e');
      return const UsageLimitCheck(allowed: true);
    }
  }

  Future<int> _getCurrentUsage(String userId, String limitType, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = await _firestore
        .collection('playtime_sessions')
        .where('userId', isEqualTo: userId)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    int totalMinutes = 0;
    for (final doc in query.docs) {
      final session = PlaytimeSession.fromJson(doc.data());
      if (limitType == 'all' || session.activityType == limitType) {
        totalMinutes += session.duration;
      }
    }

    return totalMinutes;
  }

  Future<void> _checkUsageLimitWarnings(String userId, int currentSessionDuration) async {
    final limits = await getUserUsageLimits(userId);
    final totalTodayUsage = await _getCurrentUsage(userId, 'all', DateTime.now());
    
    for (final limit in limits) {
      final remainingTime = limit.limitMinutes - totalTodayUsage;
      
      // Warn at 15 minutes remaining
      if (remainingTime == 15) {
        await _notificationService.sendNotificationToUser(
          userId,
          'Playtime Warning',
          'You have 15 minutes of playtime remaining today.',
        );
      }
      
      // Warn at 5 minutes remaining
      if (remainingTime == 5) {
        await _notificationService.sendNotificationToUser(
          userId,
          'Playtime Warning',
          'You have 5 minutes of playtime remaining today.',
        );
      }
      
      // Force end session if limit reached
      if (remainingTime <= 0) {
        await endCurrentSession();
        await _notificationService.sendNotificationToUser(
          userId,
          'Playtime Ended',
          'Your daily playtime limit has been reached.',
        );
      }
    }
  }

  Map<String, dynamic> _calculateUsageStatistics(List<PlaytimeSession> sessions, DateTime start, DateTime end) {
    if (sessions.isEmpty) {
      return {
        'totalSessions': 0,
        'totalMinutes': 0,
        'averageSessionLength': 0,
        'dailyAverages': <String, dynamic>{},
        'activityBreakdown': <String, dynamic>{},
        'longestSession': 0,
        'totalDays': end.difference(start).inDays,
      };
    }

    int totalMinutes = 0;
    int longestSession = 0;
    final Map<String, int> activityBreakdown = {};
    final Map<String, int> dailyTotals = {};

    for (final session in sessions) {
      totalMinutes += session.duration;
      longestSession = session.duration > longestSession ? session.duration : longestSession;
      
      // Activity breakdown
      activityBreakdown[session.activityType] = (activityBreakdown[session.activityType] ?? 0) + session.duration;
      
      // Daily totals
      final dateKey = '${session.startTime.year}-${session.startTime.month.toString().padLeft(2, '0')}-${session.startTime.day.toString().padLeft(2, '0')}';
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + session.duration;
    }

    final totalDays = end.difference(start).inDays;
    final averageSessionLength = sessions.isNotEmpty ? totalMinutes / sessions.length : 0;
    final dailyAverage = totalDays > 0 ? totalMinutes / totalDays : 0;

    return {
      'totalSessions': sessions.length,
      'totalMinutes': totalMinutes,
      'averageSessionLength': averageSessionLength.round(),
      'dailyAverage': dailyAverage.round(),
      'dailyTotals': dailyTotals,
      'activityBreakdown': activityBreakdown,
      'longestSession': longestSession,
      'totalDays': totalDays,
    };
  }

  String _generateCSVReport(List<PlaytimeSession> sessions, DateTime startDate, DateTime endDate) {
    final buffer = StringBuffer();
    
    // CSV Header
    buffer.writeln('Date,Start Time,End Time,Duration (minutes),Activity Type,Platform');
    
    // CSV Data
    for (final session in sessions) {
      final startTime = session.startTime;
      final endTime = session.endTime ?? DateTime.now();
      final date = '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}';
      final startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
      
      buffer.writeln('$date,$startTimeStr,$endTimeStr,${session.duration},${session.activityType},${session.platform}');
    }
    
    return buffer.toString();
  }

  Future<void> _checkPlaytimePermissions(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) throw Exception('User not found');

    final userData = userDoc.data()!;
    final permissions = userData['permissions'] as Map<String, dynamic>?;
    
    if (permissions?['canAccessPlaytime'] != true) {
      throw Exception('Playtime access not permitted');
    }
  }

  Future<void> _notifyParentsOfSessionStart(String userId, PlaytimeSession session) async {
    // Implementation for parent notifications
  }

  Future<void> _notifyParentsOfSessionEnd(String userId, PlaytimeSession session) async {
    // Implementation for parent notifications
  }

  Future<void> _notifyParentsOfTimeRequest(String userId, String requestId, String reason, int additionalMinutes) async {
    // Implementation for parent notifications
  }

  Future<void> _updateDailyUsageStats(String userId, Duration sessionDuration) async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    await _firestore.collection('daily_usage_stats').doc('${userId}_$dateKey').set({
      'userId': userId,
      'date': dateKey,
      'totalMinutes': FieldValue.increment(sessionDuration.inMinutes),
      'sessionCount': FieldValue.increment(1),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _grantAdditionalTime(String userId, int additionalMinutes) async {
    // Create temporary limit override
    final overrideId = _generateRequestId();
    await _firestore.collection('usage_limit_overrides').doc(overrideId).set({
      'userId': userId,
      'additionalMinutes': additionalMinutes,
      'grantedAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
      'isUsed': false,
    });
  }

  Future<void> _logPlaytimeAction(String action, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('playtime_audit_log').add({
        'action': action,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    } catch (e) {
      debugPrint('Failed to log playtime action: $e');
    }
  }

  String _generateSessionId() => 'session_${DateTime.now().millisecondsSinceEpoch}';
  String _generateRequestId() => 'request_${DateTime.now().millisecondsSinceEpoch}';
}

// Supporting classes
class UsageLimitCheck {
  final bool allowed;
  final String? reason;
  final int remainingTime;

  const UsageLimitCheck({
    required this.allowed,
    this.reason,
    this.remainingTime = 0,
  });
}

class PlaytimeLimitException implements Exception {
  final String message;
  PlaytimeLimitException(this.message);

  @override
  String toString() => 'PlaytimeLimitException: $message';
}