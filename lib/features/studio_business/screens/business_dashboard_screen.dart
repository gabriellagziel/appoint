import 'package:flutter/material.dart';
import 'package:appoint/features/studio_business/models/business_event.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample mocked bookings
    final List<BusinessEvent> upcomingBookings = [
      BusinessEvent(
        id: 'b1',
        title: 'Yoga Class',
        description: 'Beginner session',
        type: 'group',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
      ),
      BusinessEvent(
        id: 'b2',
        title: 'Personal Coaching',
        description: '1-on-1 session',
        type: 'private',
        startTime: DateTime.now().add(const Duration(days: 1)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Upcoming Bookings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...upcomingBookings.map((event) => Card(
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(
                        '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} → ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}'),
                    trailing: Text(event.type),
                  ),
                )),
            const Divider(height: 32),
            const Text('Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/business/calendar'),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Calendar'),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/business/availability'),
                  icon: const Icon(Icons.access_time),
                  label: const Text('Availability'),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/business/profile'),
                  icon: const Icon(Icons.person),
                  label: const Text('Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
