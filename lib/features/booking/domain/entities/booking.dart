import 'dart:core';

import 'package:appoint/utils/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required final String id,
    @DateTimeConverter() required final DateTime startTime,
    @DateTimeConverter() required final DateTime endTime,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$$_BookingFromJson(json);
}
