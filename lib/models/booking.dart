import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  factory Booking({
    required String id,
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required DateTime startTime,
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required DateTime endTime,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

DateTime _fromJson(String date) => DateTime.parse(date);
String _toJson(DateTime date) => date.toIso8601String();
