import 'package:appoint/features/studio/models/slot.dart';
import 'package:appoint/features/studio/providers/staff_availability_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SlotDialog extends ConsumerStatefulWidget {
  const SlotDialog({super.key, this.slot});
  final SlotWithId? slot;

  @override
  ConsumerState<SlotDialog> createState() => _SlotDialogState();
}

class _SlotDialogState extends ConsumerState<SlotDialog> {
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.slot != null) {
      _date = DateTime(
        widget.slot!.startTime.year,
        widget.slot!.startTime.month,
        widget.slot!.startTime.day,
      );
      final _startTime = TimeOfDay.fromDateTime(widget.slot!.startTime);
      final _endTime = TimeOfDay.fromDateTime(widget.slot!.endTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.slot != null;
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEdit ? 'Edit Slot' : 'Create Slot',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 12),
            _buildTimePicker(context, isStart: true),
            const SizedBox(height: 12),
            _buildTimePicker(context, isStart: false),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saving ? null : _onSave,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: _saving
                ? null
                : () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date ?? now,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _date != null
                    ? DateFormat('MMM dd, yyyy').format(_date!)
                    : 'Select date',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(final BuildContext context,
      {required bool isStart,}) {
    final theme = Theme.of(context);
    final label = isStart ? 'Start Time' : 'End Time';
    final time = isStart ? _startTime : _endTime;
    return Row(
      children: [
        Icon(isStart ? Icons.play_arrow : Icons.stop, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: _saving
                ? null
                : () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: time ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        if (isStart) {
                          _startTime = picked;
                        } else {
                          _endTime = picked;
                        }
                      });
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time != null ? time.format(context) : label,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    if (_date == null || _startTime == null || _endTime == null) {
      _showSnackbar('Please select date, start and end time', isError: true);
      return;
    }
    final start = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final end = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _endTime!.hour,
      _endTime!.minute,
    );
    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      _showSnackbar('End time must be after start time', isError: true);
      return;
    }
    setState(() => _saving = true);
    final service = ref.read(REDACTED_TOKEN);
    try {
      if (widget.slot == null) {
        await service.addSlot(start, end);
        _showSnackbar('Slot created successfully');
      } else {
        await service.updateSlot(widget.slot!.id, start, end);
        _showSnackbar('Slot updated successfully');
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showSnackbar('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnackbar(String message, {final bool isError = false}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }
}
