import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import 'booking_request_screen.dart';

class BookingConfirmScreen extends ConsumerWidget {
  const BookingConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BookingRequestArgs;
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invitee: ${args.inviteeId}'),
            const SizedBox(height: 8),
            if (args.openCall)
              const Text('Type: Open Call')
            else
              Text('Scheduled at: ${args.scheduledAt}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final user = await ref.read(authServiceProvider).currentUser();
                if (user == null) return;
                if (args.openCall) {
                  await ref
                      .read(appointmentServiceProvider)
                      .createOpenCallRequest(
                        creatorId: user.uid,
                        inviteeId: args.inviteeId,
                      );
                } else {
                  await ref.read(appointmentServiceProvider).createScheduled(
                        creatorId: user.uid,
                        inviteeId: args.inviteeId,
                        scheduledAt: args.scheduledAt ?? DateTime.now(),
                      );
                }
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Confirm'),
            )
          ],
        ),
      ),
    );
  }
}
