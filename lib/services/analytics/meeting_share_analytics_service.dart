import 'package:cloud_firestore/cloud_firestore.dart';

/// AUDIT: Analytics service for tracking meeting share events
class MeetingShareAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Track share link created event
  Future<void> trackShareLinkCreated({
    required String meetingId,
    String? groupId,
    required String source,
    required String shareId,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'share_link_created',
      'meetingId': meetingId,
      'groupId': groupId,
      'source': source,
      'shareId': shareId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track share link clicked event
  Future<void> trackShareLinkClicked({
    required String shareId,
    required String meetingId,
    String? groupId,
    required String source,
    String? userId,
    String? guestToken,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'share_link_clicked',
      'shareId': shareId,
      'meetingId': meetingId,
      'groupId': groupId,
      'source': source,
      'userId': userId,
      'guestToken': guestToken,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track group member joined from share event
  Future<void> trackGroupMemberJoinedFromShare({
    required String meetingId,
    required String groupId,
    required String userId,
    String? source,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'group_member_joined_from_share',
      'meetingId': meetingId,
      'groupId': groupId,
      'userId': userId,
      'source': source,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track RSVP submitted from share event
  Future<void> trackRSVPSubmittedFromShare({
    required String meetingId,
    required String groupId,
    String? userId,
    String? guestToken,
    required String status,
    String? source,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'rsvp_submitted_from_share',
      'meetingId': meetingId,
      'groupId': groupId,
      'userId': userId,
      'guestToken': guestToken,
      'status': status,
      'source': source,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track guest token created event
  Future<void> trackGuestTokenCreated({
    required String meetingId,
    String? groupId,
    required String token,
    Duration? expiry,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'guest_token_created',
      'meetingId': meetingId,
      'groupId': groupId,
      'token': token,
      'expiry': expiry?.inMinutes,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track guest token validated event
  Future<void> trackGuestTokenValidated({
    required String meetingId,
    required String token,
    required bool isValid,
    String? reason,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'guest_token_validated',
      'meetingId': meetingId,
      'token': token,
      'isValid': isValid,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track rate limit hit event
  Future<void> trackRateLimitHit({
    required String actionKey,
    required String subjectId,
    required int currentHits,
    required int maxHits,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'rate_limit_hit',
      'actionKey': actionKey,
      'subjectId': subjectId,
      'currentHits': currentHits,
      'maxHits': maxHits,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Track public meeting page viewed event
  Future<void> trackPublicMeetingPageViewed({
    required String meetingId,
    String? groupId,
    String? shareId,
    String? source,
    String? userId,
    String? guestToken,
  }) async {
    await _firestore.collection('analytics').add({
      'event': 'public_meeting_page_viewed',
      'meetingId': meetingId,
      'groupId': groupId,
      'shareId': shareId,
      'source': source,
      'userId': userId,
      'guestToken': guestToken,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get analytics summary for a meeting
  Future<Map<String, dynamic>> getMeetingShareAnalytics(
      String meetingId) async {
    final query = await _firestore
        .collection('analytics')
        .where('meetingId', isEqualTo: meetingId)
        .where('event', whereIn: [
          'share_link_created',
          'share_link_clicked',
          'group_member_joined_from_share',
          'rsvp_submitted_from_share',
        ])
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    final events = query.docs.map((doc) => doc.data()).toList();

    return {
      'totalEvents': events.length,
      'shareLinksCreated':
          events.where((e) => e['event'] == 'share_link_created').length,
      'shareLinksClicked':
          events.where((e) => e['event'] == 'share_link_clicked').length,
      'groupMembersJoined': events
          .where((e) => e['event'] == 'group_member_joined_from_share')
          .length,
      'rsvpsSubmitted':
          events.where((e) => e['event'] == 'rsvp_submitted_from_share').length,
      'events': events,
    };
  }

  /// Get analytics summary for a group
  Future<Map<String, dynamic>> getGroupShareAnalytics(String groupId) async {
    final query = await _firestore
        .collection('analytics')
        .where('groupId', isEqualTo: groupId)
        .where('event', whereIn: [
          'share_link_created',
          'share_link_clicked',
          'group_member_joined_from_share',
          'rsvp_submitted_from_share',
        ])
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    final events = query.docs.map((doc) => doc.data()).toList();

    return {
      'totalEvents': events.length,
      'shareLinksCreated':
          events.where((e) => e['event'] == 'share_link_created').length,
      'shareLinksClicked':
          events.where((e) => e['event'] == 'share_link_clicked').length,
      'groupMembersJoined': events
          .where((e) => e['event'] == 'group_member_joined_from_share')
          .length,
      'rsvpsSubmitted':
          events.where((e) => e['event'] == 'rsvp_submitted_from_share').length,
      'events': events,
    };
  }
}
