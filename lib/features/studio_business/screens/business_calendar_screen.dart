import 'package:appoint/features/studio_business/models/business_event.dart';
import 'package:flutter/material.dart';

class BusinessCalendarScreen extends StatefulWidget {
  const BusinessCalendarScreen({super.key});

  @override
  State<BusinessCalendarScreen> createState() => _BusinessCalendarScreenState();
}

class _BusinessCalendarScreenState extends State<BusinessCalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO(username): Replace with real calendar data from business service
  final List<BusinessEvent> _events = [];

  @override
  void initState() {
    super.initState();
    final _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout based on screen width
        if (constraints.maxWidth > 800) {
          // Tablet/Desktop: Show events in a grid layout
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 1200 ? 3 : 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              event.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (event.description.isNotEmpty) ...[
                        Text(
                          event.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - '
                            '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4,),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              event.type,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // Phone: Show events in a list layout
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.event,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - '
                        '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.type,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              );
            },
          );
        }
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen width
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth > 1200) {
          // Large desktop/tablet landscape
          final crossAxisCount = 4;
          final childAspectRatio = 2.5;
        } else if (constraints.maxWidth > 800) {
          // Tablet
          final crossAxisCount = 3;
          final childAspectRatio = 2.8;
        } else if (constraints.maxWidth > 600) {
          // Large phone/small tablet
          final crossAxisCount = 2;
          final childAspectRatio = 3.0;
        } else {
          // Phone
          final crossAxisCount = 1;
          final childAspectRatio = 3.5;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (event.description.isNotEmpty)
                      Expanded(
                        child: Text(
                          event.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - '
                      '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen width
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth > 1200) {
          // Large desktop/tablet landscape
          final crossAxisCount = 6;
          final childAspectRatio = 1.2;
        } else if (constraints.maxWidth > 800) {
          // Tablet
          final crossAxisCount = 4;
          final childAspectRatio = 1.3;
        } else if (constraints.maxWidth > 600) {
          // Large phone/small tablet
          final crossAxisCount = 3;
          final childAspectRatio = 1.4;
        } else {
          // Phone
          final crossAxisCount = 2;
          final childAspectRatio = 1.5;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      color: Theme.of(context).colorScheme.primary,
                      size: constraints.maxWidth > 600 ? 24 : 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.type,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (constraints.maxWidth > 600) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
