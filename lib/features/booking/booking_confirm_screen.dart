import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../models/appointment.dart';
import '../../providers/notification_provider.dart';
import 'booking_request_screen.dart';

class BookingConfirmScreen extends StatefulWidget {
  const BookingConfirmScreen({Key? key}) : super(key: key);

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  bool _syncGoogle = false;
  bool _syncOutlook = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BookingRequestArgs;
    return Consumer(builder: (context, ref, _) {
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
              SwitchListTile(
                title: const Text('Sync to Google'),
                value: _syncGoogle,
                onChanged: (v) => setState(() => _syncGoogle = v),
              ),
              SwitchListTile(
                title: const Text('Sync to Outlook'),
                value: _syncOutlook,
                onChanged: (v) => setState(() => _syncOutlook = v),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final user = await ref.read(authServiceProvider).currentUser();
                  if (user == null) return;
                  late final Appointment appt;
                  if (args.openCall) {
                    appt = await ref
                        .read(appointmentServiceProvider)
                        .createOpenCallRequest(
                          creatorId: user.uid,
                          inviteeId: args.inviteeId,
                        );
                  } else {
                    appt = await ref
                        .read(appointmentServiceProvider)
                        .createScheduled(
                          creatorId: user.uid,
                          inviteeId: args.inviteeId,
                          scheduledAt: args.scheduledAt ?? DateTime.now(),
                        );
                  }
                  if (_syncGoogle) {
                    await ref.read(calendarServiceProvider).syncToGoogle(appt);
                  }
                  if (_syncOutlook) {
                    await ref.read(calendarServiceProvider).syncToOutlook(appt);
                  }
                  await ref
                      .read(notificationServiceProvider)
                      .sendNotificationToUser(
                          args.inviteeId,
                          'Booking Confirmed',
                          'You have a new booking request');
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Confirm'),
              )
            ],
          ),
        ),
      );
    });
  }
}
