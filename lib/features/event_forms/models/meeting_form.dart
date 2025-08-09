import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingForm {
  final String id;
  final String meetingId;
  final String title;
  final String? description;
  final bool active;
  final bool requiredForAccept;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MeetingForm({
    required this.id,
    required this.meetingId,
    required this.title,
    this.description,
    required this.active,
    required this.requiredForAccept,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeetingForm.fromMap(String id, Map<String, dynamic> map) {
    return MeetingForm(
      id: id,
      meetingId: map['meetingId'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      active: map['active'] as bool? ?? false,
      requiredForAccept: map['requiredForAccept'] as bool? ?? false,
      createdBy: map['createdBy'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meetingId': meetingId,
      'title': title,
      'description': description,
      'active': active,
      'requiredForAccept': requiredForAccept,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  MeetingForm copyWith({
    String? id,
    String? meetingId,
    String? title,
    String? description,
    bool? active,
    bool? requiredForAccept,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeetingForm(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      title: title ?? this.title,
      description: description ?? this.description,
      active: active ?? this.active,
      requiredForAccept: requiredForAccept ?? this.requiredForAccept,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeetingForm &&
        other.id == id &&
        other.meetingId == meetingId &&
        other.title == title &&
        other.description == description &&
        other.active == active &&
        other.requiredForAccept == requiredForAccept &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      meetingId,
      title,
      description,
      active,
      requiredForAccept,
      createdBy,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'MeetingForm(id: $id, meetingId: $meetingId, title: $title, active: $active, requiredForAccept: $requiredForAccept)';
  }
}
