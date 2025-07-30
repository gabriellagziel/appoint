import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/whatsapp_group_share_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhatsAppGroupShareButton extends ConsumerWidget {
  const WhatsAppGroupShareButton({
    super.key,
    required this.appointmentId,
    required this.creatorId,
    required this.meetingTitle,
    required this.meetingDate,
    this.customMessage,
    this.onShareComplete,
    this.showAsDialog = false,
  });

  final String appointmentId;
  final String creatorId;
  final String meetingTitle;
  final DateTime meetingDate;
  final String? customMessage;
  final VoidCallback? onShareComplete;
  final bool showAsDialog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareState = ref.watch(whatsappGroupShareProvider);
    final l10n = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      onPressed: shareState.isLoading
          ? null
          : () => showAsDialog
              ? _showShareDialog(context, ref, l10n)
              : _shareDirectly(context, ref),
      icon: shareState.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.group, color: Colors.white),
      label: Text(
        shareState.isLoading ? l10n.loading : 'Share to WhatsApp Group',
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366), // WhatsApp green
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _shareDirectly(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(whatsappGroupShareProvider.notifier);
    _performShare(context, notifier);
  }

  void _showShareDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => WhatsAppGroupShareDialog(
        appointmentId: appointmentId,
        creatorId: creatorId,
        meetingTitle: meetingTitle,
        meetingDate: meetingDate,
        onShareComplete: onShareComplete,
      ),
    );
  }

  Future<void> _performShare(BuildContext context, WhatsAppGroupShareNotifier notifier) async {
    await notifier.shareToWhatsAppGroup(
      appointmentId: appointmentId,
      creatorId: creatorId,
      meetingTitle: meetingTitle,
      meetingDate: meetingDate,
      customMessage: customMessage,
    );

    onShareComplete?.call();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening WhatsApp...'),
          backgroundColor: Color(0xFF25D366),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class WhatsAppGroupShareDialog extends ConsumerStatefulWidget {
  const WhatsAppGroupShareDialog({
    super.key,
    required this.appointmentId,
    required this.creatorId,
    required this.meetingTitle,
    required this.meetingDate,
    this.onShareComplete,
  });

  final String appointmentId;
  final String creatorId;
  final String meetingTitle;
  final DateTime meetingDate;
  final VoidCallback? onShareComplete;

  @override
  ConsumerState<WhatsAppGroupShareDialog> createState() =>
      _WhatsAppGroupShareDialogState();
}

class _WhatsAppGroupShareDialogState extends ConsumerState<WhatsAppGroupShareDialog> {
  final _messageController = TextEditingController();
  bool _includeShareLink = true;

  @override
  void initState() {
    super.initState();
    _messageController.text = _getDefaultMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shareState = ref.watch(whatsappGroupShareProvider);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.group, color: Color(0xFF25D366)),
          const SizedBox(width: 8),
          const Expanded(child: Text('Share to WhatsApp Group')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share this appointment with your WhatsApp groups',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Meeting: ${widget.meetingTitle}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${_formatDate(widget.meetingDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Custom Message (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Add a personal message...',
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _includeShareLink,
              onChanged: (value) {
                setState(() {
                  _includeShareLink = value ?? true;
                  _updateMessagePreview();
                });
              },
              title: const Text('Include tracking link'),
              subtitle: const Text('Allows you to see who joins via this share'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (shareState.shareUrl != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.link, size: 16),
                        const SizedBox(width: 4),
                        const Text('Share Link:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: shareState.shareUrl!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copied to clipboard')),
                            );
                          },
                          child: const Text('Copy'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shareState.shareUrl!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
            if (shareState.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        shareState.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton.icon(
          onPressed: shareState.isLoading ? null : _shareToWhatsApp,
          icon: shareState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send),
          label: Text(shareState.isLoading ? 'Sharing...' : 'Share'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _shareToWhatsApp() async {
    final notifier = ref.read(whatsappGroupShareProvider.notifier);

    if (_includeShareLink) {
      // Generate share link first
      await notifier.generateShareLink(
        appointmentId: widget.appointmentId,
        creatorId: widget.creatorId,
        meetingTitle: widget.meetingTitle,
        meetingDate: widget.meetingDate,
      );
    }

    // Perform the share
    await notifier.shareToWhatsAppGroup(
      appointmentId: widget.appointmentId,
      creatorId: widget.creatorId,
      meetingTitle: widget.meetingTitle,
      meetingDate: widget.meetingDate,
      customMessage: _messageController.text.isNotEmpty 
          ? _messageController.text 
          : null,
    );

    if (mounted) {
      Navigator.of(context).pop();
      widget.onShareComplete?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening WhatsApp...'),
          backgroundColor: Color(0xFF25D366),
        ),
      );
    }
  }

  String _getDefaultMessage() {
    return 'Hi! You\'re invited to join: ${widget.meetingTitle}';
  }

  void _updateMessagePreview() {
    // Update message preview when options change
    // This could be enhanced to show a live preview
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}