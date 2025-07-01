import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart';

import 'package:appoint/providers/google_calendar_provider.dart';

class GoogleIntegrationScreen extends ConsumerStatefulWidget {
  const GoogleIntegrationScreen({final Key? key}) : super(key: key);

  @override
  ConsumerState<GoogleIntegrationScreen> createState() =>
      _GoogleIntegrationScreenState();
}

class _GoogleIntegrationScreenState
    extends ConsumerState<GoogleIntegrationScreen> {
  List<CalendarListEntry> _calendars = [];

  Future<void> _connect() async {
    final service = ref.read(googleCalendarServiceProvider);
    await service.signInWithGoogleCalendar();
    final cals = await service.getCalendars();
    setState(() => _calendars = cals);
  }

  Future<void> _addEvent(final String calendarId) async {
    final service = ref.read(googleCalendarServiceProvider);
    await service.createEvent(
      calendarId,
      summary: 'Test Event',
      start: DateTime.now().add(const Duration(minutes: 1)),
      end: DateTime.now().add(const Duration(minutes: 31)),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created')),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _connect,
              child: const Text('Connect to Google Calendar'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _calendars.length,
                itemBuilder: (final context, final index) {
                  final cal = _calendars[index];
                  return ListTile(
                    title: Text(cal.summary ?? ''),
                    subtitle: Text(cal.id ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addEvent(cal.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
