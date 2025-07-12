import 'package:appoint/utils/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_availability.freezed.dart';
part 'staff_availability.g.dart';

@freezed
class StaffAvailability with _$StaffAvailability {
  const factory StaffAvailability({
    required final String staffId,
    @DateTimeConverter() required final DateTime date,
    final List<String>? availableSlots,
  }) = _StaffAvailability;

  factory StaffAvailability.fromJson(Map<String, dynamic> json) =>
      _$StaffAvailabilityFromJson(json);
}
