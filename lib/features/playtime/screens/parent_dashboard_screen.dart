import 'package:appoint/config/theme.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/models/playtime_session.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context, l10n),
                const SizedBox(height: 24),

                // Quick Stats
                _buildQuickStats(context, l10n),
                const SizedBox(height: 24),

                // Pending Approvals
                _buildPendingApprovals(context, l10n),
                const SizedBox(height: 24),

                // Child's Sessions
                _buildChildSessions(context, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, final AppLocalizations l10n) => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.family_restroom,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Parent Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage your child's playtime activities",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildQuickStats(
      BuildContext context, final AppLocalizations l10n,) => Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Pending Approvals',
            '3',
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Active Sessions',
            '2',
            Icons.play_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Sessions',
            '15',
            Icons.history,
            Colors.blue,
          ),
        ),
      ],
    );

  Widget _buildStatCard(final String title, final String value,
      IconData icon, final Color color,) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  Widget _buildPendingApprovals(
      BuildContext context, final AppLocalizations l10n,) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Approvals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            TextButton(
              onPressed: () => context.push('/playtime/approvals'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, final ref, final child) {
            final sessionsAsync = ref.watch(pendingSessionsProvider);
            final backgroundsAsync = ref.watch(pendingBackgroundsProvider);

            return Column(
              children: [
                // Pending Sessions
                sessionsAsync.when(
                  data: (sessions) {
                    if (sessions.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: sessions.take(2).map((session) => _buildPendingSessionCard(context, session, l10n)).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, final stack) => Text('Error: $error'),
                ),

                // Pending Backgrounds
                backgroundsAsync.when(
                  data: (backgrounds) {
                    if (backgrounds.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: backgrounds.take(2).map((background) => _buildPendingBackgroundCard(
                            context, background, l10n,),).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, final stack) => Text('Error: $error'),
                ),

                // Empty State
                if (sessionsAsync.value?.isEmpty == true &&
                    backgroundsAsync.value?.isEmpty == true)
                  _buildEmptyApprovalsState(l10n),
              ],
            );
          },
        ),
      ],
    );

  Widget _buildPendingSessionCard(final BuildContext context,
      PlaytimeSession session, final AppLocalizations l10n,) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: session.mode == 'virtual'
                      ? AppTheme.secondaryColor
                      : AppTheme.accentColor,
                  child: Icon(
                    session.mode == 'virtual' ? Icons.computer : Icons.people,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session ${session.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scheduled for ${_formatDateTime(session.scheduledTime)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _approveSession(context, session.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectSession(context, session.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  Widget _buildPendingBackgroundCard(final BuildContext context,
      PlaytimeBackground background, final AppLocalizations l10n,) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      background.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, final error, final stackTrace) => const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background ${background.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created by: ${background.createdBy}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _approveBackground(context, background.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectBackground(context, background.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  Widget _buildEmptyApprovalsState(AppLocalizations l10n) => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No pending approvals',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All requests have been reviewed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  Widget _buildChildSessions(
      BuildContext context, final AppLocalizations l10n,) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Child's Sessions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            TextButton(
              onPressed: () => context.push('/playtime/sessions'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, final ref, final child) {
            final sessionsAsync = ref.watch(userSessionsProvider);

            return sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return _buildEmptySessionsState(l10n);
                }

                return Column(
                  children: sessions.take(3).map((session) => _buildSessionCard(context, session, l10n)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, final stack) => Text('Error: $error'),
            );
          },
        ),
      ],
    );

  Widget _buildSessionCard(final BuildContext context,
      PlaytimeSession session, final AppLocalizations l10n,) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: session.mode == 'virtual'
              ? AppTheme.secondaryColor
              : AppTheme.accentColor,
          child: Icon(
            session.mode == 'virtual' ? Icons.computer : Icons.people,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Session ${session.id}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${l10n.scheduledFor}: ${_formatDateTime(session.scheduledTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              '${session.participants.length} participants',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => context.push('/playtime/session/${session.id}'),
        ),
      ),
    );

  Widget _buildEmptySessionsState(AppLocalizations l10n) => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No sessions yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Your child hasn't created any sessions",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return 'Now';
    }
  }

  void _approveSession(BuildContext context, final String sessionId) {
    // This would typically call the provider to approve the session
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session approved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectSession(BuildContext context, final String sessionId) {
    // This would typically call the provider to reject the session
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session rejected'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _approveBackground(
      BuildContext context, final String backgroundId,) {
    // This would typically call the provider to approve the background
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Background approved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectBackground(
      BuildContext context, final String backgroundId,) {
    // This would typically call the provider to reject the background
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Background rejected'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
