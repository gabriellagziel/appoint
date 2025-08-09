import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ReminderPriority {
  low,
  medium,
  high,
  urgent;

  Color get color {
    switch (this) {
      case ReminderPriority.low:
        return Colors.green;
      case ReminderPriority.medium:
        return Colors.orange;
      case ReminderPriority.high:
        return Colors.red;
      case ReminderPriority.urgent:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case ReminderPriority.low:
        return Icons.flag_outlined;
      case ReminderPriority.medium:
        return Icons.flag;
      case ReminderPriority.high:
        return Icons.priority_high;
      case ReminderPriority.urgent:
        return Icons.warning;
    }
  }
}

enum ReminderStatus {
  pending,
  completed,
  overdue,
  cancelled,
}

enum ReminderRecurrence {
  none,
  daily,
  weekly,
  monthly,
  custom,
}

class Reminder {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final DateTime createdAt;
  final String createdBy;
  final String? assignedTo; // null = self, userId = specific person
  final ReminderPriority priority;
  final ReminderStatus status;
  final ReminderRecurrence recurrence;
  final int? customRecurrenceDays;
  final List<String> checklistItems;
  final List<String> tags;
  final bool isFamilyReminder;

  const Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.createdAt,
    required this.createdBy,
    this.assignedTo,
    this.priority = ReminderPriority.medium,
    this.status = ReminderStatus.pending,
    this.recurrence = ReminderRecurrence.none,
    this.customRecurrenceDays,
    this.checklistItems = const [],
    this.tags = const [],
    this.isFamilyReminder = false,
  });

  factory Reminder.fromMap(String id, Map<String, dynamic> data) {
    return Reminder(
      id: id,
      title: data['title'] ?? '',
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      assignedTo: data['assignedTo'],
      priority: ReminderPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => ReminderPriority.medium,
      ),
      status: ReminderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ReminderStatus.pending,
      ),
      recurrence: ReminderRecurrence.values.firstWhere(
        (e) => e.name == data['recurrence'],
        orElse: () => ReminderRecurrence.none,
      ),
      customRecurrenceDays: data['customRecurrenceDays'],
      checklistItems: List<String>.from(data['checklistItems'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      isFamilyReminder: data['isFamilyReminder'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'priority': priority.name,
      'status': status.name,
      'recurrence': recurrence.name,
      'customRecurrenceDays': customRecurrenceDays,
      'checklistItems': checklistItems,
      'tags': tags,
      'isFamilyReminder': isFamilyReminder,
    };
  }

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    String? createdBy,
    String? assignedTo,
    ReminderPriority? priority,
    ReminderStatus? status,
    ReminderRecurrence? recurrence,
    int? customRecurrenceDays,
    List<String>? checklistItems,
    List<String>? tags,
    bool? isFamilyReminder,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      recurrence: recurrence ?? this.recurrence,
      customRecurrenceDays: customRecurrenceDays ?? this.customRecurrenceDays,
      checklistItems: checklistItems ?? this.checklistItems,
      tags: tags ?? this.tags,
      isFamilyReminder: isFamilyReminder ?? this.isFamilyReminder,
    );
  }

  bool get isOverdue =>
      status == ReminderStatus.pending && dueDate.isBefore(DateTime.now());

  bool get isToday =>
      dueDate.year == DateTime.now().year &&
      dueDate.month == DateTime.now().month &&
      dueDate.day == DateTime.now().day;

  bool get isUpcoming => dueDate.isAfter(DateTime.now()) && !isToday;

  String get formattedDueDate {
    if (isToday) return 'Today';
    if (isOverdue) return 'Overdue';

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (dueDate.year == tomorrow.year &&
        dueDate.month == tomorrow.month &&
        dueDate.day == tomorrow.day) {
      return 'Tomorrow';
    }

    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  Color get priorityColor => priority.color;
  IconData get priorityIcon => priority.icon;
}
