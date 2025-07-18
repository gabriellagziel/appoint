import 'package:appoint/models/staff_availability.dart';
import 'package:appoint/providers/REDACTED_TOKEN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({required this.staffId, super.key});
  final String staffId;

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  DateTime _selectedDate = DateTime.now();
  final _slotController = TextEditingController();

  Future<void> _addSlot() async {
    final slot = _slotController.text;
    if (slot.isEmpty) return;
    final avail = StaffAvailability(
      staffId: widget.staffId,
      date: _selectedDate,
      availableSlots: [slot],
    );
    await ref
        .read(staffAvailabilityProvider(widget.staffId).notifier)
        .save(avail);
    _slotController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final availabilityAsync =
        ref.watch(staffAvailabilityProvider(widget.staffId));
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Availability')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                  child: const Text('Pick Date'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _slotController,
                    decoration: const InputDecoration(
                      labelText: 'HH:MM'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSlot,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: availabilityAsync.when(
              data: (list) {
                final todays = list
                    .where((a) =>
                        a.date.year == _selectedDate.year &&
                        a.date.month == _selectedDate.month &&
                        a.date.day == _selectedDate.day,)
                    .toList();
                if (todays.isEmpty) {
                  return const Center(child: Text('No slots'));
                }
                final slots =
                    todays.expand((a) => a.availableSlots ?? []).toList();
                return ListView.builder(
                  itemCount: slots.length,
                  itemBuilder: (context, final index) {
                    final slot = slots[index];
                    return ListTile(
                      title: Text(slot),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await ref
                              .read(staffAvailabilityProvider(widget.staffId)
                                  .notifier,)
                              .delete(_selectedDate);
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, final _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
