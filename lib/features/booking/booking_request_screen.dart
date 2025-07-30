import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';
import 'services/booking_service.dart';
import '../../providers/auth_provider.dart';
import '../selection/providers/selection_provider.dart';
import '../../providers/minor_parent_provider.dart';

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
    final verified = ref.watch(minorParentProvider)?.isVerified ?? false;
    if (!verified) {
      Future.microtask(() =>
          Navigator.pushNamed(context, '/select-minor'));
      return const SizedBox.shrink();
    }
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
