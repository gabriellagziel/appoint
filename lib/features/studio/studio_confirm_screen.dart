import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import 'studio_booking_screen.dart';

class StudioConfirmScreen extends ConsumerWidget {
  const StudioConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection =
        ModalRoute.of(context)!.settings.arguments as StudioBookingSelection;
    final scheduledAt = DateTime(
      selection.date.year,
      selection.date.month,
      selection.date.day,
      selection.slot.hour,
      selection.slot.minute,
    );
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
              onPressed: () async {
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
              },
              child: const Text('Confirm'),
            )
          ],
        ),
      ),
    );
  }
}
