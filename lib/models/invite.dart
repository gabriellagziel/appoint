import 'contact.dart';

enum InviteStatus { pending, accepted, declined }

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

  factory Invite.fromMap(Map<String, dynamic> map, String id) {
    return Invite(
      id: id,
      appointmentId: map['appointmentId'] as String,
      inviteeId: map['inviteeId'] as String,
      inviteeContact:
          Contact.fromMap(Map<String, dynamic>.from(map['inviteeContact'] as Map)),
      status: InviteStatus.values.byName(map['status'] as String),
      requiresInstallFallback: map['requiresInstallFallback'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'inviteeId': inviteeId,
      'inviteeContact': inviteeContact.toMap(),
      'status': status.name,
      'requiresInstallFallback': requiresInstallFallback,
    };
  }
}
