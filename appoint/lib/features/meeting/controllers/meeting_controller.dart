import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/meeting_service.dart';

final meetingServiceProvider = Provider((_) => MeetingService());

class MeetingState {
  final Map<String, dynamic>? meeting;
  final List<Map<String, dynamic>> participants;
  final List<Map<String, dynamic>> chat;
  final bool loading;
  const MeetingState(
      {this.meeting,
      this.participants = const [],
      this.chat = const [],
      this.loading = true});

  MeetingState copyWith({
    Map<String, dynamic>? meeting,
    List<Map<String, dynamic>>? participants,
    List<Map<String, dynamic>>? chat,
    bool? loading,
  }) =>
      MeetingState(
        meeting: meeting ?? this.meeting,
        participants: participants ?? this.participants,
        chat: chat ?? this.chat,
        loading: loading ?? this.loading,
      );
}

class MeetingController extends StateNotifier<MeetingState> {
  MeetingController(this.ref, this.meetingId) : super(const MeetingState());
  final Ref ref;
  final String meetingId;

  void init() {
    final svc = ref.read(meetingServiceProvider);
    svc
        .watchMeeting(meetingId)
        .listen((m) => state = state.copyWith(meeting: m, loading: false));
    svc
        .watchParticipants(meetingId)
        .listen((p) => state = state.copyWith(participants: p));
    svc.watchChat(meetingId).listen((c) => state = state.copyWith(chat: c));
    svc.watchChecklist(meetingId).listen((list) {
      final m = Map<String, dynamic>.from(state.meeting ?? {});
      m['checklist'] = list;
      state = state.copyWith(meeting: m);
    });
  }

  Future<void> rsvp(String userId, String status) =>
      ref.read(meetingServiceProvider).rsvp(meetingId, userId, status);
  Future<void> markArrived(String userId, bool v) =>
      ref.read(meetingServiceProvider).markArrived(meetingId, userId, v);
  Future<void> sendMessage(String userId, String text) =>
      ref.read(meetingServiceProvider).sendMessage(meetingId, userId, text);
  Future<void> toggleChecklistItem(String itemId, bool done) => ref
      .read(meetingServiceProvider)
      .toggleChecklistItem(meetingId, itemId, done);
}

final meetingControllerProvider =
    StateNotifierProvider.family<MeetingController, MeetingState, String>(
        (ref, id) {
  final c = MeetingController(ref, id);
  c.init();
  return c;
});
  Future<void> toggleChecklistItem(String itemId, bool done) =>
      ref.read(meetingServiceProvider).toggleChecklistItem(meetingId, itemId, done);
      
  // Role management
  Future<void> assignRole(String userId, String role) =>
      ref.read(meetingServiceProvider).assignRole(meetingId, userId, role);
      
  Future<void> removeRole(String userId) =>
      ref.read(meetingServiceProvider).removeRole(meetingId, userId);
}
