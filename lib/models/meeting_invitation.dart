import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_invitation.freezed.dart';
part 'meeting_invitation.g.dart';

enum InvitationStatus {
  pending,
  accepted,
  declined,
  suggestedNewTime,
  expired,
}

enum InvitationType {
  businessToUser,
  userToBusiness,
}

@freezed
class MeetingInvitation with _$MeetingInvitation {
  const factory MeetingInvitation({
    required String id,
    required String businessId,
    required String businessName,
    required String businessLogo,
    required String userId,
    required String userName,
    required String meetingTitle,
    required String meetingDescription,
    required DateTime proposedDateTime,
    required Duration duration,
    required InvitationStatus status,
    required InvitationType type,
    String? suggestedDateTime,
    String? notes,
    required DateTime createdAt,
    DateTime? respondedAt,
    String? responseNotes,
    Map<String, dynamic>? businessProfile,
    Map<String, dynamic>? userProfile,
  }) = _MeetingInvitation;

  factory MeetingInvitation.fromJson(Map<String, dynamic> json) =>
      _$MeetingInvitationFromJson(json);

  factory MeetingInvitation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeetingInvitation.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class InvitationResponse with _$InvitationResponse {
  const factory InvitationResponse({
    required String invitationId,
    required InvitationStatus status,
    required DateTime respondedAt,
    String? notes,
    DateTime? suggestedDateTime,
  }) = _InvitationResponse;

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationResponseFromJson(json);
}

@freezed
class BusinessInvitationRequest with _$BusinessInvitationRequest {
  const factory BusinessInvitationRequest({
    required String businessId,
    required String businessName,
    required List<String> userIds,
    required String meetingTitle,
    required String meetingDescription,
    required DateTime proposedDateTime,
    required Duration duration,
    String? notes,
    Map<String, dynamic>? businessProfile,
  }) = _BusinessInvitationRequest;

  factory BusinessInvitationRequest.fromJson(Map<String, dynamic> json) =>
      _$REDACTED_TOKEN(json);
} 