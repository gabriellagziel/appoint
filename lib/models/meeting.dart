// ignore_for_file: invalid_annotation_target
import 'package:appoint/utils/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

enum MeetingType {
  @JsonValue('personal')
  personal, // up to 3 participants (inclusive)
  @JsonValue('event')
  event, // 4 or more participants
}

enum MeetingStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum ParticipantRole {
  @JsonValue('organizer')
  organizer,
  @JsonValue('admin')
  admin,
  @JsonValue('participant')
  participant,
}

@freezed
class MeetingParticipant with _$MeetingParticipant {
  @JsonSerializable(explicitToJson: true)
  const factory MeetingParticipant({
    required String userId,
    required String name,
    String? email,
    String? avatarUrl,
    @Default(ParticipantRole.participant) ParticipantRole role,
    @Default(false) bool hasResponded,
    @Default(true) bool willAttend,
    @DateTimeConverter() DateTime? respondedAt,
  }) = _MeetingParticipant;

  factory MeetingParticipant.fromJson(Map<String, dynamic> json) =>
      _$MeetingParticipantFromJson(json);
}

@freezed
class Meeting with _$Meeting {
  @JsonSerializable(explicitToJson: true)
  const factory Meeting({
    required String id,
    required String organizerId,
    required String title,
    String? description,
    @DateTimeConverter()
    @JsonKey(name: 'startTime')
    required DateTime startTime,
    @DateTimeConverter()
    @JsonKey(name: 'endTime')
    required DateTime endTime,
    String? location,
    String? virtualMeetingUrl,
    @Default(<MeetingParticipant>[]) List<MeetingParticipant> participants,
    @Default(MeetingStatus.draft) MeetingStatus status,
    @DateTimeConverter() DateTime? createdAt,
    @DateTimeConverter() DateTime? updatedAt,
    
    // Event-specific features (only available for events)
    String? customFormId,
    String? checklistId,
    String? groupChatId,
    Map<String, dynamic>? eventSettings,
    
    // Business-related fields
    String? businessProfileId,
    bool? isRecurring,
    String? recurringPattern,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
}

extension MeetingExtensions on Meeting {
  /// Determines meeting type based on participant count
  /// Personal Meeting: up to 3 participants (inclusive)
  /// Event: 4 or more participants
  MeetingType get meetingType {
    final totalParticipants = participants.length + 1; // +1 for organizer
    return totalParticipants >= 4 ? MeetingType.event : MeetingType.personal;
  }

  /// Check if this meeting is an event (4+ participants)
  bool get isEvent => meetingType == MeetingType.event;

  /// Check if this meeting is a personal meeting (≤3 participants)
  bool get isPersonalMeeting => meetingType == MeetingType.personal;

  /// Get total participant count including organizer
  int get totalParticipantCount => participants.length + 1;

  /// Check if user is the organizer
  bool isOrganizer(String userId) => organizerId == userId;

  /// Check if user is an admin (organizer or admin role)
  bool isAdmin(String userId) {
    if (isOrganizer(userId)) return true;
    return participants.any((p) => p.userId == userId && p.role == ParticipantRole.admin);
  }

  /// Check if user can access event-only features
  bool canAccessEventFeatures(String userId) {
    return isEvent && isAdmin(userId);
  }

  /// Get participant by user ID
  MeetingParticipant? getParticipant(String userId) {
    try {
      return participants.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if event-specific features are available
  bool get hasCustomForm => isEvent && customFormId != null;
  bool get hasChecklist => isEvent && checklistId != null;
  bool get hasGroupChat => isEvent && groupChatId != null;

  /// Validate meeting can be created with current participant count
  String? validateMeetingCreation() {
    if (participants.isEmpty) {
      return 'Meeting must have at least one participant besides the organizer';
    }
    // Additional validation can be added here
    return null;
  }

  /// Get display name for meeting type
  String get typeDisplayName {
    return isEvent ? 'Event' : 'Meeting';
  }
}