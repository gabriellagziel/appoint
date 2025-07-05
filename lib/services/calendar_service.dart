import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/calendar_event.dart';

class _CacheEntry {
  final List<CalendarEvent> events;
  final DateTime expiry;

  _CacheEntry(this.events, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'calendar_events';

  final Duration _cacheTTL;
  final Map<String, _CacheEntry> _cache = {};

  CalendarService({final Duration cacheTTL = const Duration(minutes: 5)})
      : _cacheTTL = cacheTTL;

  List<CalendarEvent>? _getCached(final String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.events;
  }

  void _setCache(final String key, final List<CalendarEvent> events) {
    _cache[key] = _CacheEntry(events, DateTime.now().add(_cacheTTL));
  }

  Future<String?> _getToken(final String uid, final String provider) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarTokens')
        .doc(provider)
        .get();
    if (!doc.exists) return null;
    return doc.data()?['token'] as String?;
  }

  Future<void> syncToGoogle(final Appointment appt) async {
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

  Future<void> syncToOutlook(final Appointment appt) async {
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
      final DateTime from, final DateTime to) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final key = 'google-$uid-${from.toIso8601String()}-${to.toIso8601String()}';
    final cached = _getCached(key);
    if (cached != null) return cached;

    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarEvents')
        .where('provider', isEqualTo: 'google')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('start', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .get();
    final events =
        query.docs.map((final d) => CalendarEvent.fromJson(d.data())).toList();
    _setCache(key, events);
    return events;
  }

  Future<List<CalendarEvent>> fetchOutlookEvents(
      final DateTime from, final DateTime to) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final key =
        'outlook-$uid-${from.toIso8601String()}-${to.toIso8601String()}';
    final cached = _getCached(key);
    if (cached != null) return cached;

    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarEvents')
        .where('provider', isEqualTo: 'outlook')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('start', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .get();
    final events =
        query.docs.map((final d) => CalendarEvent.fromJson(d.data())).toList();
    _setCache(key, events);
    return events;
  }

  Stream<List<CalendarEvent>> watchEvents(final String uid,
      {required final String provider}) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('calendarEvents')
        .where('provider', isEqualTo: provider)
        .snapshots()
        .map((final snapshot) => snapshot.docs
            .map((final doc) => CalendarEvent.fromJson(doc.data()))
            .toList());
  }

  Future<void> addEvent(final CalendarEvent event) async {
    await _firestore.collection(_collection).doc(event.id).set(event.toJson());
  }

  Future<void> updateEvent(final CalendarEvent event) async {
    await _firestore
        .collection(_collection)
        .doc(event.id)
        .update(event.toJson());
  }

  Future<void> deleteEvent(final String eventId) async {
    await _firestore.collection(_collection).doc(eventId).delete();
  }

  Stream<List<CalendarEvent>> getEvents() {
    return _firestore.collection(_collection).snapshots().map(
        (final snapshot) => snapshot.docs
            .map((final doc) => CalendarEvent.fromJson(doc.data()))
            .toList());
  }

  Future<List<CalendarEvent>> getEventsByDateRange(
      final DateTime start, final DateTime end) async {
    final key = 'range-${start.toIso8601String()}-${end.toIso8601String()}';
    final cached = _getCached(key);
    if (cached != null) return cached;

    final snapshot = await _firestore
        .collection(_collection)
        .where('startTime', isGreaterThanOrEqualTo: start)
        .where('endTime', isLessThanOrEqualTo: end)
        .get();

    final events = snapshot.docs
        .map((final doc) => CalendarEvent.fromJson(doc.data()))
        .toList();
    _setCache(key, events);
    return events;
  }
}
