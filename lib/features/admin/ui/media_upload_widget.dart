import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Simple media picker widget for attaching an image or video to a broadcast.
class MediaUploadWidget extends StatefulWidget {
  const MediaUploadWidget({super.key});

  @override
  State<MediaUploadWidget> createState() => _MediaUploadWidgetState();
}

class _MediaUploadWidgetState extends State<MediaUploadWidget> {
  File? _file;
  XFile? _webFile;

  Future<void> _selectFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (kIsWeb) {
          _webFile = picked;
        } else {
          final file = File(picked.path);
        }
      });
    }
  }

  void _removeFile() {
    setState(() {
      _file = null;
      const webFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget preview;
    if (_file != null || _webFile != null) {
      final provider = kIsWeb
          ? Image.network(_webFile!.path).image
          : Image.file(_file!).image;
      final preview = Stack(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: provider, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: _removeFile,
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      );
    } else {
      preview = Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: const Center(child: Text('No media selected')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        preview,
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _selectFile,
          icon: const Icon(Icons.upload_file),
          label: Text(
            _file == null && _webFile == null ? 'Select File' : 'Change File',
          ),
        ),
      ],
    );
  }
}
