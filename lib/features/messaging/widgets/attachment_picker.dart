import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AttachmentPicker extends StatefulWidget {
  final Function(File) onFileSelected;
  
  const AttachmentPicker({
    required this.onFileSelected,
    super.key,
  });

  @override
  State<AttachmentPicker> createState() => _AttachmentPickerState();
}

class _AttachmentPickerState extends State<AttachmentPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: _pickFile,
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: _pickImage,
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      widget.onFileSelected(File(result.files.single.path!));
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      widget.onFileSelected(File(result.files.single.path!));
    }
  }
}