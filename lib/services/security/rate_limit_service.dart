import 'package:cloud_firestore/cloud_firestore.dart';

/// AUDIT: Rate limiting service for share operations and guest RSVPs
class RateLimitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rate limit configurations
  static const Map<String, RateLimitConfig> _configs = {
    'create_share_link': RateLimitConfig(
      window: Duration(hours: 1),
      maxHits: 10,
      description: 'Share link creation',
    ),
    'guest_rsvp': RateLimitConfig(
      window: Duration(hours: 1),
      maxHits: 5,
      description: 'Guest RSVP submissions',
    ),
    'public_page_open': RateLimitConfig(
      window: Duration(minutes: 5),
      maxHits: 50,
      description: 'Public page opens',
    ),
    'join_group_from_share': RateLimitConfig(
      window: Duration(hours: 1),
      maxHits: 20,
      description: 'Group joins from share links',
    ),
  };

  /// Check if an action is allowed based on rate limits
  /// Returns true if allowed, false if rate limited
  Future<bool> allow(
    String actionKey,
    String subjectKey, {
    String? userId,
    String? ipAddress,
    String? userAgent,
  }) async {
    final config = _configs[actionKey];
    if (config == null) {
      throw Exception('Unknown rate limit action: $actionKey');
    }

    final now = DateTime.now();
    final windowStart = now.subtract(config.window);

    // Create a unique key for this subject
    final subjectId =
        _createSubjectId(subjectKey, userId, ipAddress, userAgent);

    // Check existing hits in the window
    final query = await _firestore
        .collection('rate_limits')
        .where('actionKey', isEqualTo: actionKey)
        .where('subjectId', isEqualTo: subjectId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(windowStart))
        .get();

    final currentHits = query.docs.length;

    if (currentHits >= config.maxHits) {
      // Log rate limit hit for monitoring
      await _logRateLimitHit(actionKey, subjectId, currentHits, config);
      return false;
    }

    // Log the action
    await _firestore.collection('rate_limits').add({
      'actionKey': actionKey,
      'subjectId': subjectId,
      'userId': userId,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'timestamp': FieldValue.serverTimestamp(),
      'config': {
        'window': config.window.inMilliseconds,
        'maxHits': config.maxHits,
        'description': config.description,
      },
    });

    return true;
  }

  /// Create a unique subject ID for rate limiting
  String _createSubjectId(
    String subjectKey,
    String? userId,
    String? ipAddress,
    String? userAgent,
  ) {
    if (userId != null) {
      return 'user:$userId:$subjectKey';
    } else if (ipAddress != null) {
      return 'ip:$ipAddress:$subjectKey';
    } else {
      return 'anonymous:$subjectKey';
    }
  }

  /// Log rate limit hits for monitoring
  Future<void> _logRateLimitHit(
    String actionKey,
    String subjectId,
    int currentHits,
    RateLimitConfig config,
  ) async {
    await _firestore.collection('rate_limit_hits').add({
      'actionKey': actionKey,
      'subjectId': subjectId,
      'currentHits': currentHits,
      'maxHits': config.maxHits,
      'window': config.window.inMilliseconds,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get current rate limit status for monitoring
  Future<RateLimitStatus> getStatus(
    String actionKey,
    String subjectKey, {
    String? userId,
    String? ipAddress,
    String? userAgent,
  }) async {
    final config = _configs[actionKey];
    if (config == null) {
      throw Exception('Unknown rate limit action: $actionKey');
    }

    final now = DateTime.now();
    final windowStart = now.subtract(config.window);
    final subjectId =
        _createSubjectId(subjectKey, userId, ipAddress, userAgent);

    final query = await _firestore
        .collection('rate_limits')
        .where('actionKey', isEqualTo: actionKey)
        .where('subjectId', isEqualTo: subjectId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(windowStart))
        .get();

    final currentHits = query.docs.length;
    final remainingHits = config.maxHits - currentHits;
    final isLimited = currentHits >= config.maxHits;

    // Calculate time until reset
    final oldestHit = query.docs.isNotEmpty
        ? query.docs
            .map((doc) => (doc.data()['timestamp'] as Timestamp).toDate())
            .reduce((a, b) => a.isBefore(b) ? a : b)
        : now;
    final resetTime = oldestHit.add(config.window);

    return RateLimitStatus(
      actionKey: actionKey,
      currentHits: currentHits,
      maxHits: config.maxHits,
      remainingHits: remainingHits,
      isLimited: isLimited,
      resetTime: resetTime,
      window: config.window,
    );
  }

  /// Clean up old rate limit records (should be called periodically)
  Future<void> cleanupOldRecords() async {
    final now = DateTime.now();
    final oldestAllowed =
        now.subtract(Duration(days: 7)); // Keep 7 days of history

    final query = await _firestore
        .collection('rate_limits')
        .where('timestamp', isLessThan: Timestamp.fromDate(oldestAllowed))
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}

/// Rate limit configuration
class RateLimitConfig {
  final Duration window;
  final int maxHits;
  final String description;

  const RateLimitConfig({
    required this.window,
    required this.maxHits,
    required this.description,
  });
}

/// Rate limit status for monitoring
class RateLimitStatus {
  final String actionKey;
  final int currentHits;
  final int maxHits;
  final int remainingHits;
  final bool isLimited;
  final DateTime resetTime;
  final Duration window;

  RateLimitStatus({
    required this.actionKey,
    required this.currentHits,
    required this.maxHits,
    required this.remainingHits,
    required this.isLimited,
    required this.resetTime,
    required this.window,
  });
}
