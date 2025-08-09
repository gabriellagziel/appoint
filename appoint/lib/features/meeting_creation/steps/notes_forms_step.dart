import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_meeting_flow_controller.dart';
import '../models/meeting_types.dart';

class NotesFormsStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const NotesFormsStep({
    super.key,
    required this.onNext,
  });

  @override
  ConsumerState<NotesFormsStep> createState() => _NotesFormsStepState();
}

class _NotesFormsStepState extends ConsumerState<NotesFormsStep> {
  final TextEditingController _notesController = TextEditingController();
  final List<String> _checklistItems = [];
  final List<Map<String, dynamic>> _formFields = [];

  @override
  void initState() {
    super.initState();
    final meetingState = ref.read(REDACTED_TOKEN);
    _notesController.text = meetingState.notes ?? '';
    _loadDynamicFields();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _loadDynamicFields() {
    final meetingState = ref.read(REDACTED_TOKEN);
    final meetingType = meetingState.meetingType;

    // Clear existing fields
    _formFields.clear();
    _checklistItems.clear();

    // Add dynamic fields based on meeting type
    switch (meetingType) {
      case MeetingType.business:
        _formFields.addAll([
          {'type': 'text', 'label': 'Agenda', 'required': true},
          {'type': 'text', 'label': 'Meeting Link', 'required': false},
          {'type': 'text', 'label': 'Conference Room', 'required': false},
        ]);
        _checklistItems.addAll([
          'Prepare presentation materials',
          'Send calendar invites',
          'Book conference room',
        ]);
        break;

      case MeetingType.virtual:
        _formFields.addAll([
          {'type': 'text', 'label': 'Video Call Link', 'required': true},
          {'type': 'text', 'label': 'Meeting ID', 'required': false},
          {'type': 'text', 'label': 'Passcode', 'required': false},
        ]);
        _checklistItems.addAll([
          'Test video call link',
          'Prepare screen sharing',
          'Check microphone and camera',
        ]);
        break;

      case MeetingType.playtime:
        _formFields.addAll([
          {'type': 'text', 'label': 'Game Name', 'required': true},
          {'type': 'text', 'label': 'Age Group', 'required': true},
          {'type': 'text', 'label': 'Parent Contact', 'required': false},
        ]);
        _checklistItems.addAll([
          'Prepare games and activities',
          'Set up safe play area',
          'Have emergency contacts ready',
        ]);
        break;

      case MeetingType.personal:
        _formFields.addAll([
          {'type': 'text', 'label': 'Appointment Type', 'required': true},
          {'type': 'text', 'label': 'Provider Name', 'required': false},
          {'type': 'text', 'label': 'Insurance Info', 'required': false},
        ]);
        _checklistItems.addAll([
          'Bring ID and insurance card',
          'Prepare questions to ask',
          'Arrive 15 minutes early',
        ]);
        break;

      case MeetingType.openCall:
        _formFields.addAll([
          {'type': 'text', 'label': 'Topic', 'required': true},
          {'type': 'text', 'label': 'Join Link', 'required': true},
          {'type': 'text', 'label': 'Max Participants', 'required': false},
        ]);
        _checklistItems.addAll([
          'Prepare discussion points',
          'Set up moderation tools',
          'Test join link',
        ]);
        break;

      default:
        // One-on-One and Group meetings
        _formFields.addAll([
          {'type': 'text', 'label': 'Agenda', 'required': false},
          {'type': 'text', 'label': 'Meeting Link', 'required': false},
        ]);
        _checklistItems.addAll([
          'Prepare talking points',
          'Set meeting reminder',
        ]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final meetingState = ref.watch(REDACTED_TOKEN);
    final meetingType = meetingState.meetingType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes & Forms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add details and prepare for your meeting',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Meeting Type: ${meetingType.displayName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: meetingType.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notes Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.note,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Notes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _notesController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText:
                                    'Add any notes or additional information...',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                ref
                                    .read(REDACTED_TOKEN
                                        .notifier)
                                    .setNotes(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dynamic Form Fields
                    if (_formFields.isNotEmpty) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Meeting Details',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ..._formFields.map((field) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: field['label'],
                                        border: const OutlineInputBorder(),
                                        suffixIcon: field['required'] == true
                                            ? const Icon(
                                                Icons.star,
                                                color: Colors.red,
                                                size: 16,
                                              )
                                            : null,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Checklist Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.checklist,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Preparation Checklist',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _addChecklistItem,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ..._checklistItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return CheckboxListTile(
                                title: Text(item),
                                value: false, // TODO: Track completion state
                                onChanged: (value) {
                                  // TODO: Update completion state
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                secondary: IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () => _removeChecklistItem(index),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveFormData();
                  widget.onNext();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addChecklistItem() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Checklist Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Item',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final item = controller.text.trim();
              if (item.isNotEmpty) {
                setState(() {
                  _checklistItems.add(item);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeChecklistItem(int index) {
    setState(() {
      _checklistItems.removeAt(index);
    });
  }

  void _saveFormData() {
    // Save notes
    ref
        .read(REDACTED_TOKEN.notifier)
        .setNotes(_notesController.text);

    // TODO: Save form fields and checklist data
    // This would be implemented based on your data model
  }
}






