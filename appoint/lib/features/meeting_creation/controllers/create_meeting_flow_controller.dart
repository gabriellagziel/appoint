import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meeting_types.dart';
import '../../../models/user_group.dart';

class CreateMeetingFlowController extends StateNotifier<CreateMeetingState> {
  CreateMeetingFlowController() : super(CreateMeetingState.initial());

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

  void addParticipants(List<String> participantIds) {
    final currentParticipants = List<String>.from(state.participants);
    for (final participantId in participantIds) {
      if (!currentParticipants.contains(participantId)) {
        currentParticipants.add(participantId);
      }
    }
    state = state.copyWith(participants: currentParticipants);
  }

  void setMeetingType(MeetingType type) {
    state = state.copyWith(
      meetingType: type,
      isTypeManuallySet: true,
    );
  }

  void selectGroup(UserGroup group) {
    // Add all group members as participants
    final groupMembers = List<String>.from(group.members);
    addParticipants(groupMembers);

    // Set meeting type to event if not manually set
    if (!state.isTypeManuallySet) {
      state = state.copyWith(
        meetingType: MeetingType.event,
        selectedGroup: group,
      );
    } else {
      state = state.copyWith(selectedGroup: group);
    }

    // Note: touchGroup will be called from the UI components
    // to update usage statistics for suggestions
  }

  void clearGroup() {
    state = state.copyWith(selectedGroup: null);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setDateTime(DateTime dateTime) {
    state = state.copyWith(dateTime: dateTime);
  }

  void setDuration(Duration duration) {
    state = state.copyWith(duration: duration);
  }

  void reset() {
    state = CreateMeetingState.initial();
  }

  bool get isValid {
    return state.title.isNotEmpty &&
        state.participants.isNotEmpty &&
        state.dateTime != null;
  }
}

class CreateMeetingState {
  final String title;
  final String description;
  final DateTime? dateTime;
  final Duration duration;
  final List<String> participants;
  final MeetingType meetingType;
  final UserGroup? selectedGroup;
  final bool isTypeManuallySet;

  const CreateMeetingState({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.duration,
    required this.participants,
    required this.meetingType,
    this.selectedGroup,
    required this.isTypeManuallySet,
  });

  factory CreateMeetingState.initial() {
    return const CreateMeetingState(
      title: '',
      description: '',
      dateTime: null,
      duration: Duration(hours: 1),
      participants: [],
      meetingType: MeetingType.individual,
      selectedGroup: null,
      isTypeManuallySet: false,
    );
  }

  CreateMeetingState copyWith({
    String? title,
    String? description,
    DateTime? dateTime,
    Duration? duration,
    List<String>? participants,
    MeetingType? meetingType,
    UserGroup? selectedGroup,
    bool? isTypeManuallySet,
  }) {
    return CreateMeetingState(
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      participants: participants ?? this.participants,
      meetingType: meetingType ?? this.meetingType,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isTypeManuallySet: isTypeManuallySet ?? this.isTypeManuallySet,
    );
  }
}

// Riverpod provider
final REDACTED_TOKEN =
    StateNotifierProvider<CreateMeetingFlowController, CreateMeetingState>(
        (ref) {
  return CreateMeetingFlowController();
});
