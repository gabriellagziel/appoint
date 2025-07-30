// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventCustomFormFieldImpl _$$EventCustomFormFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCustomFormFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      type: $enumDecode(_$FormFieldTypeEnumMap, json['type']),
      placeholder: json['placeholder'] as String?,
      helpText: json['help_text'] as String?,
      isRequired: json['is_required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      validationPattern: json['validation_pattern'] as String?,
      validationMessage: json['validation_message'] as String?,
      maxLength: (json['max_length'] as num?)?.toInt(),
      minLength: (json['min_length'] as num?)?.toInt(),
      fieldSettings: json['field_settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$EventCustomFormFieldImplToJson(
    _$EventCustomFormFieldImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'label': instance.label,
    'type': _$FormFieldTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('placeholder', instance.placeholder);
  writeNotNull('help_text', instance.helpText);
  val['is_required'] = instance.isRequired;
  val['options'] = instance.options;
  writeNotNull('validation_pattern', instance.validationPattern);
  writeNotNull('validation_message', instance.validationMessage);
  writeNotNull('max_length', instance.maxLength);
  writeNotNull('min_length', instance.minLength);
  writeNotNull('field_settings', instance.fieldSettings);
  return val;
}

const _$FormFieldTypeEnumMap = {
  FormFieldType.text: 'text',
  FormFieldType.textarea: 'textarea',
  FormFieldType.email: 'email',
  FormFieldType.phone: 'phone',
  FormFieldType.number: 'number',
  FormFieldType.date: 'date',
  FormFieldType.time: 'time',
  FormFieldType.select: 'select',
  FormFieldType.multiselect: 'multiselect',
  FormFieldType.radio: 'radio',
  FormFieldType.checkbox: 'checkbox',
  FormFieldType.file: 'file',
};

_$EventCustomFormImpl _$$EventCustomFormImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCustomFormImpl(
      id: json['id'] as String,
      meetingId: json['meeting_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) =>
                  EventCustomFormField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EventCustomFormField>[],
      isActive: json['is_active'] as bool? ?? true,
      allowAnonymousSubmissions:
          json['allow_anonymous_submissions'] as bool? ?? false,
      submissionDeadline: _$JsonConverterFromJson<String, DateTime>(
          json['submission_deadline'], const DateTimeConverter().fromJson),
      createdAt: _$JsonConverterFromJson<String, DateTime>(
          json['created_at'], const DateTimeConverter().fromJson),
      updatedAt: _$JsonConverterFromJson<String, DateTime>(
          json['updated_at'], const DateTimeConverter().fromJson),
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$EventCustomFormImplToJson(
    _$EventCustomFormImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'meeting_id': instance.meetingId,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  val['fields'] = instance.fields.map((e) => e.toJson()).toList();
  val['is_active'] = instance.isActive;
  val['allow_anonymous_submissions'] = instance.allowAnonymousSubmissions;
  writeNotNull(
      'submission_deadline',
      _$JsonConverterToJson<String, DateTime>(
          instance.submissionDeadline, const DateTimeConverter().toJson));
  writeNotNull(
      'created_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.createdAt, const DateTimeConverter().toJson));
  writeNotNull(
      'updated_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.updatedAt, const DateTimeConverter().toJson));
  writeNotNull('created_by', instance.createdBy);
  return val;
}

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$EventFormSubmissionImpl _$$EventFormSubmissionImplFromJson(
        Map<String, dynamic> json) =>
    _$EventFormSubmissionImpl(
      id: json['id'] as String,
      formId: json['form_id'] as String,
      meetingId: json['meeting_id'] as String,
      responses: json['responses'] as Map<String, dynamic>,
      submittedAt:
          const DateTimeConverter().fromJson(json['submitted_at'] as String),
      userId: json['user_id'] as String?,
      participantName: json['participant_name'] as String?,
      participantEmail: json['participant_email'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventFormSubmissionImplToJson(
    _$EventFormSubmissionImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'form_id': instance.formId,
    'meeting_id': instance.meetingId,
    'responses': instance.responses,
    'submitted_at': const DateTimeConverter().toJson(instance.submittedAt),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull('participant_name', instance.participantName);
  writeNotNull('participant_email', instance.participantEmail);
  val['is_anonymous'] = instance.isAnonymous;
  return val;
}

_$EventChecklistItemImpl _$$EventChecklistItemImplFromJson(
        Map<String, dynamic> json) =>
    _$EventChecklistItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status:
          $enumDecodeNullable(_$ChecklistItemStatusEnumMap, json['status']) ??
              ChecklistItemStatus.pending,
      assignedToUserId: json['assigned_to_user_id'] as String?,
      assignedToName: json['assigned_to_name'] as String?,
      dueDate: _$JsonConverterFromJson<String, DateTime>(
          json['due_date'], const DateTimeConverter().fromJson),
      completedAt: _$JsonConverterFromJson<String, DateTime>(
          json['completed_at'], const DateTimeConverter().fromJson),
      completedByUserId: json['completed_by_user_id'] as String?,
      completedByName: json['completed_by_name'] as String?,
      notes: json['notes'] as String?,
      isRequired: json['is_required'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventChecklistItemImplToJson(
    _$EventChecklistItemImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  val['status'] = _$ChecklistItemStatusEnumMap[instance.status]!;
  writeNotNull('assigned_to_user_id', instance.assignedToUserId);
  writeNotNull('assigned_to_name', instance.assignedToName);
  writeNotNull(
      'due_date',
      _$JsonConverterToJson<String, DateTime>(
          instance.dueDate, const DateTimeConverter().toJson));
  writeNotNull(
      'completed_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.completedAt, const DateTimeConverter().toJson));
  writeNotNull('completed_by_user_id', instance.completedByUserId);
  writeNotNull('completed_by_name', instance.completedByName);
  writeNotNull('notes', instance.notes);
  val['is_required'] = instance.isRequired;
  writeNotNull('sort_order', instance.sortOrder);
  return val;
}

const _$ChecklistItemStatusEnumMap = {
  ChecklistItemStatus.pending: 'pending',
  ChecklistItemStatus.inProgress: 'in_progress',
  ChecklistItemStatus.completed: 'completed',
  ChecklistItemStatus.cancelled: 'cancelled',
};

_$EventChecklistImpl _$$EventChecklistImplFromJson(Map<String, dynamic> json) =>
    _$EventChecklistImpl(
      id: json['id'] as String,
      meetingId: json['meeting_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => EventChecklistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EventChecklistItem>[],
      createdAt: _$JsonConverterFromJson<String, DateTime>(
          json['created_at'], const DateTimeConverter().fromJson),
      updatedAt: _$JsonConverterFromJson<String, DateTime>(
          json['updated_at'], const DateTimeConverter().fromJson),
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$EventChecklistImplToJson(
    _$EventChecklistImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'meeting_id': instance.meetingId,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  val['items'] = instance.items.map((e) => e.toJson()).toList();
  writeNotNull(
      'created_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.createdAt, const DateTimeConverter().toJson));
  writeNotNull(
      'updated_at',
      _$JsonConverterToJson<String, DateTime>(
          instance.updatedAt, const DateTimeConverter().toJson));
  writeNotNull('created_by', instance.createdBy);
  return val;
}

_$EventSettingsImpl _$$EventSettingsImplFromJson(Map<String, dynamic> json) =>
    _$EventSettingsImpl(
      requiresRegistration: json['requires_registration'] as bool? ?? false,
      allowWaitlist: json['allow_waitlist'] as bool? ?? false,
      maxAttendees: (json['max_attendees'] as num?)?.toInt(),
      registrationDeadline: _$JsonConverterFromJson<String, DateTime>(
          json['registration_deadline'], const DateTimeConverter().fromJson),
      enableGroupChat: json['enable_group_chat'] as bool? ?? true,
      allowParticipantInvites:
          json['allow_participant_invites'] as bool? ?? false,
      moderateChat: json['moderate_chat'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? false,
      allowPublicRegistration:
          json['allow_public_registration'] as bool? ?? false,
      sendReminders: json['send_reminders'] as bool? ?? true,
      reminderHours: (json['reminder_hours'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[24, 1],
      allowRecording: json['allow_recording'] as bool? ?? false,
      enableSharedNotes: json['enable_shared_notes'] as bool? ?? false,
      customSettings: json['custom_settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$EventSettingsImplToJson(_$EventSettingsImpl instance) {
  final val = <String, dynamic>{
    'requires_registration': instance.requiresRegistration,
    'allow_waitlist': instance.allowWaitlist,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('max_attendees', instance.maxAttendees);
  writeNotNull(
      'registration_deadline',
      _$JsonConverterToJson<String, DateTime>(
          instance.registrationDeadline, const DateTimeConverter().toJson));
  val['enable_group_chat'] = instance.enableGroupChat;
  val['allow_participant_invites'] = instance.allowParticipantInvites;
  val['moderate_chat'] = instance.moderateChat;
  val['is_public'] = instance.isPublic;
  val['allow_public_registration'] = instance.allowPublicRegistration;
  val['send_reminders'] = instance.sendReminders;
  val['reminder_hours'] = instance.reminderHours;
  val['allow_recording'] = instance.allowRecording;
  val['enable_shared_notes'] = instance.enableSharedNotes;
  writeNotNull('custom_settings', instance.customSettings);
  return val;
}
