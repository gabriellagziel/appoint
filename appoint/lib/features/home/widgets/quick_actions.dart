import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/meeting_creation/widgets/create_meeting_flow.dart';
import '../../../features/reminders/screens/create_reminder_screen.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Create Meeting',
                Icons.add_circle,
                Colors.blue,
                'Schedule a new meeting',
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateMeetingFlow(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                'Create Reminder',
                Icons.notifications,
                Colors.orange,
                'Set a new reminder',
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateReminderScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



