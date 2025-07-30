import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_details.dart';
import 'package:appoint/services/meeting_service.dart';
import 'package:appoint/features/messaging/screens/chat_screen.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

final meetingServiceProvider = Provider<MeetingService>((ref) => MeetingService());

final meetingDetailsProvider = StreamProvider.family<MeetingDetails?, String>(
  (ref, meetingId) {
    final service = ref.read(meetingServiceProvider);
    return service.watchMeeting(meetingId);
  },
);

class MeetingDetailsScreen extends ConsumerStatefulWidget {
  const MeetingDetailsScreen({
    super.key,
    required this.meetingId,
  });

  final String meetingId;

  @override
  ConsumerState<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends ConsumerState<MeetingDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GoogleMapController? _mapController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meetingAsync = ref.watch(meetingDetailsProvider(widget.meetingId));
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    return meetingAsync.when(
      data: (meeting) {
        if (meeting == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.error)),
            body: const Center(child: Text('Meeting not found')),
          );
        }

        final currentParticipant = meeting.participants.firstWhere(
          (p) => p.userId == currentUser?.uid,
          orElse: () => throw StateError('User not found in participants'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(meeting.title),
            actions: [
              if (meeting.isGroupEvent && meeting.chatId != null)
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () => _openChat(context, meeting),
                ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value, meeting),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        const Icon(Icons.share),
                        const SizedBox(width: 8),
                        Text(l10n.share),
                      ],
                    ),
                  ),
                  if (meeting.location != null)
                    PopupMenuItem(
                      value: 'directions',
                      child: Row(
                        children: [
                          const Icon(Icons.directions),
                          const SizedBox(width: 8),
                          const Text('Get Directions'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'calendar',
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        const Text('Add to Calendar'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: meeting.isGroupEvent
                ? TabBar(
                    controller: _tabController,
                    tabs: [
                      const Tab(icon: Icon(Icons.info), text: 'Details'),
                      const Tab(icon: Icon(Icons.people), text: 'Participants'),
                      if (meeting.location != null)
                        const Tab(icon: Icon(Icons.map), text: 'Location'),
                      if (meeting.hasCustomForms)
                        const Tab(icon: Icon(Icons.assignment), text: 'Forms'),
                    ],
                  )
                : null,
          ),
          body: meeting.isGroupEvent
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(meeting, currentParticipant),
                    _buildParticipantsTab(meeting, currentParticipant),
                    if (meeting.location != null)
                      _buildLocationTab(meeting),
                    if (meeting.hasCustomForms)
                      _buildFormsTab(meeting),
                  ],
                )
              : _buildDetailsTab(meeting, currentParticipant),
          bottomNavigationBar: _buildBottomActions(meeting, currentParticipant),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildDetailsTab(MeetingDetails meeting, MeetingParticipant currentParticipant) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMeetingHeader(meeting),
          const SizedBox(height: 24),
          _buildMeetingInfo(meeting),
          const SizedBox(height: 24),
          if (meeting.location != null) _buildLocationCard(meeting),
          const SizedBox(height: 24),
          if (!meeting.isGroupEvent) _buildParticipantCard(meeting, currentParticipant),
          if (meeting.isGroupEvent) _buildParticipantsSummary(meeting),
          const SizedBox(height: 24),
          _buildStatusSection(meeting, currentParticipant),
        ],
      ),
    );
  }

  Widget _buildMeetingHeader(MeetingDetails meeting) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  meeting.type == MeetingType.oneOnOne
                      ? Icons.person
                      : meeting.type == MeetingType.group
                          ? Icons.group
                          : Icons.event,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meeting.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                _buildMeetingStatusChip(meeting),
              ],
            ),
            if (meeting.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                meeting.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingStatusChip(MeetingDetails meeting) {
    Color color;
    String label;
    
    if (meeting.isCompleted) {
      color = Colors.grey;
      label = 'Completed';
    } else if (meeting.isActive) {
      color = Colors.green;
      label = 'Live';
    } else if (meeting.isUpcoming) {
      color = Colors.blue;
      label = 'Upcoming';
    } else {
      color = Colors.orange;
      label = 'Past';
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMeetingInfo(MeetingDetails meeting) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.schedule, 'Date & Time', _formatMeetingTime(meeting)),
            const Divider(),
            _buildInfoRow(Icons.timer, 'Duration', _formatDuration(meeting)),
            const Divider(),
            _buildInfoRow(Icons.people, 'Participants', '${meeting.participantCount} people'),
            if (meeting.location != null) ...[
              const Divider(),
              _buildInfoRow(Icons.location_on, 'Location', meeting.location!.address ?? 'Custom location'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(MeetingDetails meeting) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Meeting Location'),
            subtitle: Text(meeting.location!.address ?? 'Custom location'),
            trailing: IconButton(
              icon: const Icon(Icons.directions),
              onPressed: () => _openDirections(meeting.location!),
            ),
          ),
          if (meeting.location != null)
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    meeting.location!.latitude,
                    meeting.location!.longitude,
                  ),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('meeting_location'),
                    position: LatLng(
                      meeting.location!.latitude,
                      meeting.location!.longitude,
                    ),
                    infoWindow: InfoWindow(title: meeting.title),
                  ),
                },
                onMapCreated: (controller) => _mapController = controller,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantsTab(MeetingDetails meeting, MeetingParticipant currentParticipant) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meeting.participants.length,
      itemBuilder: (context, index) {
        final participant = meeting.participants[index];
        return _buildParticipantTile(participant, participant.userId == currentParticipant.userId);
      },
    );
  }

  Widget _buildParticipantTile(MeetingParticipant participant, bool isCurrentUser) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: participant.avatarUrl != null
              ? NetworkImage(participant.avatarUrl!)
              : null,
          child: participant.avatarUrl == null
              ? Text(participant.displayName[0].toUpperCase())
              : null,
        ),
        title: Row(
          children: [
            Expanded(child: Text(participant.displayName)),
            if (isCurrentUser) 
              const Chip(
                label: Text('You'),
                backgroundColor: Colors.blue,
                labelStyle: TextStyle(color: Colors.white, fontSize: 12),
              ),
            if (participant.role == ParticipantRole.host)
              const Chip(
                label: Text('Host'),
                backgroundColor: Colors.orange,
                labelStyle: TextStyle(color: Colors.white, fontSize: 12),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(participant.email),
            _buildParticipantStatus(participant),
          ],
        ),
        trailing: participant.isRunningLate
            ? const Icon(Icons.schedule, color: Colors.orange)
            : participant.status == ParticipantStatus.confirmed
                ? const Icon(Icons.check_circle, color: Colors.green)
                : participant.status == ParticipantStatus.declined
                    ? const Icon(Icons.cancel, color: Colors.red)
                    : const Icon(Icons.schedule, color: Colors.grey),
      ),
    );
  }

  Widget _buildParticipantStatus(MeetingParticipant participant) {
    String statusText;
    Color statusColor;

    switch (participant.status) {
      case ParticipantStatus.confirmed:
        statusText = participant.isRunningLate ? 'Running late' : 'Confirmed';
        statusColor = participant.isRunningLate ? Colors.orange : Colors.green;
        break;
      case ParticipantStatus.declined:
        statusText = 'Declined';
        statusColor = Colors.red;
        break;
      case ParticipantStatus.late:
        statusText = 'Running late';
        statusColor = Colors.orange;
        break;
      case ParticipantStatus.arrived:
        statusText = 'Arrived';
        statusColor = Colors.green;
        break;
      default:
        statusText = 'Pending';
        statusColor = Colors.grey;
    }

    return Text(
      statusText,
      style: TextStyle(
        color: statusColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Widget _buildLocationTab(MeetingDetails meeting) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          meeting.location!.latitude,
          meeting.location!.longitude,
        ),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('meeting_location'),
          position: LatLng(
            meeting.location!.latitude,
            meeting.location!.longitude,
          ),
          infoWindow: InfoWindow(
            title: meeting.title,
            snippet: meeting.location!.address,
          ),
        ),
      },
      onMapCreated: (controller) => _mapController = controller,
    );
  }

  Widget _buildFormsTab(MeetingDetails meeting) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meeting.customForms.length,
      itemBuilder: (context, index) {
        final form = meeting.customForms[index];
        return Card(
          child: ListTile(
            leading: Icon(_getFormIcon(form.type)),
            title: Text(form.title),
            subtitle: Text(form.description),
            trailing: form.isRequired
                ? const Chip(
                    label: Text('Required'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  )
                : null,
            onTap: () => _openForm(form),
          ),
        );
      },
    );
  }

  Widget _buildParticipantsSummary(MeetingDetails meeting) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants (${meeting.participantCount})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusCount('Confirmed', meeting.confirmedParticipants.length, Colors.green),
                const SizedBox(width: 16),
                _buildStatusCount('Late', meeting.lateParticipants.length, Colors.orange),
                const SizedBox(width: 16),
                _buildStatusCount('Pending', 
                    meeting.participants.where((p) => p.status == ParticipantStatus.pending).length, 
                    Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCount(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantCard(MeetingDetails meeting, MeetingParticipant currentParticipant) {
    final otherParticipant = meeting.participants.firstWhere(
      (p) => p.userId != currentParticipant.userId,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meeting with',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildParticipantTile(otherParticipant, false),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(MeetingDetails meeting, MeetingParticipant currentParticipant) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildParticipantStatus(currentParticipant),
            if (currentParticipant.isRunningLate) ...[
              const SizedBox(height: 8),
              if (currentParticipant.lateReason != null)
                Text('Reason: ${currentParticipant.lateReason}'),
              if (currentParticipant.estimatedArrival != null)
                Text('ETA: ${_formatTime(currentParticipant.estimatedArrival!)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(MeetingDetails meeting, MeetingParticipant currentParticipant) {
    if (meeting.isCompleted) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentParticipant.status == ParticipantStatus.pending) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _confirmAttendance(meeting.id, currentParticipant.userId),
                icon: const Icon(Icons.check),
                label: const Text('Confirm'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _declineAttendance(meeting.id, currentParticipant.userId),
                icon: const Icon(Icons.close),
                label: const Text('Decline'),
              ),
            ),
          ] else if (currentParticipant.status == ParticipantStatus.confirmed && !currentParticipant.isRunningLate) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showLateDialog(meeting, currentParticipant),
                icon: const Icon(Icons.schedule),
                label: const Text("I'm Running Late"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ),
          ] else if (currentParticipant.isRunningLate && meeting.isUpcoming) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _markAsArrived(meeting.id, currentParticipant.userId),
                icon: const Icon(Icons.check_circle),
                label: const Text("I've Arrived"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
          if (meeting.isGroupEvent && meeting.chatId != null) ...[
            const SizedBox(width: 12),
            FloatingActionButton(
              mini: true,
              onPressed: () => _openChat(context, meeting),
              child: const Icon(Icons.chat),
            ),
          ],
        ],
      ),
    );
  }

  void _openChat(BuildContext context, MeetingDetails meeting) {
    if (meeting.chatId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatId: meeting.chatId!),
      ),
    );
  }

  void _showLateDialog(MeetingDetails meeting, MeetingParticipant currentParticipant) {
    showDialog(
      context: context,
      builder: (context) => _LateDialog(
        meetingId: meeting.id,
        userId: currentParticipant.userId,
        onConfirm: () => ref.refresh(meetingDetailsProvider(widget.meetingId)),
      ),
    );
  }

  void _confirmAttendance(String meetingId, String userId) async {
    try {
      await ref.read(meetingServiceProvider).updateParticipantStatus(
        meetingId: meetingId,
        userId: userId,
        status: ParticipantStatus.confirmed,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _declineAttendance(String meetingId, String userId) async {
    try {
      await ref.read(meetingServiceProvider).updateParticipantStatus(
        meetingId: meetingId,
        userId: userId,
        status: ParticipantStatus.declined,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _markAsArrived(String meetingId, String userId) async {
    try {
      await ref.read(meetingServiceProvider).updateParticipantStatus(
        meetingId: meetingId,
        userId: userId,
        status: ParticipantStatus.arrived,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _openDirections(Location location) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _handleMenuAction(BuildContext context, String action, MeetingDetails meeting) {
    switch (action) {
      case 'share':
        // Implement sharing functionality
        break;
      case 'directions':
        if (meeting.location != null) {
          _openDirections(meeting.location!);
        }
        break;
      case 'calendar':
        // Implement add to calendar functionality
        break;
    }
  }

  void _openForm(CustomForm form) {
    // Navigate to form filling screen
  }

  IconData _getFormIcon(CustomFormType type) {
    switch (type) {
      case CustomFormType.rsvp:
        return Icons.event_available;
      case CustomFormType.poll:
        return Icons.poll;
      case CustomFormType.survey:
        return Icons.quiz;
      case CustomFormType.preferences:
        return Icons.tune;
    }
  }

  String _formatMeetingTime(MeetingDetails meeting) {
    final start = meeting.scheduledAt;
    final end = meeting.endTime;
    return '${start.day}/${start.month}/${start.year} at ${start.hour}:${start.minute.toString().padLeft(2, '0')} - ${end.hour}:${end.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(MeetingDetails meeting) {
    final duration = meeting.endTime.difference(meeting.scheduledAt);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _LateDialog extends ConsumerStatefulWidget {
  const _LateDialog({
    required this.meetingId,
    required this.userId,
    required this.onConfirm,
  });

  final String meetingId;
  final String userId;
  final VoidCallback onConfirm;

  @override
  ConsumerState<_LateDialog> createState() => _LateDialogState();
}

class _LateDialogState extends ConsumerState<_LateDialog> {
  final _reasonController = TextEditingController();
  int _delayMinutes = 15;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("I'm Running Late"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason (optional)',
              hintText: 'Traffic, delayed train, etc.',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Delay: '),
              Expanded(
                child: Slider(
                  value: _delayMinutes.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label: '$_delayMinutes min',
                  onChanged: (value) => setState(() => _delayMinutes = value.round()),
                ),
              ),
              Text('$_delayMinutes min'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _markAsLate,
          child: const Text('Notify'),
        ),
      ],
    );
  }

  void _markAsLate() async {
    try {
      await ref.read(meetingServiceProvider).markAsRunningLate(
        meetingId: widget.meetingId,
        userId: widget.userId,
        reason: _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
        delayMinutes: _delayMinutes,
      );
      
      widget.onConfirm();
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Participants have been notified')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}