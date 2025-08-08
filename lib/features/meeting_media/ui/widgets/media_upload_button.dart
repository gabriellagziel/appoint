import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:appoint/features/meeting_media/providers/meeting_media_providers.dart';

class MediaUploadButton extends ConsumerWidget {
  final String meetingId;

  const MediaUploadButton({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(mediaUploadProvider);

    return FloatingActionButton.extended(
      onPressed: uploadState.isLoading ? null : () => _showUploadDialog(context, ref),
      icon: uploadState.isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.add),
      label: Text(uploadState.isLoading ? 'Uploading...' : 'Upload'),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }

  Future<void> _showUploadDialog(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => const MediaUploadDialog(),
    );
  }
}

class MediaUploadDialog extends ConsumerStatefulWidget {
  const MediaUploadDialog({super.key});

  @override
  ConsumerState<MediaUploadDialog> createState() => _MediaUploadDialogState();
}

class _MediaUploadDialogState extends ConsumerState<MediaUploadDialog> {
  String? selectedFilePath;
  String? selectedFileName;
  String visibility = 'group';
  List<String> allowedRoles = ['member'];
  String notes = '';
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Media'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File selection
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.file_upload),
              label: Text(selectedFileName ?? 'Select File'),
            ),
            if (selectedFileName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Selected: $selectedFileName',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            
            // Visibility selection
            Text(
              'Visibility',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: visibility,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'group', child: Text('Group Only')),
                DropdownMenuItem(value: 'public', child: Text('Public')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    visibility = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Allowed roles (for group visibility)
            if (visibility == 'group') ...[
              Text(
                'Allowed Roles',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Members'),
                    selected: allowedRoles.contains('member'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          allowedRoles.add('member');
                        } else {
                          allowedRoles.remove('member');
                        }
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Admins'),
                    selected: allowedRoles.contains('admin'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          allowedRoles.add('admin');
                        } else {
                          allowedRoles.remove('admin');
                        }
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Owners'),
                    selected: allowedRoles.contains('owner'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          allowedRoles.add('owner');
                        } else {
                          allowedRoles.remove('owner');
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Notes
            Text(
              'Notes (Optional)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Add notes about this file...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isUploading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (selectedFilePath != null && !isUploading) 
              ? _uploadFile 
              : null,
          child: Text(isUploading ? 'Uploading...' : 'Upload'),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          selectedFilePath = file.path;
          selectedFileName = file.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    if (selectedFilePath == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      // Get meeting ID from parent widget
      final meetingId = 'meeting-id'; // TODO: Get from parent
      
      await ref.read(mediaUploadProvider.notifier).uploadMedia(
        meetingId,
        selectedFilePath!,
        visibility: visibility,
        allowedRoles: allowedRoles,
        notes: notes.isEmpty ? null : notes,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }
}
