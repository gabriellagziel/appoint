import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_item.freezed.dart';
part 'calendar_item.g.dart';

@freezed
class CalendarItem with _$CalendarItem {
  const factory CalendarItem({
    required String id,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required String ownerId,
    String? assigneeId,
    String? familyId,
    required String visibility, // 'private', 'family'
    required String type, // 'meeting', 'reminder'
    String? location,
    List<String>? attendees,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CalendarItem;

  factory CalendarItem.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemFromJson(json);
}
