import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appointment.dart';
import '../models/calendar_event.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'calendar_events';

  Future<String?> _getToken(String uid, String provider) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarTokens')
        .doc(provider)
        .get();
    if (!doc.exists) return null;
    return doc.data()?['token'] as String?;
  }

  Future<void> syncToGoogle(Appointment appt) async {
    await _getToken(appt.creatorId, 'google');
    final event = CalendarEvent(
      id: appt.id,
      title: 'Appointment with ${appt.inviteeId}',
      startTime: appt.scheduledAt,
      endTime: appt.scheduledAt.add(const Duration(hours: 1)),
      description: 'Synced from Appoint',
      provider: 'google',
    );
    await _firestore
        .collection('users')
        .doc(appt.creatorId)
        .collection('calendarEvents')
        .doc(event.id)
        .set(event.toJson());
  }

  Future<void> syncToOutlook(Appointment appt) async {
    await _getToken(appt.creatorId, 'outlook');
    final event = CalendarEvent(
      id: appt.id,
      title: 'Appointment with ${appt.inviteeId}',
      startTime: appt.scheduledAt,
      endTime: appt.scheduledAt.add(const Duration(hours: 1)),
      description: 'Synced from Appoint',
      provider: 'outlook',
    );
    await _firestore
        .collection('users')
        .doc(appt.creatorId)
        .collection('calendarEvents')
        .doc(event.id)
        .set(event.toJson());
  }

  Future<List<CalendarEvent>> fetchGoogleEvents(
      DateTime from, DateTime to) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarEvents')
        .where('provider', isEqualTo: 'google')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('start', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .get();
    return query.docs.map((d) => CalendarEvent.fromJson(d.data())).toList();
  }

  Future<List<CalendarEvent>> fetchOutlookEvents(
      DateTime from, DateTime to) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarEvents')
        .where('provider', isEqualTo: 'outlook')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('start', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .get();
    return query.docs.map((d) => CalendarEvent.fromJson(d.data())).toList();
  }

  Stream<List<CalendarEvent>> watchEvents(String uid,
      {required String provider}) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarEvents')
        .where('provider', isEqualTo: provider)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CalendarEvent.fromJson(doc.data()))
            .toList());
  }

  Future<void> addEvent(CalendarEvent event) async {
    await _firestore.collection(_collection).doc(event.id).set(event.toJson());
  }

  Future<void> updateEvent(CalendarEvent event) async {
    await _firestore
        .collection(_collection)
        .doc(event.id)
        .update(event.toJson());
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection(_collection).doc(eventId).delete();
  }

  Stream<List<CalendarEvent>> getEvents() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => CalendarEvent.fromJson(doc.data()))
            .toList());
  }

  Future<List<CalendarEvent>> getEventsByDateRange(
      DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('startTime', isGreaterThanOrEqualTo: start)
        .where('endTime', isLessThanOrEqualTo: end)
        .get();

    return snapshot.docs
        .map((doc) => CalendarEvent.fromJson(doc.data()))
        .toList();
  }
}
