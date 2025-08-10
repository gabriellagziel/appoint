import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/create_meeting_state.dart';
import '../flow_maps/meeting_type_to_steps.dart';

class CreateMeetingFlowController extends StateNotifier<CreateMeetingState> {
  CreateMeetingFlowController() : super(const CreateMeetingState());

  List<MeetingStep> get steps {
    final t = state.type ?? MeetingType.personal;
    final isPlaytimeVirtual =
        t == MeetingType.playtime && (state.virtualUrl != null && state.virtualUrl!.isNotEmpty);
    return stepsFor(t, playtimeVirtual: isPlaytimeVirtual);
  }

  MeetingStep get currentStep => steps[state.currentIndex];

  void setType(MeetingType type) {
    state = state.copyWith(type: type, currentIndex: 0);
    _autoPromoteToEventIfNeeded();
  }

  void setParticipants(List<String> ids) {
    state = state.copyWith(participantIds: ids);
    _autoPromoteToEventIfNeeded();
  }

  void setTime({required DateTime start, required DateTime end}) {
    state = state.copyWith(start: start, end: end);
  }

  void setLocation({String? address, double? lat, double? lng}) {
    state = state.copyWith(locationAddress: address, lat: lat, lng: lng);
  }

  void setVirtualUrl(String? url) {
    state = state.copyWith(
        virtualUrl: (url ?? '').trim().isEmpty ? null : url!.trim());
  }

  void setInfo({String? title, String? description}) {
    state = state.copyWith(
      title: title ?? state.title,
      description: description ?? state.description,
    );
  }

  bool validateStep(MeetingStep step) {
    switch (step) {
      case MeetingStep.info:
        return state.title.trim().isNotEmpty && state.type != null;
      case MeetingStep.participants:
        return state.participantIds.isNotEmpty;
      case MeetingStep.time:
        return state.start != null &&
            state.end != null &&
            state.end!.isAfter(state.start!);
      case MeetingStep.location:
        return state.type == MeetingType.openCall
            ? true
            : (state.locationAddress?.isNotEmpty ?? false);
      case MeetingStep.virtualUrl:
        return (state.virtualUrl?.isNotEmpty ?? false);
      case MeetingStep.extras:
        return true;
      case MeetingStep.review:
        return true;
    }
  }

  void next() {
    final idx = state.currentIndex;
    if (idx < steps.length - 1 && validateStep(currentStep)) {
      state = state.copyWith(
        completed: {...state.completed, currentStep},
        currentIndex: idx + 1,
      );
    }
  }

  void back() {
    final idx = state.currentIndex;
    if (idx > 0) state = state.copyWith(currentIndex: idx - 1);
  }

  bool get canSubmit {
    for (final step in steps) {
      if (!validateStep(step)) return false;
    }
    return true;
  }

  void _autoPromoteToEventIfNeeded() {
    final total = state.participantIds.length + 1;
    if (total >= 4 && state.type != MeetingType.event) {
      state = state.copyWith(type: MeetingType.event, currentIndex: 0);
    }
  }
}


