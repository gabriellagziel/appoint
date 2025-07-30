import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/meeting.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMeetingScreen extends ConsumerStatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  ConsumerState<CreateMeetingScreen> createState() =>
      _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends ConsumerState<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _virtualUrlController = TextEditingController();

  DateTime? _startTime;
  DateTime? _endTime;
  final List<MeetingParticipant> _participants = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _virtualUrlController.dispose();
    super.dispose();
  }

  MeetingType get _meetingType {
    final totalParticipants = _participants.length + 1; // +1 for organizer
    return totalParticipants >= 4 ? MeetingType.event : MeetingType.personal;
  }

  bool get _isEvent => _meetingType == MeetingType.event;

  String get _typeDisplayName => _isEvent ? 'Event' : 'Meeting';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create $_typeDisplayName'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _canCreateMeeting ? _createMeeting : null,
              child: Text(l10n.create),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Meeting Type Indicator
            _buildMeetingTypeCard(),
            const SizedBox(height: 16),

            // Basic Information
            _buildBasicInfoSection(l10n),
            const SizedBox(height: 16),

            // Date & Time
            _buildDateTimeSection(l10n),
            const SizedBox(height: 16),

            // Location
            _buildLocationSection(l10n),
            const SizedBox(height: 16),

            // Participants
            _buildParticipantsSection(l10n),
            const SizedBox(height: 16),

            // Event-Only Features (only show for events)
            if (_isEvent) ...[
              _buildEventFeaturesSection(l10n),
              const SizedBox(height: 16),
            ],

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isLoading || !_canCreateMeeting ? null : _createMeeting,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Create $_typeDisplayName'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingTypeCard() {
    final theme = Theme.of(context);
    final isEvent = _isEvent;
    final participantCount = _participants.length + 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isEvent ? Icons.event : Icons.meeting_room,
                  color: isEvent ? Colors.orange : Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  _typeDisplayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isEvent ? Colors.orange : Colors.blue,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isEvent ? Colors.orange : Colors.blue)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$participantCount participants',
                    style: TextStyle(
                      color: isEvent ? Colors.orange : Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isEvent
                  ? 'Events (4+ participants) have access to custom forms, checklists, and group chat.'
                  : 'Personal meetings (up to 3 participants) are great for small group discussions.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '$_typeDisplayName Title',
              hintText: 'Enter the ${_typeDisplayName.toLowerCase()} title',
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'Enter a description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      );

  Widget _buildDateTimeSection(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & Time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Start Time'),
                  subtitle: Text(_startTime?.toString() ?? 'Select start time'),
                  leading: const Icon(Icons.access_time),
                  onTap: () => _selectDateTime(true),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(_endTime?.toString() ?? 'Select end time'),
                  leading: const Icon(Icons.access_time_filled),
                  onTap: () => _selectDateTime(false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildLocationSection(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Physical Location (optional)',
              hintText: 'Enter meeting location',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _virtualUrlController,
            decoration: const InputDecoration(
              labelText: 'Virtual Meeting URL (optional)',
              hintText: 'Enter Zoom, Meet, or other meeting URL',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.videocam),
            ),
          ),
        ],
      );

  Widget _buildParticipantsSection(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Participants',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addParticipant,
                icon: const Icon(Icons.person_add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_participants.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add participants to your ${_typeDisplayName.toLowerCase()}. You need at least 1 participant.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(_participants.length, (index) {
              final participant = _participants[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(participant.name[0].toUpperCase()),
                  ),
                  title: Text(participant.name),
                  subtitle: Text(participant.email ?? ''),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'role',
                        child: Text('Role: ${participant.role.name}'),
                      ),
                      if (_isEvent)
                        PopupMenuItem(
                          value: 'admin',
                          child: Text(
                            participant.role == ParticipantRole.admin
                                ? 'Remove Admin'
                                : 'Make Admin',
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'remove',
                        child:
                            Text('Remove', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                    onSelected: (value) =>
                        _handleParticipantAction(index, value),
                  ),
                ),
              );
            }),
        ],
      );

  Widget _buildEventFeaturesSection(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Features',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'These features are available because this is an event (4+ participants):',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.assignment, color: Colors.orange),
                  title: const Text('Custom Registration Form'),
                  subtitle: const Text('Collect information from attendees'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Navigate to form builder
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Form builder will be available after creating the event')),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.checklist, color: Colors.orange),
                  title: const Text('Event Checklist'),
                  subtitle: const Text('Organize tasks and preparation'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Navigate to checklist builder
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Checklist will be available after creating the event')),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.chat, color: Colors.orange),
                  title: const Text('Group Chat'),
                  subtitle: const Text('Enable chat for all participants'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Navigate to chat settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Group chat will be available after creating the event')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );

  bool get _canCreateMeeting =>
      _titleController.text.trim().isNotEmpty &&
      _startTime != null &&
      _endTime != null &&
      _participants.isNotEmpty &&
      _startTime!.isBefore(_endTime!);

  Future<void> _selectDateTime(bool isStartTime) async {
    final now = DateTime.now();
    final initialDate = isStartTime
        ? (_startTime ?? now.add(const Duration(days: 1)))
        : (_endTime ??
            _startTime?.add(const Duration(hours: 1)) ??
            now.add(const Duration(days: 1, hours: 1)));

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStartTime) {
        _startTime = selectedDateTime;
        // Auto-adjust end time to be 1 hour after start time if not set or invalid
        if (_endTime == null || _endTime!.isBefore(_startTime!)) {
          _endTime = _startTime!.add(const Duration(hours: 1));
        }
      } else {
        _endTime = selectedDateTime;
      }
    });
  }

  void _addParticipant() {
    // TODO: Implement participant picker/invite flow
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Participant'),
        content: const Text('Participant picker will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Mock adding a participant for demonstration
              setState(() {
                _participants.add(
                  MeetingParticipant(
                    userId: 'user_${_participants.length + 1}',
                    name: 'Participant ${_participants.length + 1}',
                    email: 'participant${_participants.length + 1}@example.com',
                  ),
                );
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add Mock Participant'),
          ),
        ],
      ),
    );
  }

  void _handleParticipantAction(int index, String action) {
    switch (action) {
      case 'admin':
        setState(() {
          final participant = _participants[index];
          _participants[index] = participant.copyWith(
            role: participant.role == ParticipantRole.admin
                ? ParticipantRole.participant
                : ParticipantRole.admin,
          );
        });
      case 'remove':
        setState(() {
          _participants.removeAt(index);
        });
    }
  }

  Future<void> _createMeeting() async {
    if (!_formKey.currentState!.validate() || !_canCreateMeeting) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authProvider).currentUser;
      if (user == null) throw Exception('User not authenticated');

      final meetingService = MeetingService();

      final meeting = await meetingService.createMeeting(
        organizerId: user.uid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startTime: _startTime!,
        endTime: _endTime!,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        virtualMeetingUrl: _virtualUrlController.text.trim().isEmpty
            ? null
            : _virtualUrlController.text.trim(),
        participants: _participants,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${meeting.typeDisplayName} created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(meeting);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error creating ${_typeDisplayName.toLowerCase()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
