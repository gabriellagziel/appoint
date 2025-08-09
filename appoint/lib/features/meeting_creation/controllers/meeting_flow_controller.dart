import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meeting_types.dart';
import '../../../models/user_group.dart';
import '../../../features/playtime/models/playtime_model.dart';

enum MeetingStep {
  participants,
  meetingType,
  playtimeConfig,
  location,
  time,
  notesForms,
  review
}

class MeetingFlowController extends StateNotifier<MeetingFlowState> {
  MeetingFlowController() : super(MeetingFlowState.initial());

  MeetingStep get currentStep => state.currentStep;

  void nextStep() {
    if (state.currentStep.index < MeetingStep.values.length - 1) {
      MeetingStep nextStep = MeetingStep.values[state.currentStep.index + 1];

      // Skip playtime config if not playtime meeting
      if (state.currentStep == MeetingStep.meetingType &&
          state.meetingType != MeetingType.playtime) {
        nextStep = MeetingStep.location;
      }

      // Skip location step for virtual types
      if (state.currentStep == MeetingStep.meetingType &&
          !isPhysicalType(state.meetingType)) {
        nextStep = MeetingStep.time;
      }

      // Skip location for virtual playtime
      if (state.currentStep == MeetingStep.playtimeConfig &&
          state.playtimeConfig?.isVirtual == true) {
        nextStep = MeetingStep.time;
      }

      state = state.copyWith(currentStep: nextStep);
    }
  }

  void prevStep() {
    if (state.currentStep.index > 0) {
      MeetingStep prevStep = MeetingStep.values[state.currentStep.index - 1];

      // Skip location step when going back for virtual types
      if (state.currentStep == MeetingStep.time &&
          !isPhysicalType(state.meetingType)) {
        prevStep = MeetingStep.meetingType;
      }

      // Skip playtime config when going back if not playtime
      if (state.currentStep == MeetingStep.location &&
          state.meetingType != MeetingType.playtime) {
        prevStep = MeetingStep.meetingType;
      }

      state = state.copyWith(currentStep: prevStep);
    }
  }

  void goToStep(MeetingStep step) {
    state = state.copyWith(currentStep: step);
  }

  bool canContinue(MeetingStep step) {
    switch (step) {
      case MeetingStep.participants:
        return state.participants.isNotEmpty;
      case MeetingStep.meetingType:
        return state.meetingType != MeetingType.individual;
      case MeetingStep.playtimeConfig:
        return state.playtimeConfig?.isValid ?? false;
      case MeetingStep.location:
        return isPhysicalType(state.meetingType)
            ? (state.location != null && state.location!.isNotEmpty)
            : true;
      case MeetingStep.time:
        return state.dateTime != null && state.durationMinutes > 0;
      case MeetingStep.notesForms:
        return true; // Always valid
      case MeetingStep.review:
        return stateIsValid;
    }
  }

  bool canContinueFromCurrentStep() {
    return canContinue(state.currentStep);
  }

  void setMeetingType(MeetingType type) {
    state = state.copyWith(
      meetingType: type,
      isTypeManuallySet: true,
    );

    // Clear location if switching to virtual type
    if (!isPhysicalType(type)) {
      state = state.copyWith(location: null);
    }
  }

