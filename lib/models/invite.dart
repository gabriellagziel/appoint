import 'package:json_annotation/json_annotation.dart';
import 'contact.dart';

part 'invite.g.dart';

enum InviteStatus { pending, accepted, declined }

@JsonSerializable()
class Invite {
  final String id;
  final String appointmentId;
  final String inviteeId;
  final Contact inviteeContact;
  final InviteStatus status;
  final bool requiresInstallFallback;

  Invite({
    required this.id,
    required this.appointmentId,
    required this.inviteeId,
    required this.inviteeContact,
    required this.status,
    required this.requiresInstallFallback,
  });

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

  Map<String, dynamic> toJson() => _$InviteToJson(this);
}
