import 'dart:core';

import 'package:appoint/models/contact.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/utils/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

enum AppointmentType { scheduled, openCall }

@JsonSerializable()
class Appointment {
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
  final String id;
  final String creatorId;
  final String inviteeId;
  @DateTimeConverter()
  final DateTime scheduledAt;
  final AppointmentType type;
  final String? callRequestId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Contact? inviteeContact;
  final InviteStatus status;

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}

extension AppointmentExtension on Appointment {
  String get title => 'Appointment ${id.substring(0, 8)}';
  DateTime get dateTime => scheduledAt;
}
