import 'package:flutter/material.dart';
import '../models/business_event.dart';

class BusinessCalendarScreen extends StatefulWidget {
  const BusinessCalendarScreen({Key? key}) : super(key: key);

  @override
  State<BusinessCalendarScreen> createState() => _BusinessCalendarScreenState();
}

class _BusinessCalendarScreenState extends State<BusinessCalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<BusinessEvent> _mockEvents = [
    BusinessEvent(
      id: '1',
      title: 'Team Meeting',
      description: 'Discuss project updates',
      type: 'Meeting',
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
    ),
    BusinessEvent(
      id: '2',
      title: 'Client Call',
      description: 'Call with client',
      type: 'Call',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
    ),
    BusinessEvent(
      id: '3',
      title: 'Studio Session',
      description: 'Music recording',
      type: 'Session',
      startTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 5)),
    ),
  ];

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
  Widget build(BuildContext context) {
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
    return ListView.builder(
      itemCount: _mockEvents.length,
      itemBuilder: (context, idx) {
        final event = _mockEvents[idx];
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
    // For mock, just show all events in a grid
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      childAspectRatio: 3,
      children: _mockEvents
          .map((event) => Card(
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
    // For mock, just show all events in a grid
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      childAspectRatio: 1.5,
      children: _mockEvents
          .map((event) => Card(
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
