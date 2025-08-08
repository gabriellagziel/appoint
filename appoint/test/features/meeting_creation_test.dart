import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/features/meeting_creation/controllers/create_meeting_flow_controller.dart';
import '../lib/features/meeting_creation/models/meeting_types.dart';
import '../lib/features/meeting_creation/widgets/group_selector_tile.dart';
import '../lib/features/meeting_creation/widgets/participants_preview_widget.dart';
import '../lib/models/user_group.dart';

void main() {
  group('Meeting Creation with Group Integration Tests', () {
    testWidgets('GroupSelectorTile displays group information correctly',
        (tester) async {
      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2', 'user-3'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
        description: 'A test group for meetings',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GroupSelectorTile(
                group: group,
                onTap: () {},
                isSelected: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Group'), findsOneWidget);
      expect(find.text('3 members'), findsOneWidget);
      expect(find.text('• A test group for meetings'), findsOneWidget);
      expect(find.byIcon(Icons.group), findsOneWidget);
    });

    testWidgets('GroupSelectorTile shows selection state', (tester) async {
      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GroupSelectorTile(
                group: group,
                onTap: () {},
                isSelected: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets(
        'ParticipantsPreviewWidget shows group info when group is selected',
        (tester) async {
      final group = UserGroup(
        id: 'test-group-1',
        name: 'Family Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2', 'user-3'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
        description: 'Family meetings',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            REDACTED_TOKEN.overrideWith(
              (ref) => CreateMeetingFlowController()..selectGroup(group),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: const ParticipantsPreviewWidget(),
            ),
          ),
        ),
      );

      expect(find.text('Participants'), findsOneWidget);
      expect(find.text('Family Group'), findsOneWidget);
      expect(find.text('Family meetings'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('Meeting type changes to event when group is selected',
        (tester) async {
      final container = ProviderContainer();
      final controller =
          container.read(REDACTED_TOKEN.notifier);

      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
      );

      // Initially individual
      expect(controller.state.meetingType, MeetingType.individual);

      // Select group
      controller.selectGroup(group);

      // Should change to event
      expect(controller.state.meetingType, MeetingType.event);
      expect(controller.state.selectedGroup, group);
      expect(controller.state.participants.length, 2);
    });

    testWidgets('Manual meeting type change is not overridden', (tester) async {
      final container = ProviderContainer();
      final controller =
          container.read(REDACTED_TOKEN.notifier);

      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
      );

      // Manually set to individual
      controller.setMeetingType(MeetingType.individual);
      expect(controller.state.meetingType, MeetingType.individual);
      expect(controller.state.isTypeManuallySet, true);

      // Select group
      controller.selectGroup(group);

      // Should stay individual because it was manually set
      expect(controller.state.meetingType, MeetingType.individual);
      expect(controller.state.selectedGroup, group);
      expect(controller.state.participants.length, 2);
    });

    testWidgets('Clear group removes group selection', (tester) async {
      final container = ProviderContainer();
      final controller =
          container.read(REDACTED_TOKEN.notifier);

      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
      );

      controller.selectGroup(group);
      expect(controller.state.selectedGroup, group);

      controller.clearGroup();
      expect(controller.state.selectedGroup, null);
    });

    testWidgets('Meeting validation works correctly', (tester) async {
      final container = ProviderContainer();
      final controller =
          container.read(REDACTED_TOKEN.notifier);

      // Initially invalid
      expect(controller.isValid, false);

      // Add title
      controller.setTitle('Test Meeting');
      expect(controller.isValid, false);

      // Add participants
      controller.addParticipant('user-1');
      expect(controller.isValid, false);

      // Add date
      controller.setDateTime(DateTime.now());
      expect(controller.isValid, true);
    });
  });
}


