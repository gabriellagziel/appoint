import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_controller.dart';
import '../widgets/meeting_header.dart';
import '../widgets/participant_list.dart';
import '../widgets/meeting_checklist.dart';
import '../widgets/meeting_chat.dart';
import '../widgets/meeting_actions_bar.dart';
import '../../../services/auth/auth_providers.dart';
import '../../../services/analytics_service.dart';

class MeetingDetailsScreen extends ConsumerWidget {
  final String meetingId;
  final bool? isGuest;
  const MeetingDetailsScreen(
      {super.key, required this.meetingId, this.isGuest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserAsync = ref.watch(authUserProvider);

    final state = ref.watch(meetingControllerProvider(meetingId));
    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final m = state.meeting;
    if (m == null) {
      return const Scaffold(
          body:
              Center(child: Text('This meeting link is invalid or expired.')));
    }

    final isDesktop = MediaQuery.of(context).size.width > 900;
    final MeetingType = m['type']; // string or enum id in your model
    final String? virtualUrl = m['virtualUrl'];
    final Map<String, dynamic>? timeBlock =
        (m['time'] as Map?)?.cast<String, dynamic>();
    final loc = m['location'];
    final bool hasLocation = (loc is Map<String, dynamic>)
        ? (loc['address'] != null || (loc['lat'] != null && loc['lng'] != null))
        : (m['location'] != null || (m['lat'] != null && m['lng'] != null));
    final bool isOpenCall = MeetingType == 'openCall';
    final bool isEvent =
        MeetingType == 'event' || ((state.participants.length + 1) >= 4);
    final bool isPlaytime = MeetingType == 'playtime';

    final viewerIsGuest = (isGuest == true) ||
        authUserAsync.maybeWhen(data: (u) => u == null, orElse: () => false);
    final hasEnded = (() {
      try {
        final end = m['end'];
        if (end is String)
          return DateTime.tryParse(end)?.isBefore(DateTime.now()) ?? false;
        if (end is DateTime) return end.isBefore(DateTime.now());
      } catch (_) {}
      return false;
    })();

    if (viewerIsGuest && hasEnded) {
      return const Scaffold(
          body: Center(child: Text('This meeting has ended.')));
    }

    // Fire-and-forget analytics (ignore returned future)
    final uri = Uri.base;
    final meta = <String, dynamic>{
      'id': meetingId,
      'type': m['type'],
      'guest': viewerIsGuest,
    };
    final shareId = uri.queryParameters['shareId'];
    final source = uri.queryParameters['source'];
    final creatorId = uri.queryParameters['creatorId'];
    if (shareId != null) meta['shareId'] = shareId;
    if (source != null) meta['source'] = source;
    if (creatorId != null) meta['creatorId'] = creatorId;
    // ignore: unused_result
    Analytics.log('meeting_details_opened', meta);
    if (viewerIsGuest) {
      // ignore: unused_result
      Analytics.log('guest_meeting_viewed', meta);
    }

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
                    if (!viewerIsGuest)
                      ParticipantList(participants: state.participants),
                    const SizedBox(height: 16),
                    if (!viewerIsGuest) MeetingActionsBar(meetingId: meetingId),
                    const SizedBox(height: 16),
                    if (!isOpenCall && hasLocation)
                      Card(
                        child: ListTile(
                            title: const Text('Location'),
                            subtitle: Text(
                              loc is Map<String, dynamic>
                                  ? (loc['address'] ?? '')
                                  : (m['location'] ?? ''),
                            )),
                      ),
                    if (timeBlock != null)
                      Card(
                        child: ListTile(
                          title: const Text('Time'),
                          subtitle: Text(
                            '${timeBlock['start'] ?? m['start']} → ${timeBlock['end'] ?? m['end']}'
                            '${(timeBlock['recurrence'] != null && timeBlock['recurrence'] != 'none') ? ' • ${timeBlock['recurrence']}' : ''}'
                            '${(timeBlock['flexible'] != null) ? ' • ${timeBlock['flexible']}' : ''}',
                          ),
                        ),
                      ),
                    if (virtualUrl != null && virtualUrl.isNotEmpty)
                      Card(
                          child: ListTile(
                              title: const Text('Virtual meeting'),
                              subtitle: Text(virtualUrl))),
                    if (viewerIsGuest) const SizedBox(height: 12),
                    if (viewerIsGuest)
                      _GuestCtaCard(
                        onSignIn: () =>
                            Navigator.of(context).pushNamed('/login'),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    if (!viewerIsGuest && (isEvent || isPlaytime))
                      MeetingChecklist(meetingId: meetingId, meeting: m),
                    if (!viewerIsGuest && isEvent) const SizedBox(height: 16),
                    if (!viewerIsGuest && isEvent)
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
              if (!viewerIsGuest)
                ParticipantList(participants: state.participants),
              const SizedBox(height: 12),
              if (!viewerIsGuest) MeetingActionsBar(meetingId: meetingId),
              const SizedBox(height: 12),
              if (!isOpenCall && hasLocation)
                Card(
                    child: ListTile(
                        title: const Text('Location'),
                        subtitle: Text(
                          loc is Map<String, dynamic>
                              ? (loc['address'] ?? '')
                              : (m['location'] ?? ''),
                        ))),
              if (timeBlock != null)
                Card(
                  child: ListTile(
                    title: const Text('Time'),
                    subtitle: Text(
                      '${timeBlock['start'] ?? m['start']} → ${timeBlock['end'] ?? m['end']}'
                      '${(timeBlock['recurrence'] != null && timeBlock['recurrence'] != 'none') ? ' • ${timeBlock['recurrence']}' : ''}'
                      '${(timeBlock['flexible'] != null) ? ' • ${timeBlock['flexible']}' : ''}',
                    ),
                  ),
                ),
              if (virtualUrl != null && virtualUrl.isNotEmpty)
                Card(
                    child: ListTile(
                        title: const Text('Virtual meeting'),
                        subtitle: Text(virtualUrl))),
              const SizedBox(height: 12),
              if (!viewerIsGuest && (isEvent || isPlaytime))
                MeetingChecklist(meetingId: meetingId, meeting: m),
              if (!viewerIsGuest && isEvent) const SizedBox(height: 12),
              if (!viewerIsGuest && isEvent) MeetingChat(meetingId: meetingId),
              if (viewerIsGuest) const SizedBox(height: 12),
              if (viewerIsGuest)
                _GuestCtaCard(
                  onSignIn: () => Navigator.of(context).pushNamed('/login'),
                ),
            ],
          );

    return Scaffold(
      appBar: AppBar(title: Text(m['title'] ?? 'Meeting')),
      body: Padding(padding: const EdgeInsets.all(12), child: content),
    );
  }
}

class _GuestCtaCard extends StatelessWidget {
  const _GuestCtaCard({required this.onSignIn});
  final VoidCallback onSignIn;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You\'re viewing a shared link',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Sign in to RSVP, chat, and add to calendar.'),
            const SizedBox(height: 8),
            Row(children: [
              FilledButton(onPressed: onSignIn, child: const Text('Sign in')),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Get the app'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
