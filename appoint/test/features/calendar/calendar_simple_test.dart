import 'package:flutter_test/flutter_test.dart';
import '../../../lib/models/agenda_item.dart';

void main() {
  group('Calendar Simple Tests', () {
    test('should create agenda items correctly', () {
      final meeting = AgendaItem(
        id: 'meeting_1',
        title: 'Team Standup',
        time: DateTime.now().add(const Duration(hours: 9)),
        type: AgendaItemType.meeting,
        metadata: {
          'participants': ['Alice', 'Bob'],
          'location': 'Conference Room A',
        },
      );

      expect(meeting.id, equals('meeting_1'));
      expect(meeting.title, equals('Team Standup'));
      expect(meeting.isMeeting, isTrue);
      expect(meeting.isReminder, isFalse);
      expect(meeting.metadata?['participants'], equals(['Alice', 'Bob']));
    });

    test('should create reminder items correctly', () {
      final reminder = AgendaItem(
        id: 'reminder_1',
        title: 'Submit report',
        time: DateTime.now().add(const Duration(hours: 17)),
        type: AgendaItemType.reminder,
        metadata: {
          'priority': 'high',
          'category': 'work',
        },
      );

      expect(reminder.id, equals('reminder_1'));
      expect(reminder.title, equals('Submit report'));
      expect(reminder.isMeeting, isFalse);
      expect(reminder.isReminder, isTrue);
      expect(reminder.metadata?['priority'], equals('high'));
    });

    test('should sort agenda items by time', () {
      final now = DateTime.now();
      final items = [
        AgendaItem(
          id: 'later',
          title: 'Later Meeting',
          time: now.add(const Duration(hours: 2)),
          type: AgendaItemType.meeting,
        ),
        AgendaItem(
          id: 'earlier',
          title: 'Earlier Meeting',
          time: now.add(const Duration(hours: 1)),
          type: AgendaItemType.meeting,
        ),
      ];

      items.sort((a, b) => a.time.compareTo(b.time));

      expect(items.first.id, equals('earlier'));
      expect(items.last.id, equals('later'));
    });

    test('should serialize and deserialize agenda items', () {
      final original = AgendaItem(
        id: 'test_1',
        title: 'Test Meeting',
        time: DateTime.now(),
        type: AgendaItemType.meeting,
        metadata: {'key': 'value'},
      );

      final map = original.toMap();
      final deserialized = AgendaItem.fromMap(map);

      expect(deserialized.id, equals(original.id));
      expect(deserialized.title, equals(original.title));
      expect(deserialized.type, equals(original.type));
      expect(deserialized.metadata, equals(original.metadata));
    });
  });
}
