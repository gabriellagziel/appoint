import 'package:flutter/material.dart';

enum MeetingType {
  individual,
  event,
  group,
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
    }
  }
}


