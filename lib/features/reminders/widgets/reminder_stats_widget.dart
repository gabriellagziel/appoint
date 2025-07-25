import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/reminder_analytics.dart';
import 'package:flutter/material.dart';

class ReminderStatsWidget extends StatelessWidget {
  const ReminderStatsWidget({
    super.key,
    required this.stats,
  });

  final ReminderStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final completionRate = (stats.completionRate * 100).round();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.thisWeek,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (completionRate >= 80)
                Icon(
                  Icons.emoji_events,
                  color: Colors.amber[700],
                  size: 20,
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.task_alt,
                  value: stats.totalReminders.toString(),
                  label: l10n.total,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.check_circle,
                  value: stats.completedReminders.toString(),
                  label: l10n.completed,
                  color: Colors.green[700]!,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.percent,
                  value: '$completionRate%',
                  label: l10n.completionRate,
                  color: _getCompletionRateColor(completionRate),
                ),
              ),
            ],
          ),
          
          // Insight text
          if (stats.totalReminders > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ReminderInsights.generateUserInsight(stats),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getCompletionRateColor(int completionRate) {
    if (completionRate >= 90) {
      return Colors.green[700]!;
    } else if (completionRate >= 70) {
      return Colors.lightGreen[700]!;
    } else if (completionRate >= 50) {
      return Colors.orange[700]!;
    } else {
      return Colors.red[700]!;
    }
  }
}