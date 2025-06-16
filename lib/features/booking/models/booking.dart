import 'package:json_annotation/json_annotation.dart';
import '../../../utils/datetime_converter.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class Booking {
  @DateTimeConverter()
  final DateTime dateTime;
  final String notes;

  Booking({
    required this.dateTime,
    required this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
