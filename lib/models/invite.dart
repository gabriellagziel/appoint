import 'package:json_annotation/json_annotation.dart';
import 'package:appoint/models/contact.dart';

part '../generated/models/invite.g.dart';

enum InviteStatus { pending, accepted, declined }

@JsonSerializable()
class Invite {
  final String id;
  final String appointmentId;
  final String inviteeId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Contact? inviteeContact;
  final InviteStatus status;
  final bool requiresInstallFallback;

  Invite({
    required this.id,
    required this.appointmentId,
    required this.inviteeId,
    this.inviteeContact,
    required this.status,
    required this.requiresInstallFallback,
  });

  factory Invite.fromJson(final Map<String, dynamic> json) =>
      _$InviteFromJson(json);

  Map<String, dynamic> toJson() => _$InviteToJson(this);
}
