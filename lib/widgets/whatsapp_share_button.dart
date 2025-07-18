import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/appointment.dart';
import 'package:appoint/providers/whatsapp_share_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhatsAppShareButton extends ConsumerWidget {

  const WhatsAppShareButton({
    required this.appointment, super.key,
    this.customMessage,
    this.groupId,
    this.contextId,
    this.onShared,
  });
  final Appointment appointment;
  final String? customMessage;
  final String? groupId;
  final String? contextId;
  final VoidCallback? onShared;

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final shareState = ref.watch(shareDialogProvider);

    return ElevatedButton.icon(
      onPressed:
          shareState.isLoading ? null : () => _showShareDialog(context, ref),
      icon: const Icon(Icons.share, color: Colors.white),
      label: Text(
        shareState.isLoading ? 'Sharing...' : 'Share on WhatsApp',
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

  void _showShareDialog(BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => WhatsAppShareDialog(
        appointment: appointment,
        customMessage: customMessage,
        groupId: groupId,
        contextId: contextId,
        onShared: onShared,
      ),
    );
  }
}

class WhatsAppShareDialog extends ConsumerStatefulWidget {

  const WhatsAppShareDialog({
    required this.appointment, super.key,
    this.customMessage,
    this.groupId,
    this.contextId,
    this.onShared,
  });
  final Appointment appointment;
  final String? customMessage;
  final String? groupId;
  final String? contextId;
  final VoidCallback? onShared;

  @override
  ConsumerState<WhatsAppShareDialog> createState() =>
      _WhatsAppShareDialogState();
}

class _WhatsAppShareDialogState extends ConsumerState<WhatsAppShareDialog> {
  TextEditingController _messageController = TextEditingController();
  TextEditingController _groupNameController = TextEditingController();
  bool _saveGroupForRecognition = false;

  @override
  void initState() {
    super.initState();
    _messageController.text = widget.customMessage ??
        AppLocalizations.of(context)!.defaultShareMessage;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shareState = ref.watch(shareDialogProvider);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.share, color: Color(0xFF25D366)),
          const SizedBox(width: 8),
          Text(l10n?.shareOnWhatsApp ?? 'Share on WhatsApp'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.meetingReadyMessage ?? 'Meeting is ready',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message',
                border: const OutlineInputBorder(),
                hintText: l10n?.customizeMessage ?? 'Customize message',
              ),
            ),
            const SizedBox(height: 16),
            if (widget.groupId == null) ...[
              const Text(
                'Group Options',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: Text(l10n?.saveGroupForRecognition ?? 'Save group for recognition'),
                value: _saveGroupForRecognition,
                onChanged: (value) {
                  setState(() {
                    _saveGroupForRecognition = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (_saveGroupForRecognition) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    labelText: l10n?.groupNameOptional ?? 'Group name (optional)',
                    border: const OutlineInputBorder(),
                    hintText: l10n?.enterGroupName ?? 'Enter group name',
                  ),
                ),
              ],
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.group, color: Colors.green),
                    const SizedBox(width: 8),
                                          Text(
                        l10n?.knownGroupDetected ?? 'Known group detected',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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
          child: Text(l10n?.cancel ?? 'Cancel'),
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
    final notifier = ref.read(shareDialogProvider.notifier);
    final l10n = AppLocalizations.of(context);

    await notifier.shareToWhatsApp(
      meetingId: widget.appointment.id,
      creatorId: widget.appointment.creatorId,
      customMessage: _messageController.text,
      contextId: widget.contextId,
      groupId: widget.groupId,
    );

    // Save group for recognition if requested
    if (_saveGroupForRecognition && _groupNameController.text.isNotEmpty) {
      await notifier.saveGroupForRecognition(
        groupId: DateTime.now().millisecondsSinceEpoch.toString(),
        groupName: _groupNameController.text,
        phoneNumber: '', // This would be captured from WhatsApp
        meetingId: widget.appointment.id,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      widget.onShared?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.meetingSharedSuccessfully ?? 'Meeting shared successfully'),
          backgroundColor: const Color(0xFF25D366),
        ),
      );
    }
  }
}
