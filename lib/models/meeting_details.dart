import 'package:appoint/models/location.dart';
import 'package:appoint/models/contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_details.freezed.dart';
part 'meeting_details.g.dart';

enum MeetingType { oneOnOne, group, event }
enum ParticipantStatus { pending, confirmed, declined, late, arrived }
enum ParticipantRole { host, coHost, participant }

@freezed
class MeetingDetails with _$MeetingDetails {
  const factory MeetingDetails({
    required String id,
    required String title,
    required String description,
    required DateTime scheduledAt,
    required DateTime endTime,
    required MeetingType type,
    required String creatorId,
    required List<MeetingParticipant> participants,
    Location? location,
    String? chatId,
    @Default([]) List<CustomForm> customForms,
    @Default([]) List<MeetingAttachment> attachments,
    @Default(false) bool isLocationTrackingEnabled,
    @Default(60) int reminderMinutes, // Default 1 hour reminder
    Map<String, dynamic>? metadata,
  }) = _MeetingDetails;

  factory MeetingDetails.fromJson(Map<String, dynamic> json) =>
      _$MeetingDetailsFromJson(json);
}

@freezed
class MeetingParticipant with _$MeetingParticipant {
  const factory MeetingParticipant({
    required String userId,
    required String email,
    required String displayName,
    @Default(ParticipantStatus.pending) ParticipantStatus status,
    @Default(ParticipantRole.participant) ParticipantRole role,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? lastSeenAt,
    Location? currentLocation,
    @Default(false) bool isRunningLate,
    String? lateReason,
    DateTime? estimatedArrival,
  }) = _MeetingParticipant;

  factory MeetingParticipant.fromJson(Map<String, dynamic> json) =>
      _$MeetingParticipantFromJson(json);
}

@freezed
class CustomForm with _$CustomForm {
  const factory CustomForm({
    required String id,
    required String title,
    required String description,
    required CustomFormType type,
    required List<FormField> fields,
    @Default(false) bool isRequired,
    DateTime? deadline,
  }) = _CustomForm;

  factory CustomForm.fromJson(Map<String, dynamic> json) =>
      _$CustomFormFromJson(json);
}

enum CustomFormType { rsvp, poll, survey, preferences }

@freezed
class FormField with _$FormField {
  const factory FormField({
    required String id,
    required String label,
    required FormFieldType type,
    @Default(false) bool isRequired,
    List<String>? options, // For select, radio, checkbox
    String? placeholder,
    String? defaultValue,
  }) = _FormField;

  factory FormField.fromJson(Map<String, dynamic> json) =>
      _$FormFieldFromJson(json);
}

enum FormFieldType { text, email, phone, select, radio, checkbox, textarea }

@freezed
class MeetingAttachment with _$MeetingAttachment {
  const factory MeetingAttachment({
    required String id,
    required String name,
    required String url,
    required String type, // image, document, etc.
    required int size,
    required String uploadedBy,
    required DateTime uploadedAt,
  }) = _MeetingAttachment;

  factory MeetingAttachment.fromJson(Map<String, dynamic> json) =>
      _$MeetingAttachmentFromJson(json);
}

extension MeetingDetailsExtension on MeetingDetails {
  bool get isGroupEvent => type == MeetingType.group || type == MeetingType.event;
  bool get hasCustomForms => customForms.isNotEmpty;
  bool get isLocationEnabled => location != null;
  int get participantCount => participants.length;
  
  List<MeetingParticipant> get confirmedParticipants => 
      participants.where((p) => p.status == ParticipantStatus.confirmed).toList();
  
  List<MeetingParticipant> get lateParticipants => 
      participants.where((p) => p.isRunningLate).toList();
  
  bool get hasHost => participants.any((p) => p.role == ParticipantRole.host);
  
  MeetingParticipant? get host => 
      participants.where((p) => p.role == ParticipantRole.host).firstOrNull;
  
  Duration get timeUntilMeeting => scheduledAt.difference(DateTime.now());
  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());
  bool get isActive => DateTime.now().isAfter(scheduledAt) && DateTime.now().isBefore(endTime);
  bool get isCompleted => DateTime.now().isAfter(endTime);
}