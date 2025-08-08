import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MeetingChecklist {
  final String id;
  final String meetingId;
  final String groupId;
  final String title;
  final String createdBy;
  final DateTime createdAt;
  final bool isArchived;

  const MeetingChecklist({
    required this.id,
    required this.meetingId,
    required this.groupId,
    required this.title,
    required this.createdBy,
    required this.createdAt,
    this.isArchived = false,
  });

  factory MeetingChecklist.fromMap(String id, Map<String, dynamic> map) {
    return MeetingChecklist(
      id: id,
      meetingId: map['meetingId'] ?? '',
      groupId: map['groupId'] ?? '',
      title: map['title'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isArchived: map['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meetingId': meetingId,
      'groupId': groupId,
      'title': title,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'isArchived': isArchived,
    };
  }

  MeetingChecklist copyWith({
    String? id,
    String? meetingId,
    String? groupId,
    String? title,
    String? createdBy,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return MeetingChecklist(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingChecklist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          meetingId == other.meetingId;

  @override
  int get hashCode => id.hashCode ^ meetingId.hashCode;

  @override
  String toString() {
    return 'MeetingChecklist(id: $id, title: $title, isArchived: $isArchived)';
  }
}

enum ChecklistItemPriority { low, medium, high }

class ChecklistItem {
  final String id;
  final String listId;
  final String text;
  final String createdBy;
  final String? assigneeId;
  final DateTime? dueAt;
  final ChecklistItemPriority priority;
  final bool isDone;
  final String? doneBy;
  final DateTime? doneAt;
  final int orderIndex;

  const ChecklistItem({
    required this.id,
    required this.listId,
    required this.text,
    required this.createdBy,
    this.assigneeId,
    this.dueAt,
    this.priority = ChecklistItemPriority.medium,
    this.isDone = false,
    this.doneBy,
    this.doneAt,
    required this.orderIndex,
  });

  factory ChecklistItem.fromMap(String id, Map<String, dynamic> map) {
    return ChecklistItem(
      id: id,
      listId: map['listId'] ?? '',
      text: map['text'] ?? '',
      createdBy: map['createdBy'] ?? '',
      assigneeId: map['assigneeId'],
      dueAt: map['dueAt'] != null ? (map['dueAt'] as Timestamp).toDate() : null,
      priority: _parsePriority(map['priority'] ?? 'medium'),
      isDone: map['isDone'] ?? false,
      doneBy: map['doneBy'],
      doneAt: map['doneAt'] != null ? (map['doneAt'] as Timestamp).toDate() : null,
      orderIndex: map['orderIndex'] ?? 0,
    );
  }

  static ChecklistItemPriority _parsePriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return ChecklistItemPriority.high;
      case 'low':
        return ChecklistItemPriority.low;
      default:
        return ChecklistItemPriority.medium;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'listId': listId,
      'text': text,
      'createdBy': createdBy,
      'assigneeId': assigneeId,
      'dueAt': dueAt != null ? Timestamp.fromDate(dueAt!) : null,
      'priority': priority.name,
      'isDone': isDone,
      'doneBy': doneBy,
      'doneAt': doneAt != null ? Timestamp.fromDate(doneAt!) : null,
      'orderIndex': orderIndex,
    };
  }

  ChecklistItem copyWith({
    String? id,
    String? listId,
    String? text,
    String? createdBy,
    String? assigneeId,
    DateTime? dueAt,
    ChecklistItemPriority? priority,
    bool? isDone,
    String? doneBy,
    DateTime? doneAt,
    int? orderIndex,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      text: text ?? this.text,
      createdBy: createdBy ?? this.createdBy,
      assigneeId: assigneeId ?? this.assigneeId,
      dueAt: dueAt ?? this.dueAt,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      doneBy: doneBy ?? this.doneBy,
      doneAt: doneAt ?? this.doneAt,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  bool get isOverdue => dueAt != null && dueAt!.isBefore(DateTime.now()) && !isDone;
  bool get isDueSoon => dueAt != null && 
      dueAt!.isAfter(DateTime.now()) && 
      dueAt!.difference(DateTime.now()).inDays <= 3 && 
      !isDone;

  String get priorityDisplayName {
    switch (priority) {
      case ChecklistItemPriority.high:
        return 'High';
      case ChecklistItemPriority.medium:
        return 'Medium';
      case ChecklistItemPriority.low:
        return 'Low';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case ChecklistItemPriority.high:
        return Colors.red;
      case ChecklistItemPriority.medium:
        return Colors.orange;
      case ChecklistItemPriority.low:
        return Colors.green;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          listId == other.listId;

  @override
  int get hashCode => id.hashCode ^ listId.hashCode;

  @override
  String toString() {
    return 'ChecklistItem(id: $id, text: $text, isDone: $isDone, priority: $priority)';
  }
}
