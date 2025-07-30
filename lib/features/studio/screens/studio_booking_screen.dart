import 'package:appoint/features/studio/providers/staff_availability_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StudioBookingScreen extends ConsumerWidget {
  const StudioBookingScreen({super.key});
  static const routeName = '/studio/booking';

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final asyncSlots = ref.watch(staffAvailabilityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Studio Booking')),
      body: asyncSlots.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final st) => Center(child: Text('Error: $e')),
        data: (slots) {
          if (slots.isEmpty) {
            return const Center(child: Text('No available slots'));
          }
          return ListView.builder(
            itemCount: slots.length,
            itemBuilder: (ctx, final i) {
              final slot = slots[i];
              final formatted = DateFormat.Hm().format;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  title: Text(
                    '${formatted(slot.startTime)} – ${formatted(slot.endTime)}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: slot.isBooked
                        ? null
                        : () {
                            // TODO(username): Implement actual booking logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Booking slot: ${formatted(slot.startTime)}',
                                ),
                              ),
                            );
                          },
                    child: Text(slot.isBooked ? 'Booked' : 'Book'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
