// ignore_for_file: invalid_annotation_target
import 'package:appoint/utils/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  @JsonSerializable(explicitToJson: true)
  const factory Booking({
    required final String id,
    required final String userId,
    required final String staffId,
    required final String serviceId,
    required final String serviceName,
    @DateTimeConverter()
    @JsonKey(name: 'dateTime')
    required final DateTime dateTime,
    @JsonKey(name: 'duration') required final Duration duration,
    final String? notes,
    @Default(false) final bool isConfirmed,
    @DateTimeConverter() final DateTime? createdAt,
    final String? businessProfileId,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
