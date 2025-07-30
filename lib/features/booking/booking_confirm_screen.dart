import 'dart:core';

import 'package:appoint/features/booking/models/booking_request_args.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/providers/appointment_provider.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/calendar_provider.dart';
import 'package:appoint/providers/notification_provider.dart';
import 'package:appoint/services/maps_service.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:appoint/widgets/business_header_widget.dart';
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
      appBar: AppBar(
        title: const Row(
          children: [
            AppLogo(size: 24, logoOnly: true),
            SizedBox(width: 8),
            Text('Confirm Booking'),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Header - Show business branding
                const BusinessHeaderWidget(
                  showHours: true,
                ),

                const SizedBox(height: 24),

                // Booking Details Section
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.event_note,
                              color: Colors.blue.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Booking Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.person,
                          label: 'Client ID',
                          value: args.inviteeId,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          icon: args.openCall ? Icons.call : Icons.schedule,
                          label: 'Appointment Type',
                          value: args.openCall
                              ? 'Open Call'
                              : 'Scheduled Appointment',
                        ),
                        if (!args.openCall && args.scheduledAt != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.access_time,
                            label: 'Scheduled Time',
                            value: _formatDateTime(args.scheduledAt!),
                          ),
                        ],
                        if (args.serviceType != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.medical_services,
                            label: 'Service Type',
                            value: args.serviceType!,
                          ),
                        ],
                        if (args.notes != null && args.notes!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.note,
                            label: 'Notes',
                            value: args.notes!,
                            multiline: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Location Section (if available)
                if (args.location != null) ...[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.green.shade600,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Meeting Location',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: GoogleMap(
                              initialCameraPosition:
                                  MapsService.initialPosition,
                              onMapCreated: (_) {},
                              myLocationEnabled: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Calendar Sync Options
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.sync,
                              color: Colors.orange.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Calendar Integration',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose which calendars to sync this appointment with:',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text('Sync to Google Calendar'),
                          subtitle: const Text('Add to your Google Calendar'),
                          secondary: Image.asset(
                            'assets/images/google_calendar_icon.png',
                            width: 32,
                            height: 32,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.calendar_today,
                                    color: Colors.blue),
                          ),
                          value: _syncGoogle,
                          onChanged: (v) => setState(() => _syncGoogle = v),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: const Text('Sync to Outlook'),
                          subtitle: const Text('Add to your Outlook Calendar'),
                          secondary: Image.asset(
                            'assets/images/outlook_icon.png',
                            width: 32,
                            height: 32,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.calendar_month,
                                    color: Colors.indigo),
                          ),
                          value: _syncOutlook,
                          onChanged: (v) => setState(() => _syncOutlook = v),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),

                // Sharing Section (shown after booking is confirmed)
                if (_createdAppointment != null) ...[
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.purple.shade600,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Share Appointment',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade800,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Share your appointment details with the client:',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          WhatsAppShareButton(
                            appointment: _createdAppointment!,
                            customMessage:
                                'Hello! Your appointment has been confirmed through APP-OINT. Here are the details:',
                            onShared: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Appointment shared successfully!'),
                                  backgroundColor: Color(0xFF25D366),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _createdAppointment != null
                        ? null
                        : () => _confirmBooking(args),
                    icon: _createdAppointment != null
                        ? const Icon(Icons.check_circle)
                        : const Icon(Icons.event_available),
                    label: Text(
                      _createdAppointment != null
                          ? 'Booking Confirmed!'
                          : 'Confirm Booking',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _createdAppointment != null
                          ? Colors.green.shade600
                          : Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) =>
      Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: multiline ? null : 1,
                  overflow: multiline ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );

  String _formatDateTime(DateTime dateTime) {
    final weekday = _getWeekday(dateTime.weekday);
    final month = _getMonth(dateTime.month);
    final day = dateTime.day;
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$weekday, $month $day at $hour:$minute $period';
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _confirmBooking(BookingRequestArgs args) async {
    try {
      final user = ref.read(authProvider).currentUser;
      if (user == null) return;

      late final Appointment appt;
      if (args.openCall) {
        appt = await ref.read(appointmentServiceProvider).createOpenCallRequest(
              creatorId: user.uid,
              inviteeId: args.inviteeId,
            );
      } else {
        appt = await ref.read(appointmentServiceProvider).createScheduled(
              creatorId: user.uid,
              inviteeId: args.inviteeId,
              scheduledAt: args.scheduledAt ?? DateTime.now(),
            );
      }

      // Store the created appointment for sharing
      setState(() {
        _createdAppointment = appt;
      });

      // Sync to calendars if requested
      if (_syncGoogle) {
        await ref.read(calendarServiceProvider).syncToGoogle(appt);
      }
      if (_syncOutlook) {
        await ref.read(calendarServiceProvider).syncToOutlook(appt);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Booking confirmed! You can now share the appointment.'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Failed to confirm booking: $e'),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
