import 'package:appoint/exceptions/booking_conflict_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Dialog for resolving booking conflicts
class BookingConflictDialog extends StatelessWidget {

  const BookingConflictDialog({
    required this.conflict, super.key,
    this.onKeepLocal,
    this.onKeepRemote,
    this.onMerge,
  });
  final BookingConflictException conflict;
  final VoidCallback? onKeepLocal;
  final VoidCallback? onKeepRemote;
  final VoidCallback? onMerge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning, color: Colors.orange, size: 24),
          SizedBox(width: 8),
          Text('Booking Conflict'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your local change conflicts with a server update.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildConflictInfo(dateFormat),
          const SizedBox(height: 16),
          Text(
            'Which version would you like to keep?',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(ConflictResolution.keepRemote);
            onKeepRemote?.call();
          },
          child: const Text('Keep Server Version'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(ConflictResolution.keepLocal);
            onKeepLocal?.call();
          },
          child: const Text('Keep My Version'),
        ),
        if (onMerge != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(ConflictResolution.merge);
              onMerge?.call();
            },
            child: const Text('Merge Changes'),
          ),
      ],
    );
  }

  Widget _buildConflictInfo(DateFormat dateFormat) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking ID: ${conflict.bookingId}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Local: ${dateFormat.format(conflict.localUpdatedAt)}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.cloud, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Server: ${dateFormat.format(conflict.remoteUpdatedAt)}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          if (conflict.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              conflict.message,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
}

/// Enum for conflict resolution options
enum ConflictResolution {
  keepLocal,
  keepRemote,
  merge,
}

/// Helper function to show the conflict dialog
Future<ConflictResolution?> showBookingConflictDialog(
  BuildContext context,
  BookingConflictException conflict, {
  VoidCallback? onKeepLocal,
  VoidCallback? onKeepRemote,
  VoidCallback? onMerge,
}) => showDialog<ConflictResolution>(
    context: context,
    barrierDismissible: false,
    builder: (context) => BookingConflictDialog(
      conflict: conflict,
      onKeepLocal: onKeepLocal,
      onKeepRemote: onKeepRemote,
      onMerge: onMerge,
    ),
  );
