import 'dart:core';

import 'package:appoint/features/booking/models/booking_request_args.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/providers/appointment_provider.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/calendar_provider.dart';
import 'package:appoint/providers/notification_provider.dart';
import 'package:appoint/services/maps_service.dart';
import 'package:appoint/widgets/whatsapp_share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key});

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  bool _syncGoogle = false;
  bool _syncOutlook = false;
  Appointment? _createdAppointment;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments! as BookingRequestArgs;
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Stack(
        children: [
          Padding(
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
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: MapsService.initialPosition,
                    onMapCreated: (_) {},
                    myLocationEnabled: true,
                  ),
                ),
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
                if (_createdAppointment != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Share your meeting invitation:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  WhatsAppShareButton(
                    appointment: _createdAppointment!,
                    customMessage:
                        "Hey! I've scheduled a meeting with you through APP-OINT. Click here to confirm or suggest a different time:",
                    onShared: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Meeting shared successfully!'),
                          backgroundColor: Color(0xFF25D366),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: () async {
                      final user = ref.read(authProvider).currentUser;
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
                              scheduledAt:
                                  args.scheduledAt ?? DateTime.now(),
                            );
                      }

                      // Store the created appointment for sharing
                      setState(() {
                        _createdAppointment = appt;
                      });

                      if (_syncGoogle) {
                        await ref
                            .read(calendarServiceProvider)
                            .syncToGoogle(appt);
                      }
                      if (_syncOutlook) {
                        await ref
                            .read(calendarServiceProvider)
                            .syncToOutlook(appt);
                      }
                      if (!mounted) return;
                      
                      // Send local notification when booking is confirmed
                      try {
                        await ref.read(notificationHelperProvider).sendLocalNotification(
                          title: 'Booking Confirmed',
                          body: 'Your booking has been confirmed successfully!',
                          payload: 'booking_confirmed',
                        );
                      } catch (e) {
                        debugPrint('Error sending notification: $e');
                      }

                      // Show success message
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Booking confirmed! You can now share the invitation.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
