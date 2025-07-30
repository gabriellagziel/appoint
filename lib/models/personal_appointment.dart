import 'package:appoint/utils/datetime_converter.dart';

class PersonalAppointment {
  PersonalAppointment({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  factory PersonalAppointment.fromJson(Map<String, dynamic> json) =>
      PersonalAppointment(
        id: json['id'] as String,
        userId: json['userId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
      );
  final String id;
  final String userId;
  final String title;
  final String description;
  @DateTimeConverter()
  final DateTime startTime;
  @DateTimeConverter()
  final DateTime endTime;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      };
}
