import 'package:appoint/utils/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_event.freezed.dart';
part 'business_event.g.dart';

@freezed
class BusinessEvent with _$BusinessEvent {
  const factory BusinessEvent({
    required final String id,
    required final String title,
    required final String description,
    required final String type,
    @DateTimeConverter() required final DateTime startTime,
    @DateTimeConverter() required final DateTime endTime,
  }) = _BusinessEvent;

  factory BusinessEvent.fromJson(Map<String, dynamic> json) =>
      _$BusinessEventFromJson(json);
}
