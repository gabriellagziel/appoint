import 'package:appoint/models/appointment.dart';
import 'package:appoint/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarSyncScreen extends ConsumerWidget {
  const CalendarSyncScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final appt = ModalRoute.of(context)!.settings.arguments! as Appointment;
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment: ${appt.id}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(calendarServiceProvider).syncToGoogle(appt);
              },
              child: const Text('Sync to Google'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.read(calendarServiceProvider).syncToOutlook(appt);
              },
              child: const Text('Sync to Outlook'),
            ),
          ],
        ),
      ),
    );
  }
}
