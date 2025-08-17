import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class GroupShareSecurityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _random = Random();

  /// Rate limiting configuration
  static const int _maxClicksPerHour = 10;
  static const int _maxClicksPerDay = 50;
  static const Duration _clickCooldown = Duration(minutes: 5);

  /// Check if a click should be allowed based on rate limiting
  Future<bool> shouldAllowClick({
    required String meetingId,
    required String shareId,
    required String ipHash,
    String? userId,
  }) async {
    try {
      // Check hourly limit
      final hourlyClicks = await _getClickCount(
        meetingId: meetingId,
        shareId: shareId,
        ipHash: ipHash,
        userId: userId,
        duration: const Duration(hours: 1),
      );

      if (hourlyClicks >= _maxClicksPerHour) {
        await _logBlockedClick(
          meetingId: meetingId,
          shareId: shareId,
          ipHash: ipHash,
          userId: userId,
          reason: 'hourly_limit_exceeded',
        );
        return false;
      }

      // Check daily limit
      final dailyClicks = await _getClickCount(
        meetingId: meetingId,
        shareId: shareId,
        ipHash: ipHash,
        userId: userId,
        duration: const Duration(days: 1),
      );

      if (dailyClicks >= _maxClicksPerDay) {
        await _logBlockedClick(
          meetingId: meetingId,
          shareId: shareId,
          ipHash: ipHash,
          userId: userId,
          reason: 'daily_limit_exceeded',
        );
        return false;
      }

      // Check cooldown
      final lastClick = await _getLastClickTime(
        meetingId: meetingId,
        shareId: shareId,
        ipHash: ipHash,
        userId: userId,
      );

      if (lastClick != null) {
        final timeSinceLastClick = DateTime.now().difference(lastClick);
        if (timeSinceLastClick < _clickCooldown) {
          await _logBlockedClick(
            meetingId: meetingId,
            shareId: shareId,
            ipHash: ipHash,
            userId: userId,
            reason: 'cooldown_period',
          );
          return false;
        }
      }

      // Log successful click
      await _logClick(
        meetingId: meetingId,
        shareId: shareId,
        ipHash: ipHash,
        userId: userId,
      );

      return true;
    } catch (e) {
      print('Error checking click allowance: $e');
      // In case of error, allow the click but log it
      await _logClick(
        meetingId: meetingId,
        shareId: shareId,
        ipHash: ipHash,
        userId: userId,
        error: e.toString(),
      );
      return true;
    }
  }

  /// Generate a secure guest token
  String generateGuestToken({
    required String meetingId,
    required String groupId,
    Duration? expiration,
  }) {
    final exp = expiration ?? const Duration(hours: 24);
    final expiryTime = DateTime.now().add(exp).millisecondsSinceEpoch;

    final payload = {
      'meetingId': meetingId,
      'groupId': groupId,
      'exp': expiryTime,
      'type': 'guest',
      'nonce': _random.nextInt(1000000),
    };

    final jsonPayload = jsonEncode(payload);
    final hash = sha256.convert(utf8.encode(jsonPayload));

    return base64Encode(utf8.encode('$jsonPayload.$hash'));
  }

  /// Validate a guest token
  bool validateGuestToken(String token, String meetingId) {
    try {
      final decoded = utf8.decode(base64Decode(token));
      final parts = decoded.split('.');

      if (parts.length != 2) return false;

      final payload = jsonDecode(parts[0]);
      final hash = parts[1];

      // Verify hash
      final expectedHash = sha256.convert(utf8.encode(parts[0]));
      if (hash != expectedHash.toString()) return false;

      // Check expiration
      final expiryTime = payload['exp'] as int;
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) return false;

      // Check meeting ID
      if (payload['meetingId'] != meetingId) return false;

      return true;
    } catch (e) {
      print('Error validating guest token: $e');
      return false;
    }
  }

  /// Hash IP address for privacy
  String hashIpAddress(String ipAddress) {
    return sha256.convert(utf8.encode(ipAddress)).toString();
  }

  /// Get click count for rate limiting
  Future<int> _getClickCount({
    required String meetingId,
    required String shareId,
    required String ipHash,
    String? userId,
    required Duration duration,
  }) async {
    final startTime = DateTime.now().subtract(duration);

    Query query = _firestore
        .collection('analytics_share_clicks')
        .where('meetingId', isEqualTo: meetingId)
        .where('shareId', isEqualTo: shareId)
        .where('timestamp', isGreaterThan: startTime);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      query = query.where('ipHash', isEqualTo: ipHash);
    }

    final snapshot = await query.get();
    return snapshot.docs.length;
  }

  /// Get last click time for cooldown
  Future<DateTime?> _getLastClickTime({
    required String meetingId,
    required String shareId,
    required String ipHash,
    String? userId,
  }) async {
    Query query = _firestore
        .collection('analytics_share_clicks')
        .where('meetingId', isEqualTo: meetingId)
        .where('shareId', isEqualTo: shareId)
        .orderBy('timestamp', descending: true)
        .limit(1);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      query = query.where('ipHash', isEqualTo: ipHash);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) return null;

    final Map<String, dynamic> data = Map<String, dynamic>.from(
        snapshot.docs.first.data() as Map<String, dynamic>);
    final ts = data['timestamp'];
    if (ts is Timestamp) return ts.toDate();
    return null;
  }

  /// Log a click event
  Future<void> _logClick({
    required String meetingId,
    required String shareId,
    required String ipHash,
    String? userId,
    String? error,
  }) async {
    try {
      await _firestore.collection('analytics_share_clicks').add({
        'meetingId': meetingId,
        'shareId': shareId,
        'ipHash': ipHash,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'userAgent': 'Flutter App', // In real app, get from request
        'error': error,
        'type': 'click',
      });
    } catch (e) {
      print('Error logging click: $e');
    }
  }

  /// Log a blocked click
  Future<void> _logBlockedClick({
    required String meetingId,
    required String shareId,
    required String ipHash,
    String? userId,
    required String reason,
  }) async {
    try {
      await _firestore.collection('analytics_share_clicks').add({
        'meetingId': meetingId,
        'shareId': shareId,
        'ipHash': ipHash,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'userAgent': 'Flutter App',
        'blocked': true,
        'reason': reason,
        'type': 'blocked_click',
      });
    } catch (e) {
      print('Error logging blocked click: $e');
    }
  }

  /// Check if user is allowed to access meeting
  Future<bool> canAccessMeeting({
    required String meetingId,
    required String groupId,
    String? userId,
    String? guestToken,
  }) async {
    try {
      // If user is logged in, check group membership
      if (userId != null) {
        final groupDoc =
            await _firestore.collection('user_groups').doc(groupId).get();

        if (!groupDoc.exists) return false;

        final groupData = groupDoc.data()!;
        final members = List<String>.from(groupData['members'] ?? []);

        return members.contains(userId);
      }

      // If guest token provided, validate it
      if (guestToken != null) {
        return validateGuestToken(guestToken, meetingId);
      }

      // Check meeting visibility settings
      final meetingDoc =
          await _firestore.collection('meetings').doc(meetingId).get();

      if (!meetingDoc.exists) return false;

      final meetingData = meetingDoc.data()!;
      final visibility = meetingData['visibility'] ?? 'group_members_only';

      return visibility == 'public';
    } catch (e) {
      print('Error checking meeting access: $e');
      return false;
    }
  }

  /// Get security statistics for a meeting
  Future<Map<String, dynamic>> getSecurityStats(String meetingId) async {
    try {
      final clicksSnapshot = await _firestore
          .collection('analytics_share_clicks')
          .where('meetingId', isEqualTo: meetingId)
          .get();

      final blockedClicksSnapshot = await _firestore
          .collection('analytics_share_clicks')
          .where('meetingId', isEqualTo: meetingId)
          .where('blocked', isEqualTo: true)
          .get();

      final uniqueUsers = clicksSnapshot.docs
          .map((doc) => doc.data()['userId'])
          .where((userId) => userId != null)
          .toSet()
          .length;
      final uniqueIps = clicksSnapshot.docs
          .map((doc) => doc.data()['ipHash'])
          .where((ip) => ip != null)
          .toSet()
          .length;

      return {
        'totalClicks': clicksSnapshot.docs.length,
        'blockedClicks': blockedClicksSnapshot.docs.length,
        'uniqueUsers': uniqueUsers,
        'uniqueIPs': uniqueIps,
      };
    } catch (e) {
      print('Error getting security stats: $e');
      return {};
    }
  }
}

// Riverpod provider
final groupShareSecurityServiceProvider =
    Provider<GroupShareSecurityService>((ref) {
  return GroupShareSecurityService();
});
