import 'package:cloud_firestore/cloud_firestore.dart';

enum FormSubmissionStatus {
  draft,
  submitted,
}

class FormSubmission {
  final String id;
  final String meetingId;
  final String formId;
  final String? userId; // null for guests
  final String? guestToken; // for guest submissions
  final FormSubmissionStatus status;
  final Map<String, dynamic> answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FormSubmission({
    required this.id,
    required this.meetingId,
    required this.formId,
    this.userId,
    this.guestToken,
    required this.status,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FormSubmission.fromMap(String id, Map<String, dynamic> map) {
    return FormSubmission(
      id: id,
      meetingId: map['meetingId'] as String,
      formId: map['formId'] as String,
      userId: map['userId'] as String?,
      guestToken: map['guestToken'] as String?,
      status: _parseStatus(map['status'] as String),
      answers: Map<String, dynamic>.from(map['answers'] as Map),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meetingId': meetingId,
      'formId': formId,
      'userId': userId,
      'guestToken': guestToken,
      'status': status.name,
      'answers': answers,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static FormSubmissionStatus _parseStatus(String status) {
    switch (status) {
      case 'draft':
        return FormSubmissionStatus.draft;
      case 'submitted':
        return FormSubmissionStatus.submitted;
      default:
        return FormSubmissionStatus.draft;
    }
  }

  FormSubmission copyWith({
    String? id,
    String? meetingId,
    String? formId,
    String? userId,
    String? guestToken,
    FormSubmissionStatus? status,
    Map<String, dynamic>? answers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FormSubmission(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      formId: formId ?? this.formId,
      userId: userId ?? this.userId,
      guestToken: guestToken ?? this.guestToken,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isDraft => status == FormSubmissionStatus.draft;
  bool get isSubmitted => status == FormSubmissionStatus.submitted;
  bool get isGuestSubmission => guestToken != null;
  bool get isMemberSubmission => userId != null;

  // Get answer for a specific field
  dynamic getAnswer(String fieldId) {
    return answers[fieldId];
  }

  // Set answer for a specific field
  FormSubmission withAnswer(String fieldId, dynamic value) {
    final newAnswers = Map<String, dynamic>.from(answers);
    if (value == null || value.toString().isEmpty) {
      newAnswers.remove(fieldId);
    } else {
      newAnswers[fieldId] = value;
    }

    return copyWith(
      answers: newAnswers,
      updatedAt: DateTime.now(),
    );
  }

  // Check if submission is complete (all required fields filled)
  bool isComplete(List<FormFieldDef> fields) {
    for (final field in fields) {
      if (field.required) {
        final answer = getAnswer(field.id);
        if (answer == null || answer.toString().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  // Get validation errors
  List<String> getValidationErrors(List<FormFieldDef> fields) {
    final errors = <String>[];

    for (final field in fields) {
      final answer = getAnswer(field.id);
      final error = field.validateValue(answer);
      if (error != null) {
        errors.add(error);
      }
    }

    return errors;
  }

  // Get visible fields based on current answers
  List<FormFieldDef> getVisibleFields(List<FormFieldDef> fields) {
    return fields.where((field) => field.isVisible(answers)).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormSubmission &&
        other.id == id &&
        other.meetingId == meetingId &&
        other.formId == formId &&
        other.userId == userId &&
        other.guestToken == guestToken &&
        other.status == status &&
        other.answers == answers &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      meetingId,
      formId,
      userId,
      guestToken,
      status,
      answers,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'FormSubmission(id: $id, meetingId: $meetingId, formId: $formId, status: $status, answers: $answers)';
  }
}
