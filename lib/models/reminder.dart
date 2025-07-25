import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String userId,
    required String title,
    required String description,
    required ReminderType type,
    required ReminderStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? triggerTime,
    ReminderLocation? location,
    String? meetingId,
    String? eventId,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    ReminderPriority? priority,
    ReminderRecurrence? recurrence,
    bool isCompleted,
    DateTime? completedAt,
    int? snoozeCount,
    DateTime? snoozedUntil,
    bool notificationsEnabled,
    List<ReminderNotificationMethod>? notificationMethods,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);

  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reminder.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class ReminderLocation with _$ReminderLocation {
  const factory ReminderLocation({
    required double latitude,
    required double longitude,
    required String address,
    String? name,
    double? radius,
    LocationTriggerType? triggerType,
  }) = _ReminderLocation;

  factory ReminderLocation.fromJson(Map<String, dynamic> json) => 
      _$ReminderLocationFromJson(json);
}

@freezed
class ReminderRecurrence with _$ReminderRecurrence {
  const factory ReminderRecurrence({
    required RecurrenceType type,
    int? interval,
    List<int>? daysOfWeek,
    int? dayOfMonth,
    DateTime? endDate,
    int? maxOccurrences,
  }) = _ReminderRecurrence;

  factory ReminderRecurrence.fromJson(Map<String, dynamic> json) => 
      _$ReminderRecurrenceFromJson(json);
}

enum ReminderType {
  @JsonValue('time_based')
  timeBased,
  @JsonValue('location_based')
  locationBased,
  @JsonValue('meeting_related')
  meetingRelated,
  @JsonValue('personal')
  personal,
}

enum ReminderStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('snoozed')
  snoozed,
  @JsonValue('overdue')
  overdue,
}

enum ReminderPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

enum LocationTriggerType {
  @JsonValue('on_arrival')
  onArrival,
  @JsonValue('on_departure')
  onDeparture,
  @JsonValue('while_at_location')
  whileAtLocation,
}

enum RecurrenceType {
  @JsonValue('none')
  none,
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
  @JsonValue('custom')
  custom,
}

enum ReminderNotificationMethod {
  @JsonValue('push')
  push,
  @JsonValue('local')
  local,
  @JsonValue('email')
  email,
  @JsonValue('sms')
  sms,
}

// Extensions for enum display names and utilities
extension ReminderTypeExtension on ReminderType {
  String get displayName {
    switch (this) {
      case ReminderType.timeBased:
        return 'Time-based';
      case ReminderType.locationBased:
        return 'Location-based';
      case ReminderType.meetingRelated:
        return 'Meeting';
      case ReminderType.personal:
        return 'Personal';
    }
  }

  bool get requiresMapAccess {
    return this == ReminderType.locationBased;
  }
}

extension ReminderStatusExtension on ReminderStatus {
  String get displayName {
    switch (this) {
      case ReminderStatus.active:
        return 'Active';
      case ReminderStatus.completed:
        return 'Completed';
      case ReminderStatus.cancelled:
        return 'Cancelled';
      case ReminderStatus.snoozed:
        return 'Snoozed';
      case ReminderStatus.overdue:
        return 'Overdue';
    }
  }

  bool get isActive {
    return this == ReminderStatus.active || this == ReminderStatus.snoozed;
  }
}

extension ReminderPriorityExtension on ReminderPriority {
  String get displayName {
    switch (this) {
      case ReminderPriority.low:
        return 'Low';
      case ReminderPriority.medium:
        return 'Medium';
      case ReminderPriority.high:
        return 'High';
      case ReminderPriority.urgent:
        return 'Urgent';
    }
  }

  int get sortOrder {
    switch (this) {
      case ReminderPriority.low:
        return 1;
      case ReminderPriority.medium:
        return 2;
      case ReminderPriority.high:
        return 3;
      case ReminderPriority.urgent:
        return 4;
    }
  }
}