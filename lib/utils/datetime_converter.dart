import 'package:json_annotation/json_annotation.dart';

/// A custom converter to handle DateTime serialization in @JsonKey.
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String();
}
