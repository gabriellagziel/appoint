import 'package:appoint/features/booking/booking_helper.dart';
import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:appoint/features/selection/providers/selection_provider.dart';
import 'package:appoint/models/booking.dart';
import 'package:appoint/services/stripe_service.dart';
import 'package:appoint/services/usage_monitor.dart';
import 'package:appoint/utils/snackbar_extensions.dart';
import 'package:appoint/widgets/animations/fade_slide_in.dart';
import 'package:appoint/widgets/animations/tap_scale_feedback.dart';
import 'package:appoint/widgets/booking_confirmation_sheet.dart';
import 'package:appoint/widgets/booking_blocker_modal.dart';
import 'package:appoint/widgets/bottom_sheet_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Reset weekly count if needed when booking screen loads
    UsageMonitorService.resetWeeklyCountIfNeeded();
  }

  Future<void> _checkUsageLimitAndSubmit() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final weeklyCount = await ref.read(bookingServiceProvider).getWeeklyBookingCount(userId);
    
    if (weeklyCount >= 21) {
      _showUpgradeDialog();
    } else {
      _submitBooking();
    }
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Business'),
        content: const Text(
          'You have reached your weekly limit of 21 bookings. Upgrade to Business mode for unlimited bookings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                final checkoutUrl = await StripeService().fetchCheckoutUrl(userId);
                if (checkoutUrl != null) {
                  await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
                }
              }
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);

    try {
      // Check if user can create booking (usage limits)
      final canBook = await BookingHelper(ref).canCreateBooking();
      
      if (!canBook) {
        // Show business mode modal
        if (mounted) {
          final shouldUpgrade = await showBookingBlockerModal(context);
          if (shouldUpgrade == true) {
            // Use our Stripe integration for upgrade
            final userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null) {
              final checkoutUrl = await StripeService().fetchCheckoutUrl(userId);
              if (checkoutUrl != null) {
                await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
              } else {
                if (mounted) {
                  context.showSnackBar('Failed to load checkout. Please try again.');
                }
              }
            }
          }
        }
        return;
      }

      // Proceed with booking if allowed
      await BookingHelper(ref).submitBooking();
      
      if (!mounted) return;
      context.showSnackBar('Booking confirmed');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      context.showSnackBar('Failed to confirm booking',
          backgroundColor: Colors.red,);
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

    final summary =
        'You are about to book $serviceName with $staffId on ${DateFormat.yMMMEd().add_jm().format(dateTime)} for ${duration.inMinutes} minutes.';

    BottomSheetManager.show(
      context: context,
      child: BookingConfirmationSheet(
        summaryText: summary,
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () {
          Navigator.of(context).pop();
          _checkUsageLimitAndSubmit();
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chat Booking Button with tap feedback
            TapScaleFeedback(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/chat-booking'),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Book via Chat'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Staff: ${staffId ?? "Not selected"}'),
                    const SizedBox(height: 8),
                    Text('Service: ${serviceId ?? "Not selected"}'),
                    const SizedBox(height: 8),
                    Text(
                        'Date & Time: ${dateTime?.toLocal() ?? "Not selected"}',),
                    const SizedBox(height: 8),
                    Text('Duration: ${duration?.inMinutes ?? 0} minutes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TapScaleFeedback(
              child: ElevatedButton(
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
  Widget build(BuildContext context, final WidgetRef ref) {
    final bookingsStream = ref.watch(bookingServiceProvider).getBookings();

    return StreamBuilder<List<Booking>>(
      stream: bookingsStream,
      builder: (context, final snapshot) {
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
          itemBuilder: (context, final index) {
            final booking = bookingsList[index];
            return FadeSlideIn(
              delay: Duration(milliseconds: 50 * index),
              child: Card(
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
              ),
            );
          },
        );
      },
    );
  }
}
