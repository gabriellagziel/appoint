import 'package:appoint/features/studio/studio_booking_screen.dart';
import 'package:appoint/providers/appointment_provider.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/widgets/booking_confirmation_sheet.dart';
import 'package:appoint/widgets/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StudioConfirmScreen extends ConsumerWidget {
  const StudioConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final selection =
        ModalRoute.of(context)!.settings.arguments! as StudioBookingSelection;
    final scheduledAt = DateTime(
      selection.date.year,
      selection.date.month,
      selection.date.day,
      selection.slot.hour,
      selection.slot.minute,
    );
    Future<void> submitBooking() async {
      final user = await ref.read(authServiceProvider).currentUser();
      if (user == null) return;
      await ref.read(appointmentServiceProvider).createScheduled(
            creatorId: user.uid,
            inviteeId: selection.staff.id,
            scheduledAt: scheduledAt,
          );
      if (context.mounted) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }

    void showConfirmationSheet() {
      final summary =
          'You are about to book with ${selection.staff.displayName} on ${DateFormat.yMMMEd().add_jm().format(scheduledAt)}.';
      BottomSheetManager.show(
        context: context,
        child: BookingConfirmationSheet(
          summaryText: summary,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            submitBooking();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Staff: ${selection.staff.displayName}'),
            Text('Scheduled at: $scheduledAt'),
            const Spacer(),
            ElevatedButton(
              onPressed: showConfirmationSheet,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
