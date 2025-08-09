import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/meeting_creation/controllers/create_meeting_flow_controller.dart';
import 'package:appoint/features/meeting_creation/models/meeting_types.dart';

void main() {
  group('CreateMeetingFlowController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('default step should be participants', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);
      expect(controller.currentStep, equals(MeetingStep.participants));
    });

    test('setParticipants should toggle canContinue for participants step', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Initially no participants
      expect(controller.canContinue(MeetingStep.participants), isFalse);

      // Add participant
      controller.addParticipant('test@example.com');
      expect(controller.canContinue(MeetingStep.participants), isTrue);

      // Remove participant
      controller.removeParticipant('test@example.com');
      expect(controller.canContinue(MeetingStep.participants), isFalse);
    });

    test('setMeetingType should update meeting type', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      controller.setMeetingType(MeetingType.business);

      final state = container.read(createMeetingFlowControllerProvider);
      expect(state.meetingType, equals(MeetingType.business));
      expect(state.isTypeManuallySet, isTrue);
    });

    test('virtual meeting type should skip location step', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Set virtual meeting type
      controller.setMeetingType(MeetingType.virtual);

      // Should skip location step
      expect(controller.isPhysicalType(MeetingType.virtual), isFalse);
      expect(controller.canContinue(MeetingStep.location), isTrue);
    });

    test('physical meeting type should require location', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Set physical meeting type
      controller.setMeetingType(MeetingType.business);

      // Should require location
      expect(controller.isPhysicalType(MeetingType.business), isTrue);
      expect(controller.canContinue(MeetingStep.location), isFalse);

      // Set location
      controller.setLocation('Office');
      expect(controller.canContinue(MeetingStep.location), isTrue);
    });

    test('setDateTime should update date time', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);
      final now = DateTime.now();

      controller.setDateTime(now);

      final state = container.read(createMeetingFlowControllerProvider);
      expect(state.dateTime, equals(now));
    });

    test('setDurationMinutes should update duration', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      controller.setDurationMinutes(90);

      final state = container.read(createMeetingFlowControllerProvider);
      expect(state.durationMinutes, equals(90));
    });

    test('goToStep should change current step', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      controller.goToStep(MeetingStep.review);

      final state = container.read(createMeetingFlowControllerProvider);
      expect(state.currentStep, equals(MeetingStep.review));
    });

    test('nextStep should advance to next step', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Add participant to enable next step
      controller.addParticipant('test@example.com');

      controller.nextStep();

      final state = container.read(createMeetingFlowControllerProvider);
      expect(state.currentStep, equals(MeetingStep.meetingType));
    });

    test('prevStep should go back to previous step', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Go to meeting type step
      controller.addParticipant('test@example.com');
      controller.nextStep();

      // Go back
      controller.prevStep();

      final state = container.read(createMeetingFlowControllerProvider);
      expect(state.currentStep, equals(MeetingStep.participants));
    });

    test('isValid should check all required fields', () {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Initially invalid
      expect(controller.isValid, isFalse);

      // Add required fields
      controller.setTitle('Test Meeting');
      controller.addParticipant('test@example.com');
      controller.setDateTime(DateTime.now());
      controller.setDurationMinutes(60);

      expect(controller.isValid, isTrue);
    });

    test('createMeeting should return success for valid meeting', () async {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Set up valid meeting
      controller.setTitle('Test Meeting');
      controller.addParticipant('test@example.com');
      controller.setDateTime(DateTime.now());
      controller.setDurationMinutes(60);

      final result = await controller.createMeeting();
      expect(result, isTrue);
    });

    test('createMeeting should throw for invalid meeting', () async {
      final controller =
          container.read(createMeetingFlowControllerProvider.notifier);

      // Don't set required fields

      expect(
        () => controller.createMeeting(),
        throwsA(isA<Exception>()),
      );
    });
  });
}






