import 'package:appoint/features/studio/models/slot.dart';
import 'package:appoint/features/studio/providers/staff_availability_provider.dart';
import 'package:appoint/features/studio/screens/slot_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StaffAvailabilityScreen extends ConsumerWidget {
  const StaffAvailabilityScreen({super.key});
  static const routeName = '/studio/staff-availability';

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final asyncSlots = ref.watch(staffSlotsWithIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Staff Availability'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: asyncSlots.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $e', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(staffSlotsWithIdProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (slots) {
          if (slots.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No availability slots found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first slot',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: slots.length,
            itemBuilder: (context, final index) {
              final slot = slots[index];
              final dateFormat = DateFormat('MMM dd, yyyy');
              final timeFormat = DateFormat('HH:mm');

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    dateFormat.format(slot.startTime),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${timeFormat.format(slot.startTime)} – ${timeFormat.format(slot.endTime)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            slot.isBooked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 16,
                            color: slot.isBooked ? Colors.orange : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            slot.isBooked ? 'Booked' : 'Available',
                            style: TextStyle(
                              color:
                                  slot.isBooked ? Colors.orange : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showSlotDialog(context, ref, slot: slot),
                        tooltip: 'Edit slot',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, ref, slot.id),
                        tooltip: 'Delete slot',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSlotDialog(context, ref),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSlotDialog(
    final BuildContext context,
    final WidgetRef ref, {
    SlotWithId? slot,
  }) {
    showDialog(
      context: context,
      builder: (context) => SlotDialog(slot: slot),
    );
  }

  void _confirmDelete(
    BuildContext context,
    final WidgetRef ref,
    final String slotId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Slot'),
        content: const Text(
          'Are you sure you want to delete this availability slot?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteSlot(context, ref, slotId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSlot(
    final BuildContext context,
    final WidgetRef ref,
    String slotId,
  ) async {
    try {
      final service = ref.read(staffAvailabilityServiceProvider);
      await service.deleteSlot(slotId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Slot deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting slot: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
