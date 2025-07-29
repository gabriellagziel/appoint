import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final calendarFormatProvider =
    StateProvider<CalendarFormat>((ref) => CalendarFormat.month);

final eventsProvider =
    FutureProvider<Map<DateTime, List<CalendarEvent>>>((ref) async {
  // TODO: Implement real events from booking service
  final now = DateTime.now();
  final events = <DateTime, List<CalendarEvent>>{};

  // Add sample events
  final today = DateTime(now.year, now.month, now.day);
  events[today] = [
    CalendarEvent(
      id: '1',
      title: 'Meeting with Dr. Smith',
      description: 'Annual checkup appointment',
      startTime: DateTime(now.year, now.month, now.day, 10),
      endTime: DateTime(now.year, now.month, now.day, 11),
      type: EventType.booking,
      color: Colors.blue,
    ),
    CalendarEvent(
      id: '2',
      title: 'Studio Session',
      description: 'Photography session at Studio Beauty',
      startTime: DateTime(now.year, now.month, now.day, 14),
      endTime: DateTime(now.year, now.month, now.day, 16),
      type: EventType.booking,
      color: Colors.green,
    ),
  ];

  final tomorrow = today.add(const Duration(days: 1));
  events[tomorrow] = [
    CalendarEvent(
      id: '3',
      title: 'Family Meeting',
      description: 'Weekly family coordination meeting',
      startTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18),
      endTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 19),
      type: EventType.family,
      color: Colors.orange,
    ),
  ];

  return events;
});

class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.color,
    this.location,
    this.attendees,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final EventType type;
  final Color color;
  final String? location;
  final List<String>? attendees;
}

enum EventType {
  booking,
  meeting,
  family,
  reminder,
  payment,
}

class EnhancedCalendarScreen extends ConsumerWidget {
  const EnhancedCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = ref.watch(selectedDayProvider);
    final focusedDay = ref.watch(focusedDayProvider);
    final calendarFormat = ref.watch(calendarFormatProvider);
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addEvent(context),
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () => _goToToday(ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(context, ref, selectedDay, focusedDay, calendarFormat,
              eventsAsync),
          _buildEventsList(context, ref, selectedDay, eventsAsync),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDay,
    DateTime focusedDay,
    CalendarFormat calendarFormat,
    AsyncValue<Map<DateTime, List<CalendarEvent>>> eventsAsync,
  ) =>
      Card(
        margin: const EdgeInsets.all(16),
        child: TableCalendar<CalendarEvent>(
          firstDay: DateTime.utc(2020),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          eventLoader: (day) => eventsAsync.when(
            data: (events) => events[day] ?? [],
            loading: () => [],
            error: (_, __) => [],
          ),
          onDaySelected: (selectedDay, focusedDay) {
            ref.read(selectedDayProvider.notifier).state = selectedDay;
            ref.read(focusedDayProvider.notifier).state = focusedDay;
          },
          onFormatChanged: (format) {
            ref.read(calendarFormatProvider.notifier).state = format;
          },
          onPageChanged: (focusedDay) {
            ref.read(focusedDayProvider.notifier).state = focusedDay;
          },
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            weekendTextStyle: TextStyle(color: Colors.red),
          ),
          headerStyle: const HeaderStyle(
            titleCentered: true,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    width: 8,
                    height: 8,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      );

  Widget _buildEventsList(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDay,
    AsyncValue<Map<DateTime, List<CalendarEvent>>> eventsAsync,
  ) =>
      Expanded(
        child: eventsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text('Failed to load events'),
                const SizedBox(height: 8),
                Text(error.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(eventsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (events) {
            final dayEvents = events[selectedDay] ?? [];

            if (dayEvents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No events for ${_formatDate(selectedDay)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add an event',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dayEvents.length,
              itemBuilder: (context, index) {
                final event = dayEvents[index];
                return _buildEventCard(context, event);
              },
            );
          },
        ),
      );

  Widget _buildEventCard(BuildContext context, CalendarEvent event) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          title: Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.description),
              const SizedBox(height: 4),
              Text(
                '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (event.location != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      event.location!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _handleEventAction(context, value, event),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
          onTap: () => _viewEventDetails(context, event),
        ),
      );

  String _formatDate(DateTime date) => '${date.month}/${date.day}/${date.year}';

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12
        ? hour - 12
        : hour == 0
            ? 12
            : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  void _addEvent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: _buildAddEventForm,
    );
  }

  Widget _buildAddEventForm(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Event',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Location (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Event added successfully!')),
                    );
                  },
                  child: const Text('Add Event'),
                ),
              ],
            ),
          ],
        ),
      );

  void _goToToday(WidgetRef ref) {
    final today = DateTime.now();
    ref.read(selectedDayProvider.notifier).state = today;
    ref.read(focusedDayProvider.notifier).state = today;
  }

  void _viewEventDetails(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description),
            const SizedBox(height: 16),
            Text('Date: ${_formatDate(event.startTime)}'),
            Text(
                'Time: ${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}'),
            if (event.location != null) Text('Location: ${event.location}'),
            if (event.attendees != null && event.attendees!.isNotEmpty)
              Text('Attendees: ${event.attendees!.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _editEvent(context, event);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editEvent(BuildContext context, CalendarEvent event) {
    // TODO: Implement edit event
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit event coming soon!')),
    );
  }

  void _handleEventAction(
      BuildContext context, String action, CalendarEvent event) {
    switch (action) {
      case 'edit':
        _editEvent(context, event);
      case 'delete':
        _deleteEvent(context, event);
      case 'share':
        _shareEvent(context, event);
    }
  }

  void _deleteEvent(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event deleted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareEvent(BuildContext context, CalendarEvent event) {
    // TODO: Implement share event
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share event coming soon!')),
    );
  }
}
