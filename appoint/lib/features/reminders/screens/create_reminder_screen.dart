import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/reminder_controller.dart';
import '../models/reminder_model.dart';

class CreateReminderScreen extends ConsumerStatefulWidget {
  const CreateReminderScreen({super.key});

  @override
  ConsumerState<CreateReminderScreen> createState() =>
      _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  ReminderPriority _selectedPriority = ReminderPriority.medium;
  ReminderRecurrence _selectedRecurrence = ReminderRecurrence.none;
  String? _assignedTo;
  final List<String> _checklistItems = [];
  final List<String> _tags = [];
  bool _isFamilyReminder = false;

  @override
  void initState() {
    super.initState();
    // Set default to tomorrow at 9 AM
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reminder'),
        actions: [
          TextButton(
            onPressed: _saveReminder,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'What do you want to remember?',
                border: OutlineInputBorder(),
                hintText: 'e.g., Take medicine, Call mom, Buy groceries',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a reminder title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                hintText: 'Add more details...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Date & Time
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'When?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedDate != null
                                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                        : 'Select date',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedTime != null
                                        ? _selectedTime!.format(context)
                                        : 'Select time',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Priority
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: ReminderPriority.values.map((priority) {
                        final isSelected = _selectedPriority == priority;
                        return ChoiceChip(
                          label: Text(_getPriorityLabel(priority)),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            }
                          },
                          avatar: Icon(
                            priority.icon,
                            color: isSelected ? Colors.white : priority.color,
                            size: 16,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recurrence
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recurrence',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: ReminderRecurrence.values.map((recurrence) {
                        final isSelected = _selectedRecurrence == recurrence;
                        return ChoiceChip(
                          label: Text(_getRecurrenceLabel(recurrence)),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedRecurrence = recurrence;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Assignment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assign to',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Myself'),
                          selected: _assignedTo == null,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _assignedTo = null;
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Mom'),
                          selected: _assignedTo == 'mom',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _assignedTo = 'mom';
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Dad'),
                          selected: _assignedTo == 'dad',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _assignedTo = 'dad';
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Child'),
                          selected: _assignedTo == 'child',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _assignedTo = 'child';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Family Reminder Toggle
            SwitchListTile(
              title: const Text('Family Reminder'),
              subtitle: const Text('Share this reminder with family members'),
              value: _isFamilyReminder,
              onChanged: (value) {
                setState(() {
                  _isFamilyReminder = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Tags
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildTagChip('health'),
                        _buildTagChip('work'),
                        _buildTagChip('family'),
                        _buildTagChip('shopping'),
                        _buildTagChip('personal'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final isSelected = _tags.contains(tag);
    return FilterChip(
      label: Text(tag),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _tags.add(tag);
          } else {
            _tags.remove(tag);
          }
        });
      },
    );
  }

  String _getPriorityLabel(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.low:
        return 'Low';
      case ReminderPriority.medium:
        return 'Medium';
      case ReminderPriority.high:
        return 'High';
      case ReminderPriority.urgent:
        return 'Urgent';
    }
  }

  String _getRecurrenceLabel(ReminderRecurrence recurrence) {
    switch (recurrence) {
      case ReminderRecurrence.none:
        return 'None';
      case ReminderRecurrence.daily:
        return 'Daily';
      case ReminderRecurrence.weekly:
        return 'Weekly';
      case ReminderRecurrence.monthly:
        return 'Monthly';
      case ReminderRecurrence.custom:
        return 'Custom';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final dueDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final controller = ref.read(reminderControllerProvider.notifier);
    final success = await controller.createReminder(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      dueDate: dueDateTime,
      createdBy: 'user1', // TODO: Get from auth
      assignedTo: _assignedTo,
      priority: _selectedPriority,
      recurrence: _selectedRecurrence,
      tags: _tags,
      isFamilyReminder: _isFamilyReminder,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create reminder'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
