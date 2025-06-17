import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../models/appointment.dart';
import '../../providers/notification_provider.dart';
import '../../providers/user_subscription_provider.dart';
import '../../services/ad_service.dart';
import '../../widgets/whatsapp_share_button.dart';
import 'models/booking_request_args.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  bool _syncGoogle = false;
  bool _syncOutlook = false;
  bool _isLoadingAd = false;
  Appointment? _createdAppointment;

  Future<void> _maybeShowAd() async {
    final isPremium = ref.read(userSubscriptionProvider).maybeWhen(
          data: (isPremium) => isPremium,
          orElse: () => false,
        );
    if (isPremium) return;
    setState(() => _isLoadingAd = true);
    try {
      await AdService.showInterstitialAd();
    } catch (_) {
      // continue even if ad fails
    } finally {
      if (mounted) setState(() => _isLoadingAd = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BookingRequestArgs;
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
                  onPressed: _isLoadingAd
                      ? null
                      : () async {
                          await _maybeShowAd();
                          final user =
                              await ref.read(authServiceProvider).currentUser();
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
                          await ref
                              .read(notificationServiceProvider)
                              .sendNotificationToUser(
                                  args.inviteeId,
                                  'Booking Confirmed',
                                  'You have a new booking request');

                          // Show success message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Booking confirmed! You can now share the invitation.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                  child: _isLoadingAd
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm'),
                ),
              ],
            ),
          ),
          if (_isLoadingAd)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Text(
                  'Loading ad... please wait',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
