import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GreetingSection extends ConsumerWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    const displayName = 'User'; // TODO: Get from auth service
    final formattedDate = _formatDate(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting, $displayName! 👋',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;

    return '$weekday, $month $day, $year';
  }
}



