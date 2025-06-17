import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/whatsapp_share_provider.dart';
import '../models/appointment.dart';

class WhatsAppShareButton extends ConsumerWidget {
  final Appointment appointment;
  final String? customMessage;
  final String? groupId;
  final String? contextId;
  final VoidCallback? onShared;

  const WhatsAppShareButton({
    Key? key,
    required this.appointment,
    this.customMessage,
    this.groupId,
    this.contextId,
    this.onShared,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

  void _showShareDialog(BuildContext context, WidgetRef ref) {
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
  final Appointment appointment;
  final String? customMessage;
  final String? groupId;
  final String? contextId;
  final VoidCallback? onShared;

  const WhatsAppShareDialog({
    Key? key,
    required this.appointment,
    this.customMessage,
    this.groupId,
    this.contextId,
    this.onShared,
  }) : super(key: key);

  @override
  ConsumerState<WhatsAppShareDialog> createState() =>
      _WhatsAppShareDialogState();
}

class _WhatsAppShareDialogState extends ConsumerState<WhatsAppShareDialog> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  bool _saveGroupForRecognition = false;

  @override
  void initState() {
    super.initState();
    _messageController.text = widget.customMessage ??
        "Hey! I've scheduled a meeting with you through APP-OINT. Click here to confirm or suggest a different time:";
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

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.share, color: Color(0xFF25D366)),
          const SizedBox(width: 8),
          const Text('Share on WhatsApp'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The meeting is ready! Would you like to send it to your group?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                hintText: 'Customize your message...',
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
                title: const Text('Save group for future recognition'),
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
                  decoration: const InputDecoration(
                    labelText: 'Group Name (optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Enter group name for recognition',
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
                    const Text(
                      'Known group detected',
                      style: TextStyle(
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
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: shareState.isLoading ? null : () => _shareToWhatsApp(),
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
        const SnackBar(
          content: Text('Meeting shared successfully!'),
          backgroundColor: Color(0xFF25D366),
        ),
      );
    }
  }
}
