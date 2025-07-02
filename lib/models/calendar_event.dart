import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appoint/utils/datetime_converter.dart';

part '../generated/models/calendar_event.freezed.dart';
part '../generated/models/calendar_event.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required final String id,
    required final String title,
    @DateTimeConverter() required final DateTime startTime,
    @DateTimeConverter() required final DateTime endTime,
    final String? description,
    final String? provider,
    final String? location,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(final Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}
