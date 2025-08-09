import 'package:flutter/material.dart';

enum MeetingType {
  individual,
  event,
  group,
  playtime,
}

extension MeetingTypeExtension on MeetingType {
  String get displayName {
    switch (this) {
      case MeetingType.individual:
        return 'Individual Meeting';
      case MeetingType.event:
        return 'Event';
      case MeetingType.group:
        return 'Group Meeting';
      case MeetingType.playtime:
        return 'Playtime';
    }
  }

  String get description {
    switch (this) {
      case MeetingType.individual:
        return 'One-on-one meeting';
      case MeetingType.event:
        return 'Multiple participants';
      case MeetingType.group:
        return 'Group-based meeting';
      case MeetingType.playtime:
        return 'Gaming and play activities';
    }
  }

  IconData get icon {
    switch (this) {
      case MeetingType.individual:
        return Icons.person;
      case MeetingType.event:
        return Icons.event;
      case MeetingType.group:
        return Icons.group;
      case MeetingType.playtime:
        return Icons.games;
    }
  }
}

enum RecurrenceType { none, daily, weekly, monthly, custom }