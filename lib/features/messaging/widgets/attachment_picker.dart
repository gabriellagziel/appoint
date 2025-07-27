import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttachmentPicker extends ConsumerWidget {
  final Function(String)? onAttachmentSelected;

  const AttachmentPicker({
    super.key,
    this.onAttachmentSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Attachment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachmentOption(
                icon: Icons.photo,
                label: 'Photo',
                onTap: () => _pickImage(context),
              ),
              _AttachmentOption(
                icon: Icons.videocam,
                label: 'Video',
                onTap: () => _pickVideo(context),
              ),
              _AttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'File',
                onTap: () => _pickFile(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _pickImage(BuildContext context) {
    // TODO: Implement image picking
    Navigator.pop(context);
    onAttachmentSelected?.call('image');
  }

  void _pickVideo(BuildContext context) {
    // TODO: Implement video picking
    Navigator.pop(context);
    onAttachmentSelected?.call('video');
  }

  void _pickFile(BuildContext context) {
    // TODO: Implement file picking
    Navigator.pop(context);
    onAttachmentSelected?.call('file');
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}