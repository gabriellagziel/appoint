import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_flow_controller.dart';
import '../steps/select_participants_step.dart';
import '../steps/select_meeting_type_step.dart';
import '../steps/select_location_step.dart';
import '../steps/select_time_step.dart';
import '../steps/notes_forms_step.dart';
import '../steps/review_meeting_screen.dart';
import '../../playtime/screens/playtime_config_screen.dart';

class CreateMeetingFlow extends ConsumerWidget {
  const CreateMeetingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(meetingFlowControllerProvider.notifier);
    final state = ref.watch(meetingFlowControllerProvider);
    final currentStep = state.currentStep;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getStepTitle(currentStep)),
        leading: currentStep != MeetingStep.participants
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => controller.prevStep(),
              )
            : null,
      ),
      body: _buildStepContent(context, ref, currentStep),
    );
  }

  String _getStepTitle(MeetingStep step) {
    switch (step) {
      case MeetingStep.participants:
        return 'Select Participants';
      case MeetingStep.meetingType:
        return 'Meeting Type';
      case MeetingStep.playtimeConfig:
        return 'Playtime Configuration';
      case MeetingStep.location:
        return 'Location';
      case MeetingStep.time:
        return 'Time & Duration';
      case MeetingStep.notesForms:
        return 'Notes & Forms';
      case MeetingStep.review:
        return 'Review Meeting';
    }
  }

  Widget _buildStepContent(
      BuildContext context, WidgetRef ref, MeetingStep step) {
    switch (step) {
      case MeetingStep.participants:
        return SelectParticipantsStep(
          onNext: () => _handleNext(context, ref),
        );
      case MeetingStep.meetingType:
        return SelectMeetingTypeStep(
          onNext: () => _handleNext(context, ref),
        );
      case MeetingStep.playtimeConfig:
        return const PlaytimeConfigScreen();
      case MeetingStep.location:
        return SelectLocationStep(
          onNext: () => _handleNext(context, ref),
        );
      case MeetingStep.time:
        return SelectTimeStep(
          onNext: () => _handleNext(context, ref),
        );
      case MeetingStep.notesForms:
        return NotesFormsStep(
          onNext: () => _handleNext(context, ref),
        );
      case MeetingStep.review:
        return ReviewMeetingScreen(
          onCreateMeeting: () => _handleCreateMeeting(context, ref),
        );
    }
  }

  void _handleNext(BuildContext context, WidgetRef ref) {
    final controller = ref.read(meetingFlowControllerProvider.notifier);

    if (controller.canContinueFromCurrentStep()) {
      controller.nextStep();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCreateMeeting(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(meetingFlowControllerProvider.notifier);

    try {
      final success = await controller.createMeeting();

      if (success) {
        _showSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create meeting'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meeting Created!'),
        content: const Text('Your meeting has been successfully created.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close flow
            },
            child: const Text('OK'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close flow
              // TODO: Navigate to calendar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to calendar')),
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('View in Calendar'),
          ),
        ],
      ),
    );
  }
}
