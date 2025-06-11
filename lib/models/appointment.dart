import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentType { scheduled, openCall }

class Appointment {
  final String id;
  final String creatorId;
  final String inviteeId;
  final DateTime scheduledAt;
  final AppointmentType type;
  final String? callRequestId;

  Appointment({
    required this.id,
    required this.creatorId,
    required this.inviteeId,
    required this.scheduledAt,
    required this.type,
    this.callRequestId,
  });

  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      creatorId: map['creatorId'] as String,
      inviteeId: map['inviteeId'] as String,
      scheduledAt: (map['scheduledAt'] as Timestamp).toDate(),
      type: AppointmentType.values.byName(map['type'] as String),
      callRequestId: map['callRequestId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creatorId': creatorId,
      'inviteeId': inviteeId,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'type': type.name,
      'callRequestId': callRequestId,
    };
  }
}
