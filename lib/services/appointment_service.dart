import 'dart:core';

import 'package:appoint/models/appointment.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Appointment> createScheduled({
    required final String creatorId,
    required final String inviteeId,
    required final DateTime scheduledAt,
  }) async {
    final doc = _firestore.collection('appointments').doc();
    final appointment = Appointment(
      id: doc.id,
      creatorId: creatorId,
      inviteeId: inviteeId,
      scheduledAt: scheduledAt,
      type: AppointmentType.scheduled,
    );
    await doc.set(appointment.toJson());
    await NotificationService().sendNotificationToUser(
      uid: inviteeId,
      title: 'New Appointment',
      body: 'You have a new booking',
    );
    return appointment;
  }

  Future<Appointment> createOpenCallRequest({
    required final String creatorId,
    required final String inviteeId,
  }) async {
    final doc = _firestore.collection('appointments').doc();
    final callRequestId = _firestore.collection('callRequests').doc().id;
    final appointment = Appointment(
      id: doc.id,
      creatorId: creatorId,
      inviteeId: inviteeId,
      scheduledAt: DateTime.now(),
      type: AppointmentType.openCall,
      callRequestId: callRequestId,
    );
    await doc.set(appointment.toJson());
    await NotificationService().sendNotificationToUser(
      uid: inviteeId,
      title: 'New Call Request',
      body: 'You have a new call request',
    );
    return appointment;
  }

  Stream<List<Appointment>> watchMyAppointments(String userId) => _firestore
      .collection('appointments')
      .where('creatorId', isEqualTo: userId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Appointment.fromJson(doc.data()))
            .toList(),
      );
}
