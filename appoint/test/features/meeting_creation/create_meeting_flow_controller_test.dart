import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lib/features/meeting_creation/controllers/meeting_flow_controller.dart';
import '../../../lib/features/meeting_creation/models/meeting_types.dart';
import '../../../lib/features/playtime/models/playtime_model.dart';
import '../../../lib/models/user_group.dart';

void main() {
  group('MeetingFlowController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Step Navigation', () {
      test('should start at participants step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);
        expect(controller.currentStep, equals(MeetingStep.participants));
      });

      test('nextStep should advance to next step when valid', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Add participant to enable next step
        controller.addParticipant('user1');

        controller.nextStep();
        expect(controller.currentStep, equals(MeetingStep.meetingType));
      });

      test('nextStep should skip location for virtual types', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Set up to meeting type step
        controller.addParticipant('user1');
        controller.nextStep();

        // Set virtual meeting type
        controller.setMeetingType(MeetingType.individual);

        controller.nextStep();
        // Should skip location and go to time
        expect(controller.currentStep, equals(MeetingStep.time));
      });

      test('nextStep should inject playtimeConfig step for playtime meetings',
          () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Set up to meeting type step
        controller.addParticipant('user1');
        controller.nextStep();

        // Set playtime meeting type
        controller.setMeetingType(MeetingType.playtime);

        controller.nextStep();
        expect(controller.currentStep, equals(MeetingStep.playtimeConfig));
      });

      test('prevStep should go back to previous step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Go to meeting type step
        controller.addParticipant('user1');
        controller.nextStep();

        controller.prevStep();
        expect(controller.currentStep, equals(MeetingStep.participants));
      });

      test('goToStep should change current step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        controller.goToStep(MeetingStep.review);
        expect(controller.currentStep, equals(MeetingStep.review));
      });
    });

    group('Validation', () {
      test('canContinue should validate participants step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Initially no participants
        expect(controller.canContinue(MeetingStep.participants), isFalse);

        // Add participant
        controller.addParticipant('user1');
        expect(controller.canContinue(MeetingStep.participants), isTrue);
      });

      test('canContinue should validate meeting type step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Initially individual type
        expect(controller.canContinue(MeetingStep.meetingType), isFalse);

        // Set event type
        controller.setMeetingType(MeetingType.event);
        expect(controller.canContinue(MeetingStep.meetingType), isTrue);
      });

      test('canContinue should validate playtime config step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Set playtime meeting type
        controller.setMeetingType(MeetingType.playtime);

        // Initially no playtime config
        expect(controller.canContinue(MeetingStep.playtimeConfig), isFalse);

        // Set valid playtime config
        const config = PlaytimeConfig(
          type: PlaytimeType.virtual,
          platform: PlaytimePlatform.discord,
          roomCode: 'ABC123',
        );
        controller.setPlaytimeConfig(config);
        expect(controller.canContinue(MeetingStep.playtimeConfig), isTrue);
      });

      test('canContinue should validate location step for physical types', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Set physical meeting type
        controller.setMeetingType(MeetingType.event);

        // Initially no location
        expect(controller.canContinue(MeetingStep.location), isFalse);

        // Set location
        controller.setLocation('Conference Room A');
        expect(controller.canContinue(MeetingStep.location), isTrue);
      });

      test('canContinue should always validate location for virtual types', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Set virtual meeting type
        controller.setMeetingType(MeetingType.individual);

        expect(controller.canContinue(MeetingStep.location), isTrue);
      });

      test('canContinue should validate time step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Initially no date/time but has default duration
        expect(controller.canContinue(MeetingStep.time), isFalse);

        // Set date/time but no duration (duration is already set to 60)
        controller.setDateTime(DateTime.now().add(const Duration(hours: 1)));
        expect(controller.canContinue(MeetingStep.time), isTrue);

        // Set duration
        controller.setDurationMinutes(60);
        expect(controller.canContinue(MeetingStep.time), isTrue);
      });

      test('canContinue should always validate notes step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        expect(controller.canContinue(MeetingStep.notesForms), isTrue);
      });

      test('canContinue should validate review step', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Initially invalid
        expect(controller.canContinue(MeetingStep.review), isFalse);

        // Set up valid meeting
        controller.addParticipant('user1');
        controller.setMeetingType(MeetingType.event);
        controller.setTitle('Test Meeting');
        controller.setDateTime(DateTime.now().add(const Duration(hours: 1)));
        controller.setDurationMinutes(60);

        expect(controller.canContinue(MeetingStep.review), isTrue);
      });
    });

    group('State Management', () {
      test('setMeetingType should update meeting type', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        controller.setMeetingType(MeetingType.event);
        controller.setMeetingType(MeetingType.individual);

        final state = container.read(meetingFlowControllerProvider);
        expect(state.meetingType, equals(MeetingType.individual));
      });

      test('setPlaytimeConfig should update playtime config', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        const config = PlaytimeConfig(
          type: PlaytimeType.physical,
          location: 'Park',
        );
        controller.setPlaytimeConfig(config);

        final state = container.read(meetingFlowControllerProvider);
        expect(state.playtimeConfig, equals(config));
      });

      test('setTitle should update title', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        controller.setTitle('Test Meeting');

        final state = container.read(meetingFlowControllerProvider);
        expect(state.title, equals('Test Meeting'));
      });

      test('setDescription should update description', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        controller.setDescription('Test description');

        final state = container.read(meetingFlowControllerProvider);
        expect(state.description, equals('Test description'));
      });

      test('setDateTime should update date time', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        final dateTime = DateTime.now().add(const Duration(hours: 1));
        controller.setDateTime(dateTime);

        final state = container.read(meetingFlowControllerProvider);
        expect(state.dateTime, equals(dateTime));
      });

      test('setDurationMinutes should update duration', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        controller.setDurationMinutes(90);

        final state = container.read(meetingFlowControllerProvider);
        expect(state.durationMinutes, equals(90));
      });

      test('setLocation should update location', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        controller.setLocation('Conference Room A');

        final state = container.read(meetingFlowControllerProvider);
        expect(state.location, equals('Conference Room A'));
      });

      test('selectGroup should update selected group', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        final group = UserGroup(
          id: 'group1',
          name: 'Test Group',
          createdBy: 'user1',
          members: ['member1'],
          admins: ['user1'],
          createdAt: DateTime.now(),
        );
        controller.selectGroup(group);

        final state = container.read(meetingFlowControllerProvider);
        expect(state.selectedGroup, equals(group));
      });

      test('clearGroup should clear selected group', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        final group = UserGroup(
          id: 'group1',
          name: 'Test Group',
          createdBy: 'user1',
          members: ['member1'],
          admins: ['user1'],
          createdAt: DateTime.now(),
        );
        controller.selectGroup(group);
        
        // Check that group was set
        var state = container.read(meetingFlowControllerProvider);
        expect(state.selectedGroup, isNotNull);
        
        controller.clearGroup();

        state = container.read(meetingFlowControllerProvider);
        expect(state.selectedGroup, isNull);
      });

      test('isPhysicalType should return correct values', () {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        expect(controller.isPhysicalType(MeetingType.event), isTrue);
        expect(controller.isPhysicalType(MeetingType.group), isTrue);
        expect(controller.isPhysicalType(MeetingType.playtime), isTrue);
        expect(controller.isPhysicalType(MeetingType.individual), isFalse);
      });
    });

    group('Meeting Creation', () {
      test('createMeeting should return success for valid meeting', () async {
        final controller =
            container.read(meetingFlowControllerProvider.notifier);

        // Set up valid meeting
        controller.setTitle('Test Meeting');
        controller.addParticipant('user1');
        controller.setDateTime(DateTime.now().add(const Duration(hours: 1)));
        controller.setDurationMinutes(60);
        controller.setMeetingType(MeetingType.event);

        final result = await controller.createMeeting();
        expect(result, isTrue);
      });
    });
  });
}
