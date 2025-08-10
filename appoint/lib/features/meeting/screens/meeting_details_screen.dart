import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';
import '../widgets/meeting_header.dart';
import '../widgets/participant_list.dart';
import '../widgets/meeting_checklist.dart';
import '../widgets/meeting_chat.dart';
import '../widgets/meeting_actions_bar.dart';
import '../../../services/auth/auth_providers.dart';

class MeetingDetailsScreen extends ConsumerWidget {
  final String meetingId;
  const MeetingDetailsScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    
    // Redirect unauthenticated users to public meeting page
    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/m/$meetingId');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final state = ref.watch(meetingControllerProvider(meetingId));
    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final m = state.meeting;
    if (m == null) {
      return const Scaffold(body: Center(child: Text('Meeting not found')));
    }

    final isDesktop = MediaQuery.of(context).size.width > 900;
    final MeetingType = m['type']; // string or enum id in your model
    final String? virtualUrl = m['virtualUrl'];
    final bool hasLocation = (m['location'] != null) || (m['lat'] != null && m['lng'] != null);
    final bool isOpenCall = MeetingType == 'openCall';
    final bool isEvent = MeetingType == 'event' || ((state.participants.length + 1) >= 4);
    final bool isPlaytime = MeetingType == 'playtime';

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
                    const SizedBox(height: 16),
                    if (!isOpenCall && hasLocation)
                      Card(child: ListTile(title: const Text('Location'), subtitle: Text(m['location'] ?? '')),),
                    if (virtualUrl != null && virtualUrl.isNotEmpty)
                      Card(child: ListTile(title: const Text('Virtual meeting'), subtitle: Text(virtualUrl))),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    if (isEvent || isPlaytime)
                      MeetingChecklist(meetingId: meetingId, meeting: m),
                    if (isEvent) const SizedBox(height: 16),
                    if (isEvent) MeetingChat(meetingId: meetingId),
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
              if (!isOpenCall && hasLocation)
                Card(child: ListTile(title: const Text('Location'), subtitle: Text(m['location'] ?? ''))),
              if (virtualUrl != null && virtualUrl.isNotEmpty)
                Card(child: ListTile(title: const Text('Virtual meeting'), subtitle: Text(virtualUrl))),
              const SizedBox(height: 12),
              if (isEvent || isPlaytime)
                MeetingChecklist(meetingId: meetingId, meeting: m),
              if (isEvent) const SizedBox(height: 12),
              if (isEvent) MeetingChat(meetingId: meetingId),
            ],
          );

    return Scaffold(
      appBar: AppBar(title: Text(m['title'] ?? 'Meeting')),
      body: Padding(padding: const EdgeInsets.all(12), child: content),
    );
  }
}
