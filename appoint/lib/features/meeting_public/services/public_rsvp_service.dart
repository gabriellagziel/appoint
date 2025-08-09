import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

enum RSVPStatus {
  accepted,
  declined,
  maybe,
  pending,
}

extension RSVPStatusExtension on RSVPStatus {
  String get displayName {
    switch (this) {
      case RSVPStatus.accepted:
        return 'Accepted';
      case RSVPStatus.declined:
        return 'Declined';
      case RSVPStatus.maybe:
        return 'Maybe';
      case RSVPStatus.pending:
        return 'Pending';
    }
  }

  IconData get icon {
    switch (this) {
      case RSVPStatus.accepted:
        return Icons.check_circle;
      case RSVPStatus.declined:
        return Icons.cancel;
      case RSVPStatus.maybe:
        return Icons.help;
      case RSVPStatus.pending:
        return Icons.schedule;
    }
  }

  Color get color {
    switch (this) {
      case RSVPStatus.accepted:
        return Colors.green;
      case RSVPStatus.declined:
        return Colors.red;
      case RSVPStatus.maybe:
        return Colors.orange;
      case RSVPStatus.pending:
        return Colors.grey;
    }
  }
}

class PublicRSVPService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Submit RSVP for a meeting
  Future<bool> submitRSVP({
    required String meetingId,
    required String userId,
    required RSVPStatus status,
    String? groupId,
    String? guestToken,
    String? guestName,
    String? guestEmail,
  }) async {
    try {
      final rsvpData = {
        'meetingId': meetingId,
        'status': status.name,
        'timestamp': FieldValue.serverTimestamp(),
        'type': guestToken != null ? 'guest' : 'member',
      };

      if (guestToken != null) {
        // Guest RSVP
        rsvpData['guestToken'] = guestToken;
        rsvpData['guestName'] = guestName;
        rsvpData['guestEmail'] = guestEmail;
      } else {
        // Member RSVP
        rsvpData['userId'] = userId;
        if (groupId != null) {
          rsvpData['groupId'] = groupId;
        }
      }

      await _firestore.collection('meeting_rsvps').add(rsvpData);

      // Log RSVP event for analytics
      await _logRSVPEvent(
        meetingId: meetingId,
        userId: userId,
        status: status,
        groupId: groupId,
        isGuest: guestToken != null,
      );

      return true;
    } catch (e) {
      print('Error submitting RSVP: $e');
      return false;
    }
  }

  /// Get RSVP for a user/guest
  Future<RSVPStatus?> getRSVP({
    required String meetingId,
    String? userId,
    String? guestToken,
  }) async {
    try {
      Query query = _firestore
          .collection('meeting_rsvps')
          .where('meetingId', isEqualTo: meetingId);

      if (guestToken != null) {
        query = query.where('guestToken', isEqualTo: guestToken);
      } else if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      } else {
        return null;
      }

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) return null;

      final rsvpData = snapshot.docs.first.data();
      return RSVPStatus.values.firstWhere(
        (status) => status.name == rsvpData['status'],
        orElse: () => RSVPStatus.pending,
      );
    } catch (e) {
      print('Error getting RSVP: $e');
      return null;
    }
  }

  /// Get RSVP summary for a meeting
  Future<Map<String, dynamic>> getRSVPSummary(String meetingId) async {
    try {
      final snapshot = await _firestore
          .collection('meeting_rsvps')
          .where('meetingId', isEqualTo: meetingId)
          .get();

      final rsvps = snapshot.docs.map((doc) => doc.data()).toList();

      final summary = {
        'total': rsvps.length,
        'accepted': 0,
        'declined': 0,
        'maybe': 0,
        'pending': 0,
        'members': 0,
        'guests': 0,
      };

      for (final rsvp in rsvps) {
        final status = rsvp['status'] as String;
        final type = rsvp['type'] as String;

        switch (status) {
          case 'accepted':
            summary['accepted'] = (summary['accepted'] as int) + 1;
            break;
          case 'declined':
            summary['declined'] = (summary['declined'] as int) + 1;
            break;
          case 'maybe':
            summary['maybe'] = (summary['maybe'] as int) + 1;
            break;
          case 'pending':
            summary['pending'] = (summary['pending'] as int) + 1;
            break;
        }

        if (type == 'member') {
          summary['members'] = (summary['members'] as int) + 1;
        } else {
          summary['guests'] = (summary['guests'] as int) + 1;
        }
      }

      return summary;
    } catch (e) {
      print('Error getting RSVP summary: $e');
      return {};
    }
  }

  /// Get RSVP list for a meeting
  Future<List<Map<String, dynamic>>> getRSVPList(String meetingId) async {
    try {
      final snapshot = await _firestore
          .collection('meeting_rsvps')
          .where('meetingId', isEqualTo: meetingId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'status': RSVPStatus.values.firstWhere(
            (status) => status.name == data['status'],
            orElse: () => RSVPStatus.pending,
          ),
          'type': data['type'],
          'timestamp': data['timestamp'],
          'userId': data['userId'],
          'guestName': data['guestName'],
          'guestEmail': data['guestEmail'],
          'groupId': data['groupId'],
        };
      }).toList();
    } catch (e) {
      print('Error getting RSVP list: $e');
      return [];
    }
  }

  /// Update RSVP
  Future<bool> updateRSVP({
    required String rsvpId,
    required RSVPStatus newStatus,
  }) async {
    try {
      await _firestore.collection('meeting_rsvps').doc(rsvpId).update({
        'status': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error updating RSVP: $e');
      return false;
    }
  }

  /// Delete RSVP
  Future<bool> deleteRSVP(String rsvpId) async {
    try {
      await _firestore.collection('meeting_rsvps').doc(rsvpId).delete();

      return true;
    } catch (e) {
      print('Error deleting RSVP: $e');
      return false;
    }
  }

  /// Check if user can RSVP
  Future<bool> canRSVP({
    required String meetingId,
    required String groupId,
    String? userId,
    String? guestToken,
  }) async {
    try {
      // Check if meeting allows guest RSVPs
      final meetingDoc =
          await _firestore.collection('meetings').doc(meetingId).get();

      if (!meetingDoc.exists) return false;

      final meetingData = meetingDoc.data()!;
      final allowGuestsRSVP = meetingData['allowGuestsRSVP'] ?? true;

      // If guest and guests not allowed
      if (guestToken != null && !allowGuestsRSVP) {
        return false;
      }

      // Check if user already RSVPed
      final existingRSVP = await getRSVP(
        meetingId: meetingId,
        userId: userId,
        guestToken: guestToken,
      );

      return existingRSVP == null;
    } catch (e) {
      print('Error checking RSVP permission: $e');
      return false;
    }
  }

  /// Log RSVP event for analytics
  Future<void> _logRSVPEvent({
    required String meetingId,
    required String userId,
    required RSVPStatus status,
    String? groupId,
    required bool isGuest,
  }) async {
    try {
      await _firestore.collection('analytics_rsvp_events').add({
        'meetingId': meetingId,
        'userId': userId,
        'status': status.name,
        'groupId': groupId,
        'isGuest': isGuest,
        'timestamp': FieldValue.serverTimestamp(),
        'event': 'rsvp_submitted',
      });
    } catch (e) {
      print('Error logging RSVP event: $e');
    }
  }
}

// Riverpod providers
final publicRSVPServiceProvider = Provider<PublicRSVPService>((ref) {
  return PublicRSVPService();
});

final meetingRSVPSummaryProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, meetingId) async {
  final service = ref.read(publicRSVPServiceProvider);
  return await service.getRSVPSummary(meetingId);
});

final meetingRSVPListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, meetingId) async {
  final service = ref.read(publicRSVPServiceProvider);
  return await service.getRSVPList(meetingId);
});
