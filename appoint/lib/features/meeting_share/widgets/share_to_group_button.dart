import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/meeting_share_service.dart';
import '../../../models/user_group.dart';

class ShareToGroupButton extends ConsumerStatefulWidget {
  final String meetingId;
  final UserGroup group;
  final String? customMessage;

  const ShareToGroupButton({
    super.key,
    required this.meetingId,
    required this.group,
    this.customMessage,
  });

  @override
  ConsumerState<ShareToGroupButton> createState() => _ShareToGroupButtonState();
}

class _ShareToGroupButtonState extends ConsumerState<ShareToGroupButton> {
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isSharing ? null : _showShareDialog,
      icon: _isSharing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.share),
      label: Text(_isSharing ? 'Sharing...' : 'Share to Group'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _showShareDialog() {
    final service = ref.read(meetingShareServiceProvider);
    final availableSources = service.getAvailableShareSources(widget.group);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.share, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Share Meeting'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share this meeting with ${widget.group.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...availableSources.map((source) => _buildShareOption(source)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(ShareSource source) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getSourceColor(source).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getSourceIcon(source),
          color: _getSourceColor(source),
          size: 20,
        ),
      ),
      title: Text(source.displayName),
      subtitle: Text('Share via ${source.displayName}'),
      onTap: () => _shareToSource(source),
    );
  }

  Color _getSourceColor(ShareSource source) {
    switch (source) {
      case ShareSource.whatsappGroup:
        return const Color(0xFF25D366);
      case ShareSource.telegramGroup:
        return const Color(0xFF0088CC);
      case ShareSource.signalGroup:
        return const Color(0xFF3A76F0);
      case ShareSource.discord:
        return const Color(0xFF5865F2);
      case ShareSource.messenger:
        return const Color(0xFF0084FF);
      case ShareSource.email:
        return Colors.grey;
      case ShareSource.sms:
        return Colors.green;
      case ShareSource.copyLink:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getSourceIcon(ShareSource source) {
    switch (source) {
      case ShareSource.whatsappGroup:
        return Icons.whatsapp;
      case ShareSource.telegramGroup:
        return Icons.telegram;
      case ShareSource.signalGroup:
        return Icons.signal_cellular_alt;
      case ShareSource.discord:
        return Icons.discord;
      case ShareSource.messenger:
        return Icons.facebook;
      case ShareSource.email:
        return Icons.email;
      case ShareSource.sms:
        return Icons.sms;
      case ShareSource.copyLink:
        return Icons.link;
    }
  }

  Future<void> _shareToSource(ShareSource source) async {
    Navigator.of(context).pop();

    setState(() {
      _isSharing = true;
    });

    try {
      final service = ref.read(meetingShareServiceProvider);
      final success = await service.shareToPlatform(
        source: source,
        meetingId: widget.meetingId,
        groupId: widget.group.id,
        groupName: widget.group.name,
        customMessage: widget.customMessage,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Shared successfully via ${source.displayName}'
                  : 'Failed to share via ${source.displayName}',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }
}

class QuickShareButton extends ConsumerWidget {
  final String meetingId;
  final UserGroup group;
  final ShareSource source;

  const QuickShareButton({
    super.key,
    required this.meetingId,
    required this.group,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _quickShare(context, ref),
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _getSourceColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          _getSourceIcon(),
          color: _getSourceColor(),
          size: 16,
        ),
      ),
      tooltip: 'Share via ${source.displayName}',
    );
  }

  Color _getSourceColor() {
    switch (source) {
      case ShareSource.whatsappGroup:
        return const Color(0xFF25D366);
      case ShareSource.telegramGroup:
        return const Color(0xFF0088CC);
      case ShareSource.signalGroup:
        return const Color(0xFF3A76F0);
      case ShareSource.discord:
        return const Color(0xFF5865F2);
      case ShareSource.messenger:
        return const Color(0xFF0084FF);
      case ShareSource.email:
        return Colors.grey;
      case ShareSource.sms:
        return Colors.green;
      case ShareSource.copyLink:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getSourceIcon() {
    switch (source) {
      case ShareSource.whatsappGroup:
        return Icons.whatsapp;
      case ShareSource.telegramGroup:
        return Icons.telegram;
      case ShareSource.signalGroup:
        return Icons.signal_cellular_alt;
      case ShareSource.discord:
        return Icons.discord;
      case ShareSource.messenger:
        return Icons.facebook;
      case ShareSource.email:
        return Icons.email;
      case ShareSource.sms:
        return Icons.sms;
      case ShareSource.copyLink:
        return Icons.link;
    }
  }

  Future<void> _quickShare(BuildContext context, WidgetRef ref) async {
    try {
      final service = ref.read(meetingShareServiceProvider);
      final success = await service.shareToPlatform(
        source: source,
        meetingId: meetingId,
        groupId: group.id,
        groupName: group.name,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Shared via ${source.displayName}'
                  : 'Failed to share via ${source.displayName}',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}


