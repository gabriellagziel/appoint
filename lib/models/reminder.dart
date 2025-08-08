import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required String ownerId,
    String? assigneeId,
    String? familyId,
    required String visibility, // 'private', 'family'
    required String priority, // 'low', 'medium', 'high'
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
