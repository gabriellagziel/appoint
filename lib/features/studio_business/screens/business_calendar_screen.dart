import 'package:flutter/material.dart';
import 'package:appoint/features/studio_business/models/business_event.dart';

class BusinessCalendarScreen extends StatefulWidget {
  const BusinessCalendarScreen({super.key});

  @override
  State<BusinessCalendarScreen> createState() => _BusinessCalendarScreenState();
}

class _BusinessCalendarScreenState extends State<BusinessCalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: Replace with real calendar data from business service
  final List<BusinessEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Calendar'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Day', icon: Icon(Icons.view_day)),
            Tab(text: 'Week', icon: Icon(Icons.view_week)),
            Tab(text: 'Month', icon: Icon(Icons.calendar_month)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDayView(),
          _buildWeekView(),
          _buildMonthView(),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    if (_events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No events scheduled for today'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (final context, final idx) {
        final event = _events[idx];
        return ListTile(
          leading: const Icon(Icons.event),
          title: Text(event.title),
          subtitle: Text(
              '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - '
              '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}'),
          trailing: Text(event.type),
        );
      },
    );
  }

  Widget _buildWeekView() {
    if (_events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_week, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No events scheduled this week'),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      childAspectRatio: 3,
      children: _events
          .map((final event) => Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available),
                  title: Text(event.title),
                  subtitle: Text(event.description),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMonthView() {
    if (_events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No events scheduled this month'),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      childAspectRatio: 1.5,
      children: _events
          .map((final event) => Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 8),
                    Text(event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(event.type, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
