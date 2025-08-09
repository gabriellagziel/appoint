import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/group_invite_link.dart';
import '../analytics/analytics_service.dart';

class InviteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'invites';

  /// Get invite by token
  Future<GroupInviteLink?> getInvite(String token) async {
    try {
      final doc = await _firestore.collection(_collection).doc(token).get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      return GroupInviteLink(
        meetingId: data['meetingId'] ?? '',
        token: data['token'] ?? '',
        expiresAt: (data['expiresAt'] as Timestamp).toDate(),
        url: data['url'] ?? '',
        singleUse: data['singleUse'] ?? false,
        consumedAt: data['consumedAt'] != null
            ? (data['consumedAt'] as Timestamp).toDate()
            : null,
      );
    } catch (e) {
      AnalyticsService.track("invite_repository_error", {
        "operation": "get_invite",
        "token": token,
        "error": e.toString(),
      });
      return null;
    }
  }

  /// Create new invite
  Future<GroupInviteLink> createInvite({
    required String meetingId,
    required String token,
    required DateTime expiresAt,
    required String url,
    bool singleUse = false,
  }) async {
    try {
      final invite = GroupInviteLink(
        meetingId: meetingId,
        token: token,
        expiresAt: expiresAt,
        url: url,
        singleUse: singleUse,
      );

      await _firestore.collection(_collection).doc(token).set({
        'meetingId': meetingId,
        'token': token,
        'expiresAt': Timestamp.fromDate(expiresAt),
        'url': url,
        'singleUse': singleUse,
        'createdAt': Timestamp.now(),
      });

      AnalyticsService.track("invite_created", {
        "meetingId": meetingId,
        "token": token,
        "singleUse": singleUse,
      });

      return invite;
    } catch (e) {
      AnalyticsService.track("invite_repository_error", {
        "operation": "create_invite",
        "meetingId": meetingId,
        "error": e.toString(),
      });
      rethrow;
    }
  }

  /// Consume invite (mark as used)
  Future<void> consumeInvite(String token) async {
    try {
      await _firestore.collection(_collection).doc(token).update({
        'consumedAt': Timestamp.now(),
      });

      AnalyticsService.track("invite_consumed", {
        "token": token,
      });
    } catch (e) {
      AnalyticsService.track("invite_repository_error", {
        "operation": "consume_invite",
        "token": token,
        "error": e.toString(),
      });
      rethrow;
    }
  }

  /// Add participant to meeting
  Future<void> addParticipant({
    required String meetingId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('meetings').doc(meetingId).update({
        'participants': FieldValue.arrayUnion([userId]),
        'updatedAt': Timestamp.now(),
      });

      AnalyticsService.track("participant_added", {
        "meetingId": meetingId,
        "userId": userId,
      });
    } catch (e) {
      AnalyticsService.track("invite_repository_error", {
        "operation": "add_participant",
        "meetingId": meetingId,
        "userId": userId,
        "error": e.toString(),
      });
      rethrow;
    }
  }

  /// Get mock invite for testing/fallback
  GroupInviteLink getMockInvite(String token) {
    return GroupInviteLink(
      meetingId: 'mock_meeting_123',
      token: token,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      url: 'https://app-oint.com/join?token=$token',
      singleUse: false,
    );
  }
}
