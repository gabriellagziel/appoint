import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttachmentPicker extends StatelessWidget {
  const AttachmentPicker({
    required this.onFileSelected,
    super.key,
  });

  final Function(PlatformFile) onFileSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.attach_file),
      onPressed: _pickFile,
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      onFileSelected(result.files.first);
    }
  }
}