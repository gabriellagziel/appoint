import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider = FutureProvider<List<NotificationItem>>((ref) async {
  // TODO: Implement real notifications
  return [
    NotificationItem(
      id: '1',
      title: 'Booking Confirmed',
      message: 'Your appointment with Dr. Smith has been confirmed for tomorrow at 10:00 AM.',
      type: NotificationType.booking,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionData: {'bookingId': 'booking_123'},
    ),
    NotificationItem(
      id: '2',
      title: 'New Message',
      message: 'You have a new message from Studio Beauty.',
      type: NotificationType.message,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
      actionData: {'chatId': 'chat_456'},
    ),
    NotificationItem(
      id: '3',
      title: 'Rewards Points Earned',
      message: 'You earned 50 points for your recent booking!',
      type: NotificationType.rewards,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionData: {'points': 50},
    ),
    NotificationItem(
      id: '4',
      title: 'System Update',
      message: 'New features are available. Update your app for the best experience.',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      actionData: {'updateAvailable': true},
    ),
  ];
});

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.actionData,
  });

  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? actionData;
}

enum NotificationType {
  booking,
  message,
  rewards,
  system,
  payment,
  reminder,
}

class EnhancedNotificationsScreen extends ConsumerWidget {
  const EnhancedNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => _markAllAsRead(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showNotificationSettings(context),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Failed to load notifications'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(notificationsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (notifications) => _buildNotificationsList(context, ref, notifications, l10n),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, WidgetRef ref, List<NotificationItem> notifications, AppLocalizations l10n) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationTile(context, ref, notification);
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, WidgetRef ref, NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteNotification(context, ref, notification.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () => _handleNotificationTap(context, notification),
        onLongPress: () => _showNotificationOptions(context, ref, notification),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.green;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.rewards:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.payment:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.red;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.message:
        return Icons.chat;
      case NotificationType.rewards:
        return Icons.stars;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.reminder:
        return Icons.alarm;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleNotificationTap(BuildContext context, NotificationItem notification) {
    switch (notification.type) {
      case NotificationType.booking:
        // Navigate to booking details
        Navigator.pushNamed(context, '/booking/${notification.actionData?['bookingId']}');
        break;
      case NotificationType.message:
        // Navigate to chat
        Navigator.pushNamed(context, '/chat/${notification.actionData?['chatId']}');
        break;
      case NotificationType.rewards:
        // Navigate to rewards
        Navigator.pushNamed(context, '/rewards');
        break;
      case NotificationType.system:
        // Handle system notification
        _showSystemNotificationDialog(context, notification);
        break;
      case NotificationType.payment:
        // Navigate to payment details
        Navigator.pushNamed(context, '/payment/${notification.actionData?['paymentId']}');
        break;
      case NotificationType.reminder:
        // Navigate to reminder details
        Navigator.pushNamed(context, '/reminder/${notification.actionData?['reminderId']}');
        break;
    }
  }

  void _showSystemNotificationDialog(BuildContext context, NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Text(notification.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (notification.actionData?['updateAvailable'] == true)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement app update
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update feature coming soon!')),
                );
              },
              child: const Text('Update'),
            ),
        ],
      ),
    );
  }

  void _showNotificationOptions(BuildContext context, WidgetRef ref, NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read),
              title: Text(notification.isRead ? 'Mark as unread' : 'Mark as read'),
              onTap: () {
                Navigator.pop(context);
                _toggleReadStatus(context, ref, notification);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteNotification(context, ref, notification.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Notification settings'),
              onTap: () {
                Navigator.pop(context);
                _showNotificationSettings(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleReadStatus(BuildContext context, WidgetRef ref, NotificationItem notification) {
    // TODO: Implement read status toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked as ${notification.isRead ? 'unread' : 'read'}')),
    );
  }

  void _deleteNotification(BuildContext context, WidgetRef ref, String notificationId) {
    // TODO: Implement notification deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification deleted')),
    );
  }

  void _markAllAsRead(BuildContext context, WidgetRef ref) {
    // TODO: Implement mark all as read
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // TODO: Navigate to notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon!')),
    );
  }
} 