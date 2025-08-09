import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/day_agenda_list.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Calendar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Week'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Today view
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(calendarControllerProvider);

              return state.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                data: (agenda) => DayAgendaList(
                  agenda: agenda,
                  onMeetingTap: (meetingId) {
                    // Navigate to meeting details
                    Navigator.of(context).pushNamed(
                      '/meeting/$meetingId',
                    );
                  },
                  onReminderTap: (reminderId) {
                    // TODO: Navigate to reminder details/edit
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reminder details for $reminderId'),
                      ),
                    );
                  },
                ),
                error: (error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load agenda',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.refresh(calendarControllerProvider);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Week view (stub for now)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_view_week,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Week View',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Coming soon',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
