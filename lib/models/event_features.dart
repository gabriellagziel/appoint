// ignore_for_file: invalid_annotation_target
import 'package:appoint/utils/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_features.freezed.dart';
part 'event_features.g.dart';

enum FormFieldType {
  @JsonValue('text')
  text,
  @JsonValue('textarea')
  textarea,
  @JsonValue('email')
  email,
  @JsonValue('phone')
  phone,
  @JsonValue('number')
  number,
  @JsonValue('date')
  date,
  @JsonValue('time')
  time,
  @JsonValue('select')
  select,
  @JsonValue('multiselect')
  multiselect,
  @JsonValue('radio')
  radio,
  @JsonValue('checkbox')
  checkbox,
  @JsonValue('file')
  file,
}

enum ChecklistItemStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class EventCustomFormField with _$EventCustomFormField {
  @JsonSerializable(explicitToJson: true)
  const factory EventCustomFormField({
    required String id,
    required String label,
    required FormFieldType type,
    String? placeholder,
    String? helpText,
    @Default(false) bool isRequired,
    @Default(<String>[]) List<String> options, // for select, radio, etc.
    String? validationPattern,
    String? validationMessage,
    int? maxLength,
    int? minLength,
    Map<String, dynamic>? fieldSettings,
  }) = _EventCustomFormField;

  factory EventCustomFormField.fromJson(Map<String, dynamic> json) =>
      _$EventCustomFormFieldFromJson(json);
}

@freezed
class EventCustomForm with _$EventCustomForm {
  @JsonSerializable(explicitToJson: true)
  const factory EventCustomForm({
    required String id,
    required String meetingId,
    required String title,
    String? description,
    @Default(<EventCustomFormField>[]) List<EventCustomFormField> fields,
    @Default(true) bool isActive,
    @Default(false) bool allowAnonymousSubmissions,
    @DateTimeConverter() DateTime? submissionDeadline,
    @DateTimeConverter() DateTime? createdAt,
    @DateTimeConverter() DateTime? updatedAt,
    String? createdBy,
  }) = _EventCustomForm;

  factory EventCustomForm.fromJson(Map<String, dynamic> json) =>
      _$EventCustomFormFromJson(json);
}

@freezed
class EventFormSubmission with _$EventFormSubmission {
  @JsonSerializable(explicitToJson: true)
  const factory EventFormSubmission({
    required String id,
    required String formId,
    required String meetingId,
    required Map<String, dynamic> responses,
    @DateTimeConverter() required DateTime submittedAt,
    String? userId,
    String? participantName,
    String? participantEmail,
    @Default(false) bool isAnonymous,
  }) = _EventFormSubmission;

  factory EventFormSubmission.fromJson(Map<String, dynamic> json) =>
      _$EventFormSubmissionFromJson(json);
}

@freezed
class EventChecklistItem with _$EventChecklistItem {
  @JsonSerializable(explicitToJson: true)
  const factory EventChecklistItem({
    required String id,
    required String title,
    String? description,
    @Default(ChecklistItemStatus.pending) ChecklistItemStatus status,
    String? assignedToUserId,
    String? assignedToName,
    @DateTimeConverter() DateTime? dueDate,
    @DateTimeConverter() DateTime? completedAt,
    String? completedByUserId,
    String? completedByName,
    String? notes,
    @Default(false) bool isRequired,
    int? sortOrder,
  }) = _EventChecklistItem;

  factory EventChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$EventChecklistItemFromJson(json);
}

@freezed
class EventChecklist with _$EventChecklist {
  @JsonSerializable(explicitToJson: true)
  const factory EventChecklist({
    required String id,
    required String meetingId,
    required String title,
    String? description,
    @Default(<EventChecklistItem>[]) List<EventChecklistItem> items,
    @DateTimeConverter() DateTime? createdAt,
    @DateTimeConverter() DateTime? updatedAt,
    String? createdBy,
  }) = _EventChecklist;

  factory EventChecklist.fromJson(Map<String, dynamic> json) =>
      _$EventChecklistFromJson(json);
}

@freezed
class EventSettings with _$EventSettings {
  @JsonSerializable(explicitToJson: true)
  const factory EventSettings({
    // Registration settings
    @Default(false) bool requiresRegistration,
    @Default(false) bool allowWaitlist,
    int? maxAttendees,
    @DateTimeConverter() DateTime? registrationDeadline,

    // Chat settings
    @Default(true) bool enableGroupChat,
    @Default(false) bool allowParticipantInvites,
    @Default(false) bool moderateChat,

    // Visibility settings
    @Default(false) bool isPublic,
    @Default(false) bool allowPublicRegistration,

    // Notification settings
    @Default(true) bool sendReminders,
    @Default(<int>[24, 1]) List<int> reminderHours, // hours before event

    // Recording and notes
    @Default(false) bool allowRecording,
    @Default(false) bool enableSharedNotes,

    // Custom settings
    Map<String, dynamic>? customSettings,
  }) = _EventSettings;

  factory EventSettings.fromJson(Map<String, dynamic> json) =>
      _$EventSettingsFromJson(json);
}

// Extension methods for business logic
extension EventFormValidation on EventCustomForm {
  bool get hasRequiredFields => fields.any((field) => field.isRequired);

  bool get isExpired {
    if (submissionDeadline == null) return false;
    return DateTime.now().isAfter(submissionDeadline!);
  }

  int get fieldCount => fields.length;
}

extension ChecklistProgress on EventChecklist {
  int get totalItems => items.length;

  int get completedItems => items
      .where(
        (item) => item.status == ChecklistItemStatus.completed,
      )
      .length;

  int get requiredItems => items.where((item) => item.isRequired).length;

  int get completedRequiredItems => items
      .where(
        (item) =>
            item.isRequired && item.status == ChecklistItemStatus.completed,
      )
      .length;

  double get progress => totalItems == 0 ? 0.0 : completedItems / totalItems;

  double get requiredProgress =>
      requiredItems == 0 ? 1.0 : completedRequiredItems / requiredItems;

  bool get isComplete => progress == 1.0;

  bool get allRequiredCompleted => requiredProgress == 1.0;

  List<EventChecklistItem> get pendingItems => items
      .where(
        (item) => item.status == ChecklistItemStatus.pending,
      )
      .toList();

  List<EventChecklistItem> get overDueItems {
    final now = DateTime.now();
    return items
        .where(
          (item) =>
              item.dueDate != null &&
              item.dueDate!.isBefore(now) &&
              item.status != ChecklistItemStatus.completed,
        )
        .toList();
  }
}
