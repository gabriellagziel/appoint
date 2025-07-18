import 'package:appoint/features/studio_business/models/business_event.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(username): Replace with real bookings from business service
    final upcomingBookings = <BusinessEvent>[];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 32, logoOnly: true),
            const SizedBox(width: 12),
            const Text('Business Dashboard'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Upcoming Bookings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            if (upcomingBookings.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No upcoming bookings'),
                    ],
                  ),
                ),
              )
            else
              ...upcomingBookings.map((event) => Card(
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text(
                          '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} → ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',),
                      trailing: Text(event.type),
                    ),
                  ),),
            const Divider(height: 32),
            const Text('Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
