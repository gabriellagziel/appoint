import 'dart:core';

import 'package:appoint/models/meeting.dart';
import 'package:appoint/models/event_features.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  // Collections
  CollectionReference get _meetingsCollection => _firestore.collection('meetings');
  CollectionReference get _formsCollection => _firestore.collection('eventForms');
  CollectionReference get _checklistsCollection => _firestore.collection('eventChecklists');
  CollectionReference get _formSubmissionsCollection => _firestore.collection('eventFormSubmissions');

  /// Creates a new meeting with automatic type determination based on participant count
  Future<Meeting> createMeeting({
    required String organizerId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? virtualMeetingUrl,
    List<MeetingParticipant> participants = const [],
    String? businessProfileId,
  }) async {
    // Validate business rules
    final totalParticipants = participants.length + 1; // +1 for organizer
    if (totalParticipants < 2) {
      throw Exception('Meeting must have at least one participant besides the organizer');
    }

    final doc = _meetingsCollection.doc();
    final meeting = Meeting(
      id: doc.id,
      organizerId: organizerId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      virtualMeetingUrl: virtualMeetingUrl,
      participants: participants,
      status: MeetingStatus.scheduled,
      businessProfileId: businessProfileId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Additional validation
    final validationError = meeting.validateMeetingCreation();
    if (validationError != null) {
      throw Exception(validationError);
    }

    await doc.set(meeting.toJson());

    // Send notifications to participants
    await _notifyParticipants(meeting, 'Meeting Created', 
        'You have been invited to ${meeting.typeDisplayName.toLowerCase()}: $title');

    return meeting;
  }

  /// Adds participants to a meeting and automatically updates meeting type
  Future<Meeting> addParticipants(String meetingId, List<MeetingParticipant> newParticipants) async {
    final meetingDoc = await _meetingsCollection.doc(meetingId).get();
    if (!meetingDoc.exists) {
      throw Exception('Meeting not found');
    }

    final meeting = Meeting.fromJson(meetingDoc.data()! as Map<String, dynamic>);
    final updatedParticipants = List<MeetingParticipant>.from(meeting.participants);

    // Check for duplicates and add new participants
    for (final newParticipant in newParticipants) {
      if (!updatedParticipants.any((p) => p.userId == newParticipant.userId)) {
        updatedParticipants.add(newParticipant);
      }
    }

    final updatedMeeting = meeting.copyWith(
      participants: updatedParticipants,
      updatedAt: DateTime.now(),
    );

    // If meeting type changed from personal to event, initialize event features
    if (meeting.isPersonalMeeting && updatedMeeting.isEvent) {
      await _initializeEventFeatures(updatedMeeting);
    }

    await _meetingsCollection.doc(meetingId).update(updatedMeeting.toJson());

    // Notify new participants
    await _notifySpecificParticipants(updatedMeeting, newParticipants, 
        'Meeting Invitation', 'You have been added to ${updatedMeeting.typeDisplayName.toLowerCase()}: ${meeting.title}');

    return updatedMeeting;
  }

  /// Removes participants from a meeting and automatically updates meeting type
  Future<Meeting> removeParticipants(String meetingId, List<String> userIds) async {
    final meetingDoc = await _meetingsCollection.doc(meetingId).get();
    if (!meetingDoc.exists) {
      throw Exception('Meeting not found');
    }

    final meeting = Meeting.fromJson(meetingDoc.data()! as Map<String, dynamic>);
    final updatedParticipants = meeting.participants
        .where((p) => !userIds.contains(p.userId))
        .toList();

    // Validate minimum participants
    if (updatedParticipants.length < 1) {
      throw Exception('Meeting must have at least one participant besides the organizer');
    }

    final updatedMeeting = meeting.copyWith(
      participants: updatedParticipants,
      updatedAt: DateTime.now(),
    );

    // If meeting type changed from event to personal, clean up event features
    if (meeting.isEvent && updatedMeeting.isPersonalMeeting) {
      await _cleanupEventFeatures(updatedMeeting);
    }

    await _meetingsCollection.doc(meetingId).update(updatedMeeting.toJson());

    return updatedMeeting;
  }

  /// Creates a custom form for an event (only available for events)
  Future<EventCustomForm> createEventForm({
    required String meetingId,
    required String title,
    String? description,
    required List<EventCustomFormField> fields,
    required String createdBy,
    bool allowAnonymousSubmissions = false,
    DateTime? submissionDeadline,
  }) async {
    // Verify this is an event
    final meeting = await getMeeting(meetingId);
    if (!meeting.isEvent) {
      throw Exception('Custom forms are only available for events (4+ participants)');
    }

    // Verify user has admin permissions
    if (!meeting.canAccessEventFeatures(createdBy)) {
      throw Exception('Only event organizers and admins can create forms');
    }

    final doc = _formsCollection.doc();
    final form = EventCustomForm(
      id: doc.id,
      meetingId: meetingId,
      title: title,
      description: description,
      fields: fields,
      allowAnonymousSubmissions: allowAnonymousSubmissions,
      submissionDeadline: submissionDeadline,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: createdBy,
    );

    await doc.set(form.toJson());

    // Update meeting with form reference
    await _meetingsCollection.doc(meetingId).update({
      'customFormId': doc.id,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return form;
  }

  /// Creates a checklist for an event (only available for events)
  Future<EventChecklist> createEventChecklist({
    required String meetingId,
    required String title,
    String? description,
    required List<EventChecklistItem> items,
    required String createdBy,
  }) async {
    // Verify this is an event
    final meeting = await getMeeting(meetingId);
    if (!meeting.isEvent) {
      throw Exception('Checklists are only available for events (4+ participants)');
    }

    // Verify user has admin permissions
    if (!meeting.canAccessEventFeatures(createdBy)) {
      throw Exception('Only event organizers and admins can create checklists');
    }

    final doc = _checklistsCollection.doc();
    final checklist = EventChecklist(
      id: doc.id,
      meetingId: meetingId,
      title: title,
      description: description,
      items: items,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: createdBy,
    );

    await doc.set(checklist.toJson());

    // Update meeting with checklist reference
    await _meetingsCollection.doc(meetingId).update({
      'checklistId': doc.id,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return checklist;
  }

  /// Enables group chat for an event (only available for events)
  Future<String> enableEventGroupChat(String meetingId, String userId) async {
    final meeting = await getMeeting(meetingId);
    if (!meeting.isEvent) {
      throw Exception('Group chat is only available for events (4+ participants)');
    }

    if (!meeting.canAccessEventFeatures(userId)) {
      throw Exception('Only event organizers and admins can enable group chat');
    }

    // Create group chat (this would integrate with your existing chat system)
    final chatId = 'event_chat_${meetingId}_${DateTime.now().millisecondsSinceEpoch}';
    
    // Update meeting with chat reference
    await _meetingsCollection.doc(meetingId).update({
      'groupChatId': chatId,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // TODO: Integrate with existing chat service to create actual chat room
    // await _chatService.createGroupChat(chatId, meeting.participants);

    return chatId;
  }

  /// Gets a meeting by ID
  Future<Meeting> getMeeting(String meetingId) async {
    final doc = await _meetingsCollection.doc(meetingId).get();
    if (!doc.exists) {
      throw Exception('Meeting not found');
    }
    return Meeting.fromJson(doc.data()! as Map<String, dynamic>);
  }

  /// Gets meetings for a user (as organizer or participant)
  Stream<List<Meeting>> getUserMeetings(String userId) {
    return _meetingsCollection
        .where('participants', arrayContains: {'userId': userId})
        .snapshots()
        .asyncMap((snapshot) async {
      final participantMeetings = snapshot.docs
          .map((doc) => Meeting.fromJson(doc.data()! as Map<String, dynamic>))
          .toList();

      // Also get meetings where user is organizer
      final organizerSnapshot = await _meetingsCollection
          .where('organizerId', isEqualTo: userId)
          .get();
      
      final organizerMeetings = organizerSnapshot.docs
          .map((doc) => Meeting.fromJson(doc.data()! as Map<String, dynamic>))
          .toList();

      // Combine and deduplicate
      final allMeetings = <String, Meeting>{};
      for (final meeting in participantMeetings) {
        allMeetings[meeting.id] = meeting;
      }
      for (final meeting in organizerMeetings) {
        allMeetings[meeting.id] = meeting;
      }

      return allMeetings.values.toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    });
  }

  /// Gets event form by meeting ID
  Future<EventCustomForm?> getEventForm(String meetingId) async {
    final snapshot = await _formsCollection
        .where('meetingId', isEqualTo: meetingId)
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) return null;
    
    return EventCustomForm.fromJson(snapshot.docs.first.data()! as Map<String, dynamic>);
  }

  /// Gets event checklist by meeting ID
  Future<EventChecklist?> getEventChecklist(String meetingId) async {
    final snapshot = await _checklistsCollection
        .where('meetingId', isEqualTo: meetingId)
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) return null;
    
    return EventChecklist.fromJson(snapshot.docs.first.data()! as Map<String, dynamic>);
  }

  /// Validates if a user can access event features
  Future<bool> canUserAccessEventFeatures(String meetingId, String userId) async {
    final meeting = await getMeeting(meetingId);
    return meeting.canAccessEventFeatures(userId);
  }

  /// Gets analytics data for meetings vs events
  Future<Map<String, dynamic>> getMeetingAnalytics(String userId, {DateTime? startDate, DateTime? endDate}) async {
    Query query = _meetingsCollection.where('organizerId', isEqualTo: userId);
    
    if (startDate != null) {
      query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('createdAt', isLessThanOrEqualTo: endDate);
    }

    final snapshot = await query.get();
    final meetings = snapshot.docs
        .map((doc) => Meeting.fromJson(doc.data()! as Map<String, dynamic>))
        .toList();

    final personalMeetings = meetings.where((m) => m.isPersonalMeeting).toList();
    final events = meetings.where((m) => m.isEvent).toList();

    return {
      'totalMeetings': meetings.length,
      'personalMeetings': personalMeetings.length,
      'events': events.length,
      'averageParticipantsPersonal': personalMeetings.isEmpty ? 0 : 
          personalMeetings.map((m) => m.totalParticipantCount).reduce((a, b) => a + b) / personalMeetings.length,
      'averageParticipantsEvents': events.isEmpty ? 0 : 
          events.map((m) => m.totalParticipantCount).reduce((a, b) => a + b) / events.length,
      'eventsWithForms': events.where((e) => e.hasCustomForm).length,
      'eventsWithChecklists': events.where((e) => e.hasChecklist).length,
      'eventsWithGroupChat': events.where((e) => e.hasGroupChat).length,
    };
  }

  // Private helper methods

  Future<void> _initializeEventFeatures(Meeting meeting) async {
    // Called when a meeting becomes an event (crosses 4 participant threshold)
    // Initialize default event settings if needed
    final eventSettings = EventSettings();
    
    await _meetingsCollection.doc(meeting.id).update({
      'eventSettings': eventSettings.toJson(),
    });
  }

  Future<void> _cleanupEventFeatures(Meeting meeting) async {
    // Called when an event becomes a personal meeting (drops below 4 participants)
    // Clean up event-only features
    
    final updates = <String, dynamic>{
      'customFormId': FieldValue.delete(),
      'checklistId': FieldValue.delete(),
      'groupChatId': FieldValue.delete(),
      'eventSettings': FieldValue.delete(),
    };

    await _meetingsCollection.doc(meeting.id).update(updates);

    // TODO: Also clean up associated forms, checklists, etc.
    if (meeting.customFormId != null) {
      await _formsCollection.doc(meeting.customFormId!).delete();
    }
    if (meeting.checklistId != null) {
      await _checklistsCollection.doc(meeting.checklistId!).delete();
    }
  }

  Future<void> _notifyParticipants(Meeting meeting, String title, String body) async {
    for (final participant in meeting.participants) {
      await _notificationService.sendNotificationToUser(
        participant.userId,
        title,
        body,
      );
    }
  }

  Future<void> _notifySpecificParticipants(
    Meeting meeting, 
    List<MeetingParticipant> participants, 
    String title, 
    String body
  ) async {
    for (final participant in participants) {
      await _notificationService.sendNotificationToUser(
        participant.userId,
        title,
        body,
      );
    }
  }
}