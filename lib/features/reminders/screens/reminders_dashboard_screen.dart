import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/reminder.dart';
import 'package:appoint/models/reminder_analytics.dart';
import 'package:appoint/features/reminders/providers/reminder_providers.dart';
import 'package:appoint/features/reminders/widgets/reminder_card.dart';
import 'package:appoint/features/reminders/widgets/reminder_stats_widget.dart';
import 'package:appoint/features/reminders/widgets/upgrade_prompt_widget.dart';
import 'package:appoint/features/reminders/screens/create_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RemindersDashboardScreen extends ConsumerStatefulWidget {
  const RemindersDashboardScreen({super.key});

  @override
  ConsumerState<RemindersDashboardScreen> createState() => _RemindersDashboardScreenState();
}

class _RemindersDashboardScreenState extends ConsumerState<RemindersDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ReminderType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activeReminders = ref.watch(activeRemindersProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final upcomingReminders = ref.watch(upcomingRemindersProvider);
    final weeklyStats = ref.watch(weeklyReminderStatsProvider);
    final accessStatus = ref.watch(REDACTED_TOKEN);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myReminders),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => _showStatsDialog(context),
            tooltip: l10n.reminderStats,
          ),
          PopupMenuButton<ReminderType?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (type) => setState(() => _selectedFilter = type),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Text(l10n.allReminders),
              ),
              PopupMenuItem(
                value: ReminderType.timeBased,
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.timeBasedReminders),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ReminderType.locationBased,
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.locationBasedReminders),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ReminderType.meetingRelated,
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.meetingReminders),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ReminderType.personal,
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.personalReminders),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.schedule),
              text: l10n.today,
            ),
            Tab(
              icon: const Icon(Icons.upcoming),
              text: l10n.upcoming,
            ),
            Tab(
              icon: const Icon(Icons.warning),
              text: l10n.overdue,
            ),
            Tab(
              icon: const Icon(Icons.list),
              text: l10n.all,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Weekly stats summary
          weeklyStats.when(
            data: (stats) => stats != null 
                ? ReminderStatsWidget(stats: stats)
                : const SizedBox.shrink(),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          // Access status warning/upgrade prompt
          accessStatus.when(
            data: (status) => status.needsUpgrade
                ? UpgradePromptWidget(
                    title: l10n.unlockLocationReminders,
                    description: l10n.upgradeForLocationReminders,
                    onUpgrade: () => _showUpgradeDialog(context),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Tab view with reminders
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRemindersList(todayReminders, l10n.noRemindersToday),
                _buildRemindersList(upcomingReminders, l10n.noUpcomingReminders),
                _buildRemindersList(overdueReminders, l10n.noOverdueReminders),
                _buildRemindersList(activeReminders, l10n.noActiveReminders),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Semantics(
        label: l10n.addReminder,
        hint: l10n.addReminderDescription,
        button: true,
        child: FloatingActionButton.extended(
          onPressed: () => _createNewReminder(context),
          icon: const Icon(Icons.add_alarm),
          label: Text(l10n.addReminder),
        ),
      ),
    );
  }

  Widget _buildRemindersList(AsyncValue<List<Reminder>> remindersAsync, String emptyMessage) {
    return remindersAsync.when(
      data: (reminders) {
        // Apply filter if selected
        final filteredReminders = _selectedFilter != null
            ? reminders.where((r) => r.type == _selectedFilter).toList()
            : reminders;

        if (filteredReminders.isEmpty) {
          return _buildEmptyState(emptyMessage);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeRemindersProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredReminders.length,
            itemBuilder: (context, index) {
              final reminder = filteredReminders[index];
              return ReminderCard(
                reminder: reminder,
                onTap: () => _viewReminderDetails(context, reminder),
                onComplete: () => _completeReminder(reminder.id),
                onSnooze: () => _snoozeReminder(context, reminder.id),
                onDelete: () => _deleteReminder(context, reminder),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildEmptyState(String message) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.createYourFirstReminder,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _createNewReminder(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.addReminder),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.errorLoadingReminders,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(activeRemindersProvider);
            },
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  void _createNewReminder(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateReminderScreen(),
      ),
    );
  }

  void _viewReminderDetails(BuildContext context, Reminder reminder) {
    context.push('/reminders/${reminder.id}');
  }

  void _completeReminder(String reminderId) {
    ref.read(reminderActionNotifierProvider.notifier).completeReminder(reminderId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.reminderCompleted),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
      ),
    );
  }

  void _snoozeReminder(BuildContext context, String reminderId) {
    showModalBottomSheet<Duration>(
      context: context,
      builder: (context) => _buildSnoozeOptions(context),
    ).then((duration) {
      if (duration != null) {
        ref.read(reminderActionNotifierProvider.notifier)
            .snoozeReminder(reminderId, duration);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.reminderSnoozedFor(
                _formatDuration(duration),
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildSnoozeOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final snoozeOptions = [
      (Duration(minutes: 5), l10n.fiveMinutes),
      (Duration(minutes: 15), l10n.fifteenMinutes),
      (Duration(minutes: 30), l10n.thirtyMinutes),
      (Duration(hours: 1), l10n.oneHour),
      (Duration(hours: 2), l10n.twoHours),
      (Duration(hours: 4), l10n.fourHours),
      (Duration(days: 1), l10n.oneDay),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.snoozeFor,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...snoozeOptions.map((option) => ListTile(
            leading: const Icon(Icons.snooze),
            title: Text(option.$2),
            onTap: () => Navigator.of(context).pop(option.$1),
          )),
        ],
      ),
    );
  }

  void _deleteReminder(BuildContext context, Reminder reminder) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteReminder),
        content: Text(
          AppLocalizations.of(context)!.deleteReminderConfirmation(reminder.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(reminderActionNotifierProvider.notifier).deleteReminder(reminder.id);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.reminderDeleted),
          ),
        );
      }
    });
  }

  void _showStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ReminderStatsDialog(),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            // App-Oint branding logo would go here
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF1576D4), // App-Oint brand blue
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(AppLocalizations.of(context)!.unlockLocationReminders),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.locationRemindersDescription),
            const SizedBox(height: 16),
            const Text(
              'Powered by App-Oint', // Always English, never translated
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.notNow),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1576D4), // App-Oint brand blue
            ),
            child: Text(AppLocalizations.of(context)!.upgrade),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }
}

class ReminderStatsDialog extends ConsumerWidget {
  const ReminderStatsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weeklyStats = ref.watch(weeklyReminderStatsProvider);
    final monthlyStats = ref.watch(monthlyReminderStatsProvider);

    return AlertDialog(
      title: Text(l10n.reminderStats),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Weekly stats
            weeklyStats.when(
              data: (stats) => stats != null
                  ? _buildStatsSection(l10n.thisWeek, stats, context)
                  : const SizedBox.shrink(),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(l10n.errorLoadingStats),
            ),
            const Divider(),
            // Monthly stats
            monthlyStats.when(
              data: (stats) => stats != null
                  ? _buildStatsSection(l10n.thisMonth, stats, context)
                  : const SizedBox.shrink(),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(l10n.errorLoadingStats),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  Widget _buildStatsSection(String title, ReminderStats stats, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completionRate = (stats.completionRate * 100).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('${l10n.totalReminders}: ${stats.totalReminders}'),
        Text('${l10n.completed}: ${stats.completedReminders}'),
        Text('${l10n.completionRate}: $completionRate%'),
        if (stats.locationBasedReminders > 0)
          Text('${l10n.locationReminders}: ${stats.locationBasedReminders}'),
        const SizedBox(height: 8),
        Text(
          ReminderInsights.generateUserInsight(stats),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}