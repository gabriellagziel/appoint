import 'package:appoint/models/contact.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite.g.dart';

enum InviteStatus { pending, accepted, declined }

@JsonSerializable()
class Invite {
  Invite({
    required this.id,
    required this.appointmentId,
    required this.inviteeId,
    required this.status,
    required this.requiresInstallFallback,
    this.inviteeContact,
  });

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
  final String id;
  final String appointmentId;
  final String inviteeId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Contact? inviteeContact;
  final InviteStatus status;
  final bool requiresInstallFallback;

  Map<String, dynamic> toJson() => _$InviteToJson(this);
}
