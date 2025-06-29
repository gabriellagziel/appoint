import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../widgets/bottom_sheet_manager.dart';
import '../../widgets/booking_confirmation_sheet.dart';
import 'studio_booking_screen.dart';

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
              onPressed: () async {
                final summaryText = 'You are about to book a session on '
                    '${DateFormat.yMMMd().format(args.date)} at '
                    '${args.slot.format(context)} with ${args.staff.displayName}.';
                await BottomSheetManager.show(
                  context: context,
                  child: BookingConfirmationSheet(
                    summaryText: summaryText,
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
