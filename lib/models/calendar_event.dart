import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String description;
  final String provider; // 'google' or 'outlook'

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.description,
    required this.provider,
  });

  factory CalendarEvent.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String) return DateTime.parse(v);
      try {
        // Firestore Timestamp
        return (v as Timestamp).toDate();
      } catch (_) {
        return DateTime.now();
      }
    }

    return CalendarEvent(
      id: id,
      title: map['title'] as String? ?? '',
      start: parseDate(map['start']),
      end: parseDate(map['end']),
      description: map['description'] as String? ?? '',
      provider: map['provider'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'start': start,
      'end': end,
      'description': description,
      'provider': provider,
    };
  }
}
