import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../booking_helper.dart';
import '../../selection/providers/selection_provider.dart';

class BookingRequestScreen extends ConsumerStatefulWidget {
  const BookingRequestScreen({super.key});

  @override
  ConsumerState<BookingRequestScreen> createState() =>
      _BookingRequestScreenState();
}

class _BookingRequestScreenState extends ConsumerState<BookingRequestScreen> {
  bool _isSubmitting = false;

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    try {
      await BookingHelper.submitBooking(context, ref);
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
      appBar: AppBar(title: const Text('Booking Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  ? (_isSubmitting ? null : _submitBooking)
                  : null,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
