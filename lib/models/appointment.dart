import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:appoint/utils/datetime_converter.dart';

import 'package:appoint/models/contact.dart';
import 'invite.dart';

part 'appointment.g.dart';

enum AppointmentType { scheduled, openCall }

@JsonSerializable()
class Appointment {
  final String id;
  final String creatorId;
  final String inviteeId;
  @DateTimeConverter()
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

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
