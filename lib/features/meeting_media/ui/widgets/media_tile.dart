import 'package:flutter/material.dart';
import 'package:appoint/models/meeting_media.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaTile extends StatelessWidget {
  final MeetingMedia media;
  final String meetingId;
  final VoidCallback? onDelete;
  final Function(Map<String, dynamic>)? onUpdate;

  const MediaTile({
    super.key,
    required this.media,
    required this.meetingId,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showMediaDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview area
            Expanded(
              child: _buildPreview(context),
            ),

            // File info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File name
                  Text(
                    media.fileName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // File size and type
                  Row(
                    children: [
                      Text(
                        media.fileSize,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getFileTypeColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          media.fileExtension.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Visibility indicator
                  if (media.isPublic) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          size: 12,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Public',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Action buttons
            if (onDelete != null || onUpdate != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => _downloadFile(context),
                      icon: const Icon(Icons.download, size: 18),
                      tooltip: 'Download',
                    ),
                    if (onUpdate != null)
                      IconButton(
                        onPressed: () => _showEditDialog(context),
                        icon: const Icon(Icons.edit, size: 18),
                        tooltip: 'Edit',
                      ),
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, size: 18),
                        tooltip: 'Delete',
                        color: Colors.red,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    if (media.isImage) {
      return _buildImagePreview(context);
    } else if (media.isVideo) {
      return _buildVideoPreview(context);
    } else if (media.isAudio) {
      return _buildAudioPreview(context);
    } else {
      return _buildDocumentPreview(context);
    }
  }

  Widget _buildImagePreview(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: media.url != null
          ? ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                media.url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(context, Icons.image);
                },
              ),
            )
          : _buildPlaceholder(context, Icons.image),
    );
  }

  Widget _buildVideoPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: _buildPlaceholder(context, Icons.video_file),
    );
  }

  Widget _buildAudioPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: _buildPlaceholder(context, Icons.audio_file),
    );
  }

  Widget _buildDocumentPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: _buildPlaceholder(context, Icons.description),
    );
  }

  Widget _buildPlaceholder(BuildContext context, IconData icon) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Icon(
        icon,
        size: 48,
        color: Colors.grey[400],
      ),
    );
  }

  Color _getFileTypeColor() {
    if (media.isImage) return Colors.green;
    if (media.isVideo) return Colors.red;
    if (media.isAudio) return Colors.orange;
    if (media.isDocument) return Colors.blue;
    return Colors.grey;
  }

  Future<void> _downloadFile(BuildContext context) async {
    try {
      if (media.url != null) {
        final uri = Uri.parse(media.url!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw Exception('Could not open file');
        }
      } else {
        throw Exception('No download URL available');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download file: $e')),
        );
      }
    }
  }

  void _showMediaDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(media.fileName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (media.notes?.isNotEmpty == true) ...[
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(media.notes!),
                const SizedBox(height: 16),
              ],
              _buildDetailRow('File Size', media.fileSize),
              _buildDetailRow('File Type', media.mimeType),
              _buildDetailRow('Uploaded', _formatDate(media.uploadedAt)),
              _buildDetailRow(
                  'Visibility', media.isPublic ? 'Public' : 'Group'),
              if (!media.isPublic) ...[
                _buildDetailRow('Allowed Roles', media.allowedRoles.join(', ')),
              ],
              if (media.checksum != null) ...[
                _buildDetailRow('Checksum', media.checksum!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _downloadFile(context);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    if (onUpdate == null) return;

    String visibility = media.visibility;
    List<String> allowedRoles = List.from(media.allowedRoles);
    String notes = media.notes ?? '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Media'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  'Notes',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Add notes about this file...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  controller: TextEditingController(text: notes),
                  onChanged: (value) {
                    notes = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onUpdate!({
                  'visibility': visibility,
                  'allowedRoles': allowedRoles,
                  'notes': notes.isEmpty ? null : notes,
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

