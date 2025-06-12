import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'contact.dart';
import 'invite.dart';

enum AppointmentType { scheduled, openCall }

class Appointment {
  final String id;
  final String creatorId;
  final String inviteeId;
  final DateTime scheduledAt;
  final AppointmentType type;
  final String? callRequestId;
  final Contact? inviteeContact;
  final InviteStatus status;

  Appointment({
    required this.id,
    required this.creatorId,
    required this.inviteeId,
    required this.scheduledAt,
    required this.type,
    this.callRequestId,
    this.inviteeContact,
    this.status = InviteStatus.pending,
  });

  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      creatorId: map['creatorId'] as String,
      inviteeId: map['inviteeId'] as String,
      scheduledAt: (map['scheduledAt'] as Timestamp).toDate(),
      type: AppointmentType.values.byName(map['type'] as String),
      callRequestId: map['callRequestId'] as String?,
      inviteeContact: map['inviteeContact'] != null
          ? Contact.fromMap(Map<String, dynamic>.from(map['inviteeContact']))
          : null,
      status: map['status'] != null
          ? InviteStatus.values.byName(map['status'] as String)
          : InviteStatus.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creatorId': creatorId,
      'inviteeId': inviteeId,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'type': type.name,
      'callRequestId': callRequestId,
      'inviteeContact': inviteeContact?.toMap(),
      'status': status.name,
    };
  }
}
