import 'dart:async';
import 'package:appoint/models/meeting_details.dart';
import 'package:appoint/models/location.dart';
import 'package:appoint/services/location_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();

  static const String _meetingsCollection = 'meetings';
  static const String _participantStatusCollection = 'participant_status';

  /// Create a new meeting
  Future<MeetingDetails> createMeeting(MeetingDetails meeting) async {
    final doc = _firestore.collection(_meetingsCollection).doc();
    final meetingWithId = meeting.copyWith(id: doc.id);
    
    await doc.set(meetingWithId.toJson());
    
    // Schedule reminders for all participants
    await _scheduleReminders(meetingWithId);
    
    // Create chat for group meetings
    if (meetingWithId.isGroupEvent) {
      await _createMeetingChat(meetingWithId);
    }
    
    // Send invitations to participants
    await _sendInvitations(meetingWithId);
    
    return meetingWithId;
  }

  /// Get meeting details
  Future<MeetingDetails?> getMeeting(String meetingId) async {
    final doc = await _firestore.collection(_meetingsCollection).doc(meetingId).get();
    if (!doc.exists) return null;
    
    final data = doc.data()!;
    return MeetingDetails.fromJson({...data, 'id': doc.id});
  }

  /// Watch meeting details with real-time updates
  Stream<MeetingDetails?> watchMeeting(String meetingId) {
    return _firestore
        .collection(_meetingsCollection)
        .doc(meetingId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      return MeetingDetails.fromJson({...data, 'id': doc.id});
    });
  }

  /// Update participant status
  Future<void> updateParticipantStatus({
    required String meetingId,
    required String userId,
    required ParticipantStatus status,
    String? lateReason,
    DateTime? estimatedArrival,
  }) async {
    final meetingRef = _firestore.collection(_meetingsCollection).doc(meetingId);
    
    await _firestore.runTransaction((transaction) async {
      final meetingDoc = await transaction.get(meetingRef);
      if (!meetingDoc.exists) throw Exception('Meeting not found');
      
      final data = meetingDoc.data()!;
      final participants = (data['participants'] as List)
          .map((p) => MeetingParticipant.fromJson(p))
          .toList();
      
      final participantIndex = participants.indexWhere((p) => p.userId == userId);
      if (participantIndex == -1) throw Exception('Participant not found');
      
      participants[participantIndex] = participants[participantIndex].copyWith(
        status: status,
        isRunningLate: status == ParticipantStatus.late,
        lateReason: lateReason,
        estimatedArrival: estimatedArrival,
        lastSeenAt: DateTime.now(),
      );
      
      transaction.update(meetingRef, {
        'participants': participants.map((p) => p.toJson()).toList(),
      });
    });
    
    // Notify other participants of status change
    await REDACTED_TOKEN(meetingId, userId, status);
  }

  /// Mark participant as running late
  Future<void> markAsRunningLate({
    required String meetingId,
    required String userId,
    String? reason,
    int? delayMinutes,
  }) async {
    final meeting = await getMeeting(meetingId);
    if (meeting == null) throw Exception('Meeting not found');
    
    final estimatedArrival = delayMinutes != null 
        ? meeting.scheduledAt.add(Duration(minutes: delayMinutes))
        : null;
    
    await updateParticipantStatus(
      meetingId: meetingId,
      userId: userId,
      status: ParticipantStatus.late,
      lateReason: reason,
      estimatedArrival: estimatedArrival,
    );
  }

  /// Check if user will be late based on location
  Future<bool> checkIfUserWillBeLate(String meetingId, String userId) async {
    final meeting = await getMeeting(meetingId);
    if (meeting == null || meeting.location == null) return false;
    
    final currentPosition = await _locationService.getCurrentLocation();
    if (currentPosition == null) return false;
    
    // Calculate travel time to meeting location
    final distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      meeting.location!.latitude,
      meeting.location!.longitude,
    );
    
    // Estimate travel time (assuming walking speed of 5 km/h)
    const walkingSpeedKmh = 5.0;
    final travelTimeMinutes = (distanceInMeters / 1000) / walkingSpeedKmh * 60;
    
    final timeUntilMeeting = meeting.scheduledAt.difference(DateTime.now()).inMinutes;
    
    // Consider late if travel time is more than 80% of remaining time
    return travelTimeMinutes > (timeUntilMeeting * 0.8);
  }

  /// Schedule pre-meeting location check
  Future<void> scheduleLocationCheck(MeetingDetails meeting) async {
    if (!meeting.isLocationTrackingEnabled || meeting.location == null) return;
    
    final checkTime = meeting.scheduledAt.subtract(Duration(minutes: meeting.reminderMinutes));
    
    await _notificationService.scheduleNotification(
      title: 'Meeting Location Check',
      body: 'Checking if you\'ll arrive on time for ${meeting.title}',
      scheduledDate: checkTime,
      payload: 'location_check:${meeting.id}',
    );
  }

  /// Get user's meetings for a date range
  Stream<List<MeetingDetails>> watchUserMeetings(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var query = _firestore
        .collection(_meetingsCollection)
        .where('participants', arrayContains: {'userId': userId});
    
    if (startDate != null) {
      query = query.where('scheduledAt', isGreaterThanOrEqualTo: startDate);
    }
    
    if (endDate != null) {
      query = query.where('scheduledAt', isLessThanOrEqualTo: endDate);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MeetingDetails.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  /// Send invitations to meeting participants
  Future<void> _sendInvitations(MeetingDetails meeting) async {
    for (final participant in meeting.participants) {
      await _notificationService.sendNotificationToUser(
        uid: participant.userId,
        title: 'Meeting Invitation',
        body: 'You\'re invited to ${meeting.title} on ${_formatDateTime(meeting.scheduledAt)}',
        data: {
          'type': 'meeting_invitation',
          'meetingId': meeting.id,
          'action': 'view_meeting',
        },
      );
    }
  }

  /// Schedule reminders for meeting
  Future<void> _scheduleReminders(MeetingDetails meeting) async {
    final reminderTime = meeting.scheduledAt.subtract(Duration(minutes: meeting.reminderMinutes));
    
    for (final participant in meeting.participants) {
      await _notificationService.scheduleNotification(
        title: 'Upcoming Meeting',
        body: '${meeting.title} starts in ${meeting.reminderMinutes} minutes',
        scheduledDate: reminderTime,
        payload: 'meeting_reminder:${meeting.id}:${participant.userId}',
      );
    }
  }

  /// Create chat for group meetings
  Future<void> _createMeetingChat(MeetingDetails meeting) async {
    final chatDoc = _firestore.collection('chats').doc();
    
    await chatDoc.set({
      'id': chatDoc.id,
      'name': '${meeting.title} - Chat',
      'type': 'meeting',
      'meetingId': meeting.id,
      'participants': meeting.participants.map((p) => p.userId).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': meeting.creatorId,
    });
    
    // Update meeting with chat ID
    await _firestore.collection(_meetingsCollection).doc(meeting.id).update({
      'chatId': chatDoc.id,
    });
  }

  /// Notify participants of status changes
  Future<void> REDACTED_TOKEN(
    String meetingId,
    String userId,
    ParticipantStatus status,
  ) async {
    final meeting = await getMeeting(meetingId);
    if (meeting == null) return;
    
    final participant = meeting.participants.firstWhere((p) => p.userId == userId);
    final otherParticipants = meeting.participants.where((p) => p.userId != userId);
    
    String statusMessage;
    switch (status) {
      case ParticipantStatus.confirmed:
        statusMessage = '${participant.displayName} confirmed attendance';
        break;
      case ParticipantStatus.declined:
        statusMessage = '${participant.displayName} declined the meeting';
        break;
      case ParticipantStatus.late:
        statusMessage = '${participant.displayName} is running late';
        break;
      case ParticipantStatus.arrived:
        statusMessage = '${participant.displayName} has arrived';
        break;
      default:
        return;
    }
    
    for (final otherParticipant in otherParticipants) {
      await _notificationService.sendNotificationToUser(
        uid: otherParticipant.userId,
        title: 'Meeting Update',
        body: statusMessage,
        data: {
          'type': 'participant_status_change',
          'meetingId': meetingId,
          'participantId': userId,
          'status': status.name,
        },
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Background job to check locations before meetings
  static Future<void> checkUpcomingMeetingLocations() async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final oneHourFromNow = now.add(const Duration(hours: 1));
    
    // Get meetings starting in the next hour with location tracking enabled
    final meetingsQuery = await firestore
        .collection('meetings')
        .where('scheduledAt', isGreaterThan: now)
        .where('scheduledAt', isLessThan: oneHourFromNow)
        .where('isLocationTrackingEnabled', isEqualTo: true)
        .get();
    
    final meetingService = MeetingService();
    
    for (final doc in meetingsQuery.docs) {
      final meeting = MeetingDetails.fromJson({...doc.data(), 'id': doc.id});
      
      for (final participant in meeting.participants) {
        if (participant.status == ParticipantStatus.confirmed) {
          final willBeLate = await meetingService.checkIfUserWillBeLate(
            meeting.id,
            participant.userId,
          );
          
          if (willBeLate) {
            // Send smart reminder about potential lateness
            await NotificationService().sendNotificationToUser(
              uid: participant.userId,
              title: 'You might be late!',
              body: 'Based on your location, you might be late for ${meeting.title}. Tap to update your status or get directions.',
              data: {
                'type': 'late_warning',
                'meetingId': meeting.id,
                'action': 'show_late_options',
              },
            );
          }
        }
      }
    }
  }
}