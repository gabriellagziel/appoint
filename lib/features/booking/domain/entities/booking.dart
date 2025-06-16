import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../utils/datetime_converter.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    @DateTimeConverter() required DateTime startTime,
    @DateTimeConverter() required DateTime endTime,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}
