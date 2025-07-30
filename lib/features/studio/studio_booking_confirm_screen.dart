import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import 'studio_booking_screen.dart';
import '../../widgets/bottom_sheet_manager.dart';
import '../../widgets/booking_confirmation_sheet.dart';

class StudioBookingConfirmScreen extends ConsumerWidget {
  const StudioBookingConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as StudioBookingSelection;
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Staff: ${args.staff.displayName}'),
            Text('Date: ${args.date.toLocal().toString().split(' ')[0]}'),
            Text('Time: ${args.slot.format(context)}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final summary =
                    'You are about to book with ${args.staff.displayName} on '
                    '${args.date.toLocal().toString().split(' ')[0]} at '
                    '${args.slot.format(context)}.';
                BottomSheetManager.show(
                  context: context,
                  child: BookingConfirmationSheet(
                    summaryText: summary,
                    onCancel: () => Navigator.of(context).pop(),
                    onConfirm: () async {
                      Navigator.of(context).pop();
                      final user =
                          await ref.read(authServiceProvider).currentUser();
                      if (user == null) return;
                      await ref
                          .read(appointmentServiceProvider)
                          .createScheduled(
                            creatorId: user.uid,
                            inviteeId: args.staff.id,
                            scheduledAt: DateTime(
                              args.date.year,
                              args.date.month,
                              args.date.day,
                              args.slot.hour,
                              args.slot.minute,
                            ),
                          );
                      if (context.mounted) {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    },
                  ),
                );
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
