import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/location.freezed.dart';
part '../generated/models/location.g.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required final double latitude,
    required final double longitude,
    final String? address,
  }) = _Location;

  factory Location.fromJson(final Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
