import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';
import '../widgets/meeting_header.dart';
import '../widgets/participant_list.dart';
import '../widgets/meeting_checklist.dart';
import '../widgets/meeting_chat.dart';
import '../widgets/meeting_actions_bar.dart';

class MeetingDetailsScreen extends ConsumerWidget {
  final String meetingId;
  const MeetingDetailsScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(meetingControllerProvider(meetingId));
    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final m = state.meeting;
    if (m == null) {
      return const Scaffold(body: Center(child: Text('Meeting not found')));
    }

    final isDesktop = MediaQuery.of(context).size.width > 900;

    final content = isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    MeetingHeader(meeting: m),
                    const SizedBox(height: 16),
                    ParticipantList(participants: state.participants),
                    const SizedBox(height: 16),
                    MeetingActionsBar(meetingId: meetingId),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    MeetingChecklist(meetingId: meetingId, meeting: m),
                    const SizedBox(height: 16),
                    MeetingChat(meetingId: meetingId),
                  ],
                ),
              ),
            ],
          )
        : ListView(
            children: [
              MeetingHeader(meeting: m),
              const SizedBox(height: 12),
              ParticipantList(participants: state.participants),
              const SizedBox(height: 12),
              MeetingActionsBar(meetingId: meetingId),
              const SizedBox(height: 12),
              MeetingChecklist(meetingId: meetingId, meeting: m),
              const SizedBox(height: 12),
              MeetingChat(meetingId: meetingId),
            ],
          );

    return Scaffold(
      appBar: AppBar(title: Text(m['title'] ?? 'Meeting')),
      body: Padding(padding: const EdgeInsets.all(12), child: content),
    );
  }
}
