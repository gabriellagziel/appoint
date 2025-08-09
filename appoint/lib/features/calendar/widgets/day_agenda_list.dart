import 'package:flutter/material.dart';
import '../../../models/agenda_item.dart';

class DayAgendaList extends StatelessWidget {
  final List<AgendaItem> agenda;
  final Function(String) onMeetingTap;
  final Function(String) onReminderTap;

  const DayAgendaList({
    super.key,
    required this.agenda,
    required this.onMeetingTap,
    required this.onReminderTap,
  });

  @override
  Widget build(BuildContext context) {
    if (agenda.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agenda.length,
      itemBuilder: (context, index) {
        final item = agenda[index];
        return _buildAgendaItem(context, item);
      },
    );
  }

  Widget _buildAgendaItem(BuildContext context, AgendaItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildTimeIndicator(context, item),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: _buildSubtitle(context, item),
        trailing: _buildTrailingIcon(context, item),
        onTap: () {
          if (item.isMeeting) {
            onMeetingTap(item.id);
          } else {
            onReminderTap(item.id);
          }
        },
      ),
    );
  }

  Widget _buildTimeIndicator(BuildContext context, AgendaItem item) {
    final time = item.time;
    final timeString =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: item.isMeeting ? Colors.blue[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeString,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: item.isMeeting ? Colors.blue[800] : Colors.orange[800],
                ),
          ),
          Icon(
            item.isMeeting ? Icons.group : Icons.notification_important,
            size: 16,
            color: item.isMeeting ? Colors.blue[800] : Colors.orange[800],
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, AgendaItem item) {
    if (item.isMeeting) {
      final participants = item.metadata?['participants'] as List<String>?;
      final location = item.metadata?['location'] as String?;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (participants != null && participants.isNotEmpty)
            Text(
              '${participants.length} participant${participants.length > 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          if (location != null)
            Text(
              location,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
        ],
      );
    } else {
      final category = item.metadata?['category'] as String?;
      final priority = item.metadata?['priority'] as String?;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (category != null)
            Text(
              category.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          if (priority != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: priority == 'high' ? Colors.red[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                priority.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: priority == 'high'
                          ? Colors.red[800]
                          : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildTrailingIcon(BuildContext context, AgendaItem item) {
    return Icon(
      item.isMeeting ? Icons.arrow_forward_ios : Icons.edit,
      size: 16,
      color: Colors.grey[400],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your meetings and reminders will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
