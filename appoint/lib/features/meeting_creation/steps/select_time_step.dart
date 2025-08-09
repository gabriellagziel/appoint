import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_meeting_flow_controller.dart';

class SelectTimeStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const SelectTimeStep({
    super.key,
    required this.onNext,
  });

  @override
  ConsumerState<SelectTimeStep> createState() => _SelectTimeStepState();
}

class _SelectTimeStepState extends ConsumerState<SelectTimeStep> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int selectedDurationMinutes = 60;
  RecurrenceType selectedRecurrence = RecurrenceType.none;

  @override
  void initState() {
    super.initState();
    // Set default to tomorrow at 9 AM
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    selectedTime = const TimeOfDay(hour: 9, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final meetingState = ref.watch(REDACTED_TOKEN);
    final controller = ref.read(REDACTED_TOKEN.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When is your meeting?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Select date, time, and duration',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // Date Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Date',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : 'Select date',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Time',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : 'Select time',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Duration Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Duration',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedDurationMinutes,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 15, child: Text('15 minutes')),
                      DropdownMenuItem(
                          value: 30, child: Text('30 minutes')),
                      DropdownMenuItem(value: 60, child: Text('1 hour')),
                      DropdownMenuItem(
                          value: 90, child: Text('1.5 hours')),
                      DropdownMenuItem(
                          value: 120, child: Text('2 hours')),
                      DropdownMenuItem(
                          value: 180, child: Text('3 hours')),
                      DropdownMenuItem(
                          value: 240, child: Text('4 hours')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDurationMinutes = value;
                        });
                        controller.setDurationMinutes(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recurrence Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.repeat, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Recurrence',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: RecurrenceType.values.map((recurrence) {
                      final isSelected = selectedRecurrence == recurrence;
                      return ChoiceChip(
                        label: Text(_getRecurrenceLabel(recurrence)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedRecurrence = recurrence;
                            });
                            controller.setRecurrence(recurrence);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Back button - handled by parent
                  },
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.canContinueFromCurrentStep()
                      ? widget.onNext
                      : null,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRecurrenceLabel(RecurrenceType recurrence) {
    switch (recurrence) {
      case RecurrenceType.none:
        return 'None';
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.custom:
        return 'Custom';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _updateDateTime();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      _updateDateTime();
    }
  }

  void _updateDateTime() {
    if (selectedDate != null && selectedTime != null) {
      final controller = ref.read(REDACTED_TOKEN.notifier);
      final dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      controller.setDateTime(dateTime);
    }
  }
}