  void setPlaytimeConfig(PlaytimeConfig config) {
    state = state.copyWith(playtimeConfig: config);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setDateTime(DateTime dateTime) {
    state = state.copyWith(dateTime: dateTime);
  }

  void setDurationMinutes(int minutes) {
    state = state.copyWith(durationMinutes: minutes);
  }

  void addParticipant(String participantId) {
    final currentParticipants = List<String>.from(state.participants);
    if (!currentParticipants.contains(participantId)) {
      currentParticipants.add(participantId);
      state = state.copyWith(participants: currentParticipants);
    }
  }

  void removeParticipant(String participantId) {
    final currentParticipants = List<String>.from(state.participants);
    currentParticipants.remove(participantId);
    state = state.copyWith(participants: currentParticipants);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setRecurrence(RecurrenceType recurrence) {
    state = state.copyWith(recurrence: recurrence);
  }

  void setCustomRecurrenceDays(List<int> days) {
    state = state.copyWith(customRecurrenceDays: days);
  }

  void selectGroup(UserGroup group) {
    // Add all group members as participants
    final groupMembers = List<String>.from(group.members);
    for (final memberId in groupMembers) {
      addParticipant(memberId);
    }
    state = state.copyWith(selectedGroup: group);
  }

  void clearGroup() {
    state = MeetingFlowState(
      currentStep: state.currentStep,
      title: state.title,
      description: state.description,
      dateTime: state.dateTime,
      durationMinutes: state.durationMinutes,
      participants: state.participants,
      meetingType: state.meetingType,
      location: state.location,
      recurrence: state.recurrence,
      customRecurrenceDays: state.customRecurrenceDays,
      selectedGroup: null,
      isTypeManuallySet: state.isTypeManuallySet,
      playtimeConfig: state.playtimeConfig,
    );
  }

  bool isPhysicalType(MeetingType type) {
    return type == MeetingType.event ||
        type == MeetingType.group ||
        type == MeetingType.playtime;
  }

  bool get isValid {
    return state.title.isNotEmpty &&
        state.participants.isNotEmpty &&
        state.dateTime != null &&
        state.durationMinutes > 0 &&
        (state.meetingType != MeetingType.playtime ||
            state.playtimeConfig != null);
  }

  bool get stateIsValid {
    return state.title.isNotEmpty &&
        state.participants.isNotEmpty &&
        state.dateTime != null &&
        state.durationMinutes > 0 &&
        (state.meetingType != MeetingType.playtime ||
            state.playtimeConfig != null);
  }

  Future<bool> createMeeting() async {
    if (!isValid) {
      throw Exception('Meeting is not valid');
    }

    final meetingData = {
      'title': state.title,
      'description': state.description,
      'dateTime': state.dateTime!.toIso8601String(),
      'durationMinutes': state.durationMinutes,
      'participants': state.participants,
      'meetingType': state.meetingType.name,
      'location': state.location,
      'recurrence': state.recurrence.name,
      'customRecurrenceDays': state.customRecurrenceDays,
      'selectedGroup': state.selectedGroup != null
          ? {
              'id': state.selectedGroup!.id,
              'name': state.selectedGroup!.name,
              'description': state.selectedGroup!.description,
              'memberCount': state.selectedGroup!.memberCount,
            }
          : null,
      'playtimeConfig': state.playtimeConfig?.toMap(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    // TODO: Submit to backend
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    return true; // Success
  }
}

class MeetingFlowState {
  final MeetingStep currentStep;
  final String title;
  final String description;
  final DateTime? dateTime;
  final int durationMinutes;
  final List<String> participants;
  final MeetingType meetingType;
  final String? location;
  final RecurrenceType recurrence;
  final List<int> customRecurrenceDays;
  final UserGroup? selectedGroup;
  final bool isTypeManuallySet;
  final PlaytimeConfig? playtimeConfig;

  const MeetingFlowState({
    required this.currentStep,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.durationMinutes,
    required this.participants,
    required this.meetingType,
    this.location,
    required this.recurrence,
    required this.customRecurrenceDays,
    this.selectedGroup,
    required this.isTypeManuallySet,
    this.playtimeConfig,
  });

  factory MeetingFlowState.initial() {
    return const MeetingFlowState(
      currentStep: MeetingStep.participants,
      title: '',
      description: '',
      dateTime: null,
      durationMinutes: 60,
      participants: [],
      meetingType: MeetingType.individual,
      location: null,
      recurrence: RecurrenceType.none,
      customRecurrenceDays: [],
      selectedGroup: null,
      isTypeManuallySet: false,
      playtimeConfig: null,
    );
  }

  MeetingFlowState copyWith({
    MeetingStep? currentStep,
    String? title,
    String? description,
    DateTime? dateTime,
    int? durationMinutes,
    List<String>? participants,
    MeetingType? meetingType,
    String? location,
    RecurrenceType? recurrence,
    List<int>? customRecurrenceDays,
    UserGroup? selectedGroup,
    bool? isTypeManuallySet,
    PlaytimeConfig? playtimeConfig,
  }) {
    return MeetingFlowState(
      currentStep: currentStep ?? this.currentStep,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      participants: participants ?? this.participants,
      meetingType: meetingType ?? this.meetingType,
      location: location ?? this.location,
      recurrence: recurrence ?? this.recurrence,
      customRecurrenceDays: customRecurrenceDays ?? this.customRecurrenceDays,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isTypeManuallySet: isTypeManuallySet ?? this.isTypeManuallySet,
      playtimeConfig: playtimeConfig ?? this.playtimeConfig,
    );
  }
}

enum RecurrenceType { none, daily, weekly, monthly, custom }

// Riverpod providers
final meetingFlowControllerProvider =
    StateNotifierProvider<MeetingFlowController, MeetingFlowState>((ref) {
  return MeetingFlowController();
});
