import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/reminders/controllers/reminder_controller.dart';

class SmartSuggestions extends ConsumerWidget {
  const SmartSuggestions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdueReminders = ref.watch(overdueRemindersProvider);
    final upcomingReminders = ref.watch(upcomingRemindersProvider);

    final suggestions = <_Suggestion>[];

    // Check for overdue reminders
    if (overdueReminders.isNotEmpty) {
      suggestions.add(_Suggestion(
        type: _SuggestionType.catchUp,
        title: 'Catch up on overdue items',
        description:
            'You have ${overdueReminders.length} overdue reminder${overdueReminders.length > 1 ? 's' : ''}',
        icon: Icons.schedule,
        color: Colors.red,
        action: () => _handleCatchUp(context),
      ));
    }

    // Check for free time in next 3 hours
    final now = DateTime.now();
    final threeHoursFromNow = now.add(const Duration(hours: 3));
    final hasUpcomingItems = upcomingReminders.any(
        (r) => r.dueDate.isAfter(now) && r.dueDate.isBefore(threeHoursFromNow));

    if (!hasUpcomingItems) {
      suggestions.add(_Suggestion(
        type: _SuggestionType.freeTime,
        title: 'Free time ahead',
        description: 'No items scheduled in the next 3 hours',
        icon: Icons.add_circle,
        color: Colors.green,
        action: () => _handleFreeTime(context),
      ));
    }

    // Check for weekend planning
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    if (isWeekend && suggestions.length < 2) {
      suggestions.add(_Suggestion(
        type: _SuggestionType.weekend,
        title: 'Weekend planning',
        description: 'Plan your weekend activities',
        icon: Icons.weekend,
        color: Colors.purple,
        action: () => _handleWeekendPlanning(context),
      ));
    }

    // Default suggestion if no others
    if (suggestions.isEmpty) {
      suggestions.add(_Suggestion(
        type: _SuggestionType.defaultSuggestion,
        title: 'Stay organized',
        description: 'Create your first meeting or reminder',
        icon: Icons.lightbulb,
        color: Colors.blue,
        action: () => _handleDefaultSuggestion(context),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smart Suggestions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...suggestions
            .map((suggestion) => _buildSuggestionCard(context, suggestion)),
      ],
    );
  }

  Widget _buildSuggestionCard(BuildContext context, _Suggestion suggestion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: suggestion.action,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: suggestion.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  suggestion.icon,
                  color: suggestion.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggestion.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCatchUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catch Up'),
        content: const Text(
            'Would you like to mark overdue reminders as complete or reschedule them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to reminders dashboard with overdue filter
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to overdue reminders'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Review Now'),
          ),
        ],
      ),
    );
  }

  void _handleFreeTime(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Free Time'),
        content: const Text(
            'You have free time coming up. What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to create meeting
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to create meeting'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Create Meeting'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to create reminder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to create reminder'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Create Reminder'),
          ),
        ],
      ),
    );
  }

  void _handleWeekendPlanning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weekend Planning'),
        content:
            const Text('Plan your weekend activities with family and friends.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to create meeting with weekend suggestions
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to weekend planning'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
            child: const Text('Plan Weekend'),
          ),
        ],
      ),
    );
  }

  void _handleDefaultSuggestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Get Started'),
        content: const Text(
            'Create your first meeting or reminder to stay organized.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to create meeting
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to create meeting'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Create Meeting'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to create reminder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to create reminder'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Create Reminder'),
          ),
        ],
      ),
    );
  }
}

enum _SuggestionType { catchUp, freeTime, weekend, defaultSuggestion }

class _Suggestion {
  final _SuggestionType type;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback action;

  _Suggestion({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.action,
  });
}



