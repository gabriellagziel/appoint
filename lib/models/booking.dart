// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/datetime_converter.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  @JsonSerializable(explicitToJson: true)
  const factory Booking({
    required String id,
    required String userId,
    required String staffId,
    required String serviceId,
    required String serviceName,
    @DateTimeConverter() @JsonKey(name: 'dateTime') required DateTime dateTime,
    @JsonKey(name: 'duration') required Duration duration,
    String? notes,
    @Default(false) bool isConfirmed,
    @DateTimeConverter() DateTime? createdAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
