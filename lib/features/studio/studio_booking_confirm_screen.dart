import 'package:appoint/features/studio/studio_booking_screen.dart';
import 'package:appoint/widgets/booking_confirmation_sheet.dart';
import 'package:appoint/widgets/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StudioBookingConfirmScreen extends ConsumerWidget {
  const StudioBookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments! as StudioBookingSelection;
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
                    'You are about to book with ${args.staff.displayName} on ${DateFormat.yMMMEd().add_jm().format(
                          DateTime(
                            args.date.year,
                            args.date.month,
                            args.date.day,
                            args.slot.hour,
                            args.slot.minute,
                          ),
                        )}.';
                BottomSheetManager.show(
                  context: context,
                  child: BookingConfirmationSheet(
                    summaryText: summary,
                    onCancel: () => Navigator.of(context).pop(),
                    onConfirm: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
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
