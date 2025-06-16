import 'package:json_annotation/json_annotation.dart';
import '../utils/datetime_converter.dart';

part 'calendar_event.g.dart';

@JsonSerializable()
class CalendarEvent {
  final String id;
  final String title;
  @DateTimeConverter()
  final DateTime start;
  @DateTimeConverter()
  final DateTime end;
  final String description;
  final String provider; // 'google' or 'outlook'

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.description,
    required this.provider,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}
