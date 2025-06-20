import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../utils/datetime_converter.dart';

part 'business_event.freezed.dart';
part 'business_event.g.dart';

@freezed
class BusinessEvent with _$BusinessEvent {
  const factory BusinessEvent({
    required String id,
    required String title,
    required String description,
    required String type,
    @DateTimeConverter() required DateTime startTime,
    @DateTimeConverter() required DateTime endTime,
  }) = _BusinessEvent;

  factory BusinessEvent.fromJson(Map<String, dynamic> json) =>
      _$BusinessEventFromJson(json);
}
