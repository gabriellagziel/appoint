import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(final String json) => DateTime.parse(json);

  @override
  String toJson(final DateTime dateTime) => dateTime.toIso8601String();
}
