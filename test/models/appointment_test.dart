import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/contact.dart';
import 'package:appoint/models/invite.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Appointment Model', () {
    test('should correctly create a scheduled appointment', () {
      final appointment = Appointment(
        id: 'appointment-123',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
      );

      expect(appointment.id, 'appointment-123');
      expect(appointment.creatorId, 'user-1');
      expect(appointment.inviteeId, 'user-2');
      expect(appointment.scheduledAt, DateTime(2025, 6, 18, 10));
      expect(appointment.type, AppointmentType.scheduled);
      expect(appointment.status, InviteStatus.pending);
      expect(appointment.callRequestId, isNull);
      expect(appointment.inviteeContact, isNull);
    });

    test('should correctly create an open call appointment', () {
      final appointment = Appointment(
        id: 'appointment-456',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 14, 30),
        type: AppointmentType.openCall,
        callRequestId: 'call-request-123',
        status: InviteStatus.accepted,
      );

      expect(appointment.type, AppointmentType.openCall);
      expect(appointment.callRequestId, 'call-request-123');
      expect(appointment.status, InviteStatus.accepted);
    });

    test('should be able to convert to JSON and back', () {
      final appointment = Appointment(
        id: 'appointment-123',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
      );

      json = appointment.toJson();
      newAppointment = Appointment.fromJson(json);

      expect(newAppointment.id, appointment.id);
      expect(newAppointment.creatorId, appointment.creatorId);
      expect(newAppointment.inviteeId, appointment.inviteeId);
      expect(newAppointment.scheduledAt, appointment.scheduledAt);
      expect(newAppointment.type, appointment.type);
      expect(newAppointment.status, appointment.status);
    });

    test('should handle appointment with contact information', () {
      const contact = Contact(
        id: 'contact-123',
        displayName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
      );

      final appointment = Appointment(
        id: 'appointment-123',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
        inviteeContact: contact,
      );

      expect(appointment.inviteeContact, contact);
      expect(appointment.inviteeContact?.displayName, 'John Doe');
    });

    test('should handle different appointment statuses', () {
      final pendingAppointment = Appointment(
        id: 'appointment-1',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
      );

      final acceptedAppointment = Appointment(
        id: 'appointment-2',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
        status: InviteStatus.accepted,
      );

      final declinedAppointment = Appointment(
        id: 'appointment-3',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
        status: InviteStatus.declined,
      );

      expect(pendingAppointment.status, InviteStatus.pending);
      expect(acceptedAppointment.status, InviteStatus.accepted);
      expect(declinedAppointment.status, InviteStatus.declined);
    });

    test('should handle different appointment types', () {
      final scheduledAppointment = Appointment(
        id: 'appointment-1',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.scheduled,
      );

      final openCallAppointment = Appointment(
        id: 'appointment-2',
        creatorId: 'user-1',
        inviteeId: 'user-2',
        scheduledAt: DateTime(2025, 6, 18, 10),
        type: AppointmentType.openCall,
      );

      expect(scheduledAppointment.type, AppointmentType.scheduled);
      expect(openCallAppointment.type, AppointmentType.openCall);
    });
  });
}
