import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../widgets/bottom_sheet_manager.dart';
import '../../../widgets/booking_confirmation_sheet.dart';
import '../booking_helper.dart';
import '../services/booking_service.dart';
import '../../selection/providers/selection_provider.dart';
import '../../../models/booking.dart';

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
      await BookingHelper.submitBooking(context, ref);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showConfirmationSheet() {
    final staffId = ref.read(staffSelectionProvider);
    final serviceName = ref.read(serviceNameProvider) ?? 'Service';
    final dateTime = ref.read(selectedSlotProvider);
    final duration = ref.read(serviceDurationProvider);
    if (staffId == null || dateTime == null || duration == null) return;

    final summary = 'You are about to book $serviceName with $staffId on ' +
        DateFormat.yMMMEd().add_jm().format(dateTime) +
        ' for ${duration.inMinutes} minutes.';

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
                  ? (_isSubmitting ? null : _showConfirmationSheet)
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
