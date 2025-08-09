import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/location.dart';
import '../analytics/analytics_service.dart';

class MeetingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'meetings';

  /// Get meeting by ID
  Future<Map<String, dynamic>?> getMeeting(String meetingId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(meetingId).get();

      if (!doc.exists) return null;

      final data = doc.data()!;

      // Convert location data if present
      if (data['location'] != null) {
        final locationData = data['location'] as Map<String, dynamic>;
        data['location'] = Location.fromMap(locationData);
      }

      return data;
    } catch (e) {
      AnalyticsService.track("meeting_repository_error", {
        "operation": "get_meeting",
        "meetingId": meetingId,
        "error": e.toString(),
      });
      return null;
    }
  }

  /// Create new meeting
  Future<void> createMeeting({
    required String meetingId,
    required Map<String, dynamic> meetingData,
  }) async {
    try {
      // Convert Location object to map for Firestore
      final data = Map<String, dynamic>.from(meetingData);
      if (data['location'] is Location) {
        data['location'] = (data['location'] as Location).toMap();
      }

      await _firestore.collection(_collection).doc(meetingId).set({
        ...data,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      AnalyticsService.track("meeting_created", {
        "meetingId": meetingId,
        "title": data['title'],
      });
    } catch (e) {
      AnalyticsService.track("meeting_repository_error", {
        "operation": "create_meeting",
        "meetingId": meetingId,
        "error": e.toString(),
      });
      rethrow;
    }
  }

  /// Update meeting
  Future<void> updateMeeting({
    required String meetingId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      // Convert Location object to map for Firestore
      final data = Map<String, dynamic>.from(updates);
      if (data['location'] is Location) {
        data['location'] = (data['location'] as Location).toMap();
      }

      await _firestore.collection(_collection).doc(meetingId).update({
        ...data,
        'updatedAt': Timestamp.now(),
      });

      AnalyticsService.track("meeting_updated", {
        "meetingId": meetingId,
      });
    } catch (e) {
      AnalyticsService.track("meeting_repository_error", {
        "operation": "update_meeting",
        "meetingId": meetingId,
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
      await _firestore.collection(_collection).doc(meetingId).update({
        'participants': FieldValue.arrayUnion([userId]),
        'updatedAt': Timestamp.now(),
      });

      AnalyticsService.track("meeting_participant_added", {
        "meetingId": meetingId,
        "userId": userId,
      });
    } catch (e) {
      AnalyticsService.track("meeting_repository_error", {
        "operation": "add_participant",
        "meetingId": meetingId,
        "userId": userId,
        "error": e.toString(),
      });
      rethrow;
    }
  }

  /// Get meetings for user
  Future<List<Map<String, dynamic>>> getUserMeetings(String userId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('participants', arrayContains: userId)
          .orderBy('time', descending: false)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        // Convert location data if present
        if (data['location'] != null) {
          final locationData = data['location'] as Map<String, dynamic>;
          data['location'] = Location.fromMap(locationData);
        }

        return data;
      }).toList();
    } catch (e) {
      AnalyticsService.track("meeting_repository_error", {
        "operation": "get_user_meetings",
        "userId": userId,
        "error": e.toString(),
      });
      return [];
    }
  }

  /// Get mock meeting for testing/fallback
  Map<String, dynamic> getMockMeeting(String meetingId) {
    return {
      'id': meetingId,
      'title': 'Mock Meeting',
      'description': 'This is a mock meeting for testing',
      'time': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      'location': const Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name: 'Mock Location',
        address: '123 Mock Street, San Francisco, CA',
      ),
      'participants': ['user_1', 'user_2'],
      'type': 'meeting',
    };
  }
}
