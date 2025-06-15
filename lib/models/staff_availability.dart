import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/datetime_converter.dart';

part 'staff_availability.freezed.dart';
part 'staff_availability.g.dart';

@freezed
class StaffAvailability with _$StaffAvailability {
  const factory StaffAvailability({
    required String staffId,

    @DateTimeConverter()
    required DateTime availableFrom,

    @DateTimeConverter()
    required DateTime availableTo,
  }) = _StaffAvailability;

  factory StaffAvailability.fromJson(Map<String, dynamic> json) =>
      _$StaffAvailabilityFromJson(json);
}
