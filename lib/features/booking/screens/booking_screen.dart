import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking.dart';
import '../services/booking_service.dart';
import '../../../providers/auth_provider.dart';
import '../../selection/providers/selection_provider.dart';
import '../../../widgets/bottom_sheet_manager.dart';
import '../../../widgets/booking_confirmation_sheet.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  bool _isSubmitting = false;

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authProvider).currentUser;
      final userId = user?.uid ?? '';
      if (userId.isEmpty) throw Exception('User not logged in');

      final staffId = ref.read(staffSelectionProvider);
      final serviceId = ref.read(serviceSelectionProvider);
      final serviceName = ref.read(serviceNameProvider);
      final dateTime = ref.read(selectedSlotProvider);
      final duration = ref.read(serviceDurationProvider);

      if (staffId == null ||
          serviceId == null ||
          dateTime == null ||
          duration == null) {
        throw Exception('Missing required booking information');
      }

      final booking = Booking(
        id: '', // Will be set by Firestore
        userId: userId,
        staffId: staffId,
        serviceId: serviceId,
        serviceName: serviceName ?? 'Unknown Service',
        dateTime: dateTime,
        duration: duration,
        notes: null,
        createdAt: DateTime.now(),
      );

      await ref.read(bookingServiceProvider).submitBooking(booking);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed')),
      );
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint('Error during booking: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm booking')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffId = ref.watch(staffSelectionProvider);
    final serviceId = ref.watch(serviceSelectionProvider);
    final dateTime = ref.watch(selectedSlotProvider);
    final duration = ref.watch(serviceDurationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chat Booking Button
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/chat-booking'),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Book via Chat'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Staff: ${staffId ?? "Not selected"}'),
                    const SizedBox(height: 8),
                    Text('Service: ${serviceId ?? "Not selected"}'),
                    const SizedBox(height: 8),
                    Text(
                        'Date & Time: ${dateTime?.toLocal() ?? "Not selected"}'),
                    const SizedBox(height: 8),
                    Text('Duration: ${duration?.inMinutes ?? 0} minutes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (staffId != null &&
                      serviceId != null &&
                      dateTime != null &&
                      duration != null)
                  ? (_isSubmitting
                      ? null
                      : () {
                          final summary =
                              'You are about to book a ${duration!.inMinutes} minute appointment on '
                              '${dateTime!.toLocal()}.';
                          BottomSheetManager.show(
                            context: context,
                            child: BookingConfirmationSheet(
                              summaryText: summary,
                              onCancel: () => Navigator.of(context).pop(),
                              onConfirm: () {
                                Navigator.of(context).pop();
                                _submitBooking();
                              },
                            ),
                          );
                        })
                  : null,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit Booking'),
            ),
            const SizedBox(height: 24),
            const Expanded(
              child: BookingListView(),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingListView extends ConsumerWidget {
  const BookingListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsStream = ref.watch(bookingServiceProvider).getBookings();

    return StreamBuilder<List<Booking>>(
      stream: bookingsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading bookings: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookingsList = snapshot.data!;
        if (bookingsList.isEmpty) {
          return const Center(child: Text('No bookings found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: bookingsList.length,
          itemBuilder: (context, index) {
            final booking = bookingsList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('\uD83D\uDCC5 ${booking.dateTime.toLocal()}'),
                subtitle: Text(booking.notes ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => ref
                      .read(bookingServiceProvider)
                      .cancelBooking(booking.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
