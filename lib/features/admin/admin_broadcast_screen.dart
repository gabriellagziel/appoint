import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/broadcast_service.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/providers/admin_provider.dart';

class AdminBroadcastScreen extends ConsumerStatefulWidget {
  const AdminBroadcastScreen({final Key? key}) : super(key: key);

  @override
  ConsumerState<AdminBroadcastScreen> createState() =>
      _AdminBroadcastScreenState();
}

class _AdminBroadcastScreenState extends ConsumerState<AdminBroadcastScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _linkController = TextEditingController();

  BroadcastMessageType _selectedType = BroadcastMessageType.text;
  BroadcastTargetingFilters _filters = const BroadcastTargetingFilters();
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;
  int? _estimatedRecipients;

  // Media selection state
  File? _selectedImage;
  File? _selectedVideo;

  final List<String> _pollOptions = ['', '', '', ''];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final broadcastMessages = ref.watch(broadcastMessagesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.adminBroadcast ?? 'Admin Broadcast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showComposeDialog(),
          ),
        ],
      ),
      body: isAdmin.when(
        data: (final hasAdminAccess) {
          if (!hasAdminAccess) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Access Denied',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You do not have permission to access this feature.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please contact your administrator if you believe this is an error.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return broadcastMessages.when(
            data: (final messages) => _buildMessagesList(messages),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (final error, final stack) =>
                Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final error, final stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error Checking Permissions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(final List<AdminBroadcastMessage> messages) {
    final l10n = AppLocalizations.of(context)!;

    if (messages.isEmpty) {
      return Center(
        child: Text(l10n.noBroadcastMessages),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (final context, final index) {
        final message = messages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    _buildStatusChip(message.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.content(message.content),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.type(message.type.toString()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (message.actualRecipients != null)
                  Text(
                    l10n.recipients(message.actualRecipients!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (message.openedCount != null)
                  Text(
                    l10n.opened(message.openedCount!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                Text(
                  l10n.created(message.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (message.scheduledFor != null)
                  Text(
                    l10n.scheduled(message.scheduledFor!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (message.status == BroadcastMessageStatus.pending)
                      TextButton(
                        onPressed: () => _sendMessage(message.id),
                        child: Text(l10n.sendNow),
                      ),
                    TextButton(
                      onPressed: () => _showMessageDetails(message),
                      child: Text(l10n.details),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(final BroadcastMessageStatus status) {
    Color color;
    String text;

    switch (status) {
      case BroadcastMessageStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case BroadcastMessageStatus.sent:
        color = Colors.green;
        text = 'Sent';
        break;
      case BroadcastMessageStatus.failed:
        color = Colors.red;
        text = 'Failed';
        break;
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  void _showComposeDialog() {
    final l10n = AppLocalizations.of(context)!;

    // Check admin privileges before showing the dialog
    final isAdmin = ref.read(isAdminProvider);
    isAdmin.when(
      data: (final hasAdminAccess) {
        if (!hasAdminAccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.noPermissionForBroadcast),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        showDialog(
          context: context,
          builder: (final context) => AlertDialog(
            title: Text(l10n.composeBroadcastMessage),
            content: SizedBox(
              width: double.maxFinite,
              child: _buildComposeForm(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: _saveMessage,
                child: Text(l10n.save),
              ),
            ],
          ),
        );
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.checkingPermissions),
            backgroundColor: Colors.orange,
          ),
        );
      },
      error: (final error, final stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorCheckingPermissions(error)),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  Widget _buildComposeForm() {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (final value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BroadcastMessageType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Message Type',
                border: OutlineInputBorder(),
              ),
              items: BroadcastMessageType.values.map((final type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (final value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (final value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Media Selection Section
            ExpansionTile(
              title: Text(l10n.mediaOptional),
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: Text(l10n.pickImage),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickVideo,
                        icon: const Icon(Icons.videocam),
                        label: Text(l10n.pickVideo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_selectedImage != null || _selectedVideo != null) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  if (_selectedImage != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.image, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Image selected: ${_selectedImage!.path.split('/').last}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        IconButton(
                          onPressed: _clearMedia,
                          icon: const Icon(Icons.clear, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  if (_selectedVideo != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.videocam, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Video selected: ${_selectedVideo!.path.split('/').last}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        IconButton(
                          onPressed: _clearMedia,
                          icon: const Icon(Icons.clear, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child:
                            Icon(Icons.videocam, size: 40, color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedType == BroadcastMessageType.link)
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'External Link',
                  border: OutlineInputBorder(),
                ),
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a link';
                  }
                  return null;
                },
              ),
            if (_selectedType == BroadcastMessageType.poll) ...[
              const SizedBox(height: 16),
              Text(l10n.pollOptions),
              ...List.generate(4, (final index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Option ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (final value) {
                      _pollOptions[index] = value;
                    },
                  ),
                );
              }),
            ],
            const SizedBox(height: 16),
            _buildTargetingFilters(),
            const SizedBox(height: 16),
            _buildSchedulingOptions(),
            if (_estimatedRecipients != null) ...[
              const SizedBox(height: 16),
              Text(
                'Estimated Recipients: $_estimatedRecipients',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTargetingFilters() {
    final l10n = AppLocalizations.of(context)!;

    return ExpansionTile(
      title: Text(l10n.targetingFilters),
      children: [
        // Countries
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Countries (comma-separated)',
            border: OutlineInputBorder(),
          ),
          onChanged: (final value) {
            setState(() {
              _filters = _filters.copyWith(
                countries: value.isEmpty
                    ? null
                    : value.split(',').map((final e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
        const SizedBox(height: 16),
        // Cities
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Cities (comma-separated)',
            border: OutlineInputBorder(),
          ),
          onChanged: (final value) {
            setState(() {
              _filters = _filters.copyWith(
                cities: value.isEmpty
                    ? null
                    : value.split(',').map((final e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
        const SizedBox(height: 16),
        // Subscription Tiers
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Subscription Tiers (comma-separated)',
            border: OutlineInputBorder(),
          ),
          onChanged: (final value) {
            setState(() {
              _filters = _filters.copyWith(
                subscriptionTiers: value.isEmpty
                    ? null
                    : value.split(',').map((final e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
        const SizedBox(height: 16),
        // User Roles
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'User Roles (comma-separated)',
            border: OutlineInputBorder(),
          ),
          onChanged: (final value) {
            setState(() {
              _filters = _filters.copyWith(
                userRoles: value.isEmpty
                    ? null
                    : value.split(',').map((final e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
      ],
    );
  }

  Widget _buildSchedulingOptions() {
    final l10n = AppLocalizations.of(context)!;

    return ExpansionTile(
      title: Text(l10n.scheduling),
      children: [
        ListTile(
          title: Text(l10n.scheduleForLater),
          trailing: Switch(
            value: _scheduledDate != null,
            onChanged: (final value) {
              if (value) {
                _selectScheduledDateTime();
              } else {
                setState(() {
                  _scheduledDate = null;
                  _scheduledTime = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectScheduledDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _scheduledDate = date;
          _scheduledTime = time;
        });
      }
    }
  }

  Future<void> _estimateRecipients() async {
    if (_filters.countries == null &&
        _filters.cities == null &&
        _filters.subscriptionTiers == null &&
        _filters.userRoles == null) {
      setState(() {
        _estimatedRecipients = null;
      });
      return;
    }

    try {
      final service = ref.read(broadcastServiceProvider);
      final count = await service.estimateTargetAudience(_filters);
      setState(() {
        _estimatedRecipients = count;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error estimating recipients: $e')),
      );
    }
  }

  // Image and Video Picker Methods
  Future<void> _pickImage() async {
    if (kIsWeb) {
      return;
    }
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _selectedVideo = null; // Clear video if image is selected
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _pickVideo() async {
    if (kIsWeb) {
      return;
    }
    try {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5), // 5 minute limit
      );

      if (pickedFile != null) {
        setState(() {
          _selectedVideo = File(pickedFile.path);
          _selectedImage = null; // Clear image if video is selected
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  // TODO: Implement media upload without Firebase Storage
  // Method removed as it was unused

  void _clearMedia() {
    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
    });
  }

  Future<void> _saveMessage() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    // Additional admin role check before saving
    final isAdmin = await ref.read(isAdminProvider.future);
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noPermissionForBroadcast),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Upload media files if selected
      String? imageUrl;
      String? videoUrl;

      if (_selectedImage != null) {
        // TODO: Implement media upload to Firebase Storage
        imageUrl = 'placeholder_image_url';
      }

      if (_selectedVideo != null) {
        // TODO: Implement video upload to Firebase Storage
        videoUrl = 'placeholder_video_url';
      }

      // TODO: Implement actual message creation
      final message = AdminBroadcastMessage(
        id: '',
        title: _titleController.text,
        content: _contentController.text,
        type: _selectedType,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
        externalLink: _selectedType == BroadcastMessageType.link
            ? _linkController.text
            : null,
        pollOptions: _selectedType == BroadcastMessageType.poll
            ? _pollOptions.where((final option) => option.isNotEmpty).toList()
            : null,
        targetingFilters: _filters,
        createdByAdminId: user.uid,
        createdByAdminName: user.displayName ?? 'Admin',
        createdAt: DateTime.now(),
        scheduledFor: _scheduledDate != null && _scheduledTime != null
            ? DateTime(
                _scheduledDate!.year,
                _scheduledDate!.month,
                _scheduledDate!.day,
                _scheduledTime!.hour,
                _scheduledTime!.minute,
              )
            : null,
        status: BroadcastMessageStatus.pending,
        estimatedRecipients: _estimatedRecipients,
      );

      final service = ref.read(broadcastServiceProvider);
      await service.createBroadcastMessage(message);

      // Clear form and media
      _clearMedia();
      _titleController.clear();
      _contentController.clear();
      _linkController.clear();

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.messageSavedSuccessfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSavingMessage(e))),
      );
    }
  }

  Future<void> _sendMessage(final String messageId) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final service = ref.read(broadcastServiceProvider);
      await service.sendBroadcastMessage(messageId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.messageSentSuccessfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSendingMessage(e))),
      );
    }
  }

  void _showMessageDetails(final AdminBroadcastMessage message) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(message.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.content(message.content)),
              const SizedBox(height: 8),
              Text(l10n.type(message.type.toString())),
              if (message.imageUrl != null) ...[
                const SizedBox(height: 8),
                const Text('Image:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(message.imageUrl!, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (final context, final error, final stackTrace) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      );
                    },
                  ),
                ),
              ],
              if (message.videoUrl != null) ...[
                const SizedBox(height: 8),
                const Text('Video:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(message.videoUrl!, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.videocam, size: 40, color: Colors.grey),
                  ),
                ),
              ],
              if (message.externalLink != null)
                Text(l10n.link(message.externalLink!)),
              if (message.pollOptions != null) ...[
                const SizedBox(height: 8),
                Text(l10n.pollOptions),
                ...message.pollOptions!
                    .map((final option) => Text('• $option')),
              ],
              const SizedBox(height: 8),
              Text(l10n.status(message.status.toString())),
              if (message.actualRecipients != null)
                Text(l10n.recipients(message.actualRecipients!)),
              if (message.openedCount != null)
                Text(l10n.opened(message.openedCount!)),
              if (message.clickedCount != null)
                Text(l10n.clicked(message.clickedCount!)),
              const SizedBox(height: 8),
              Text(l10n.created(message.createdAt)),
              if (message.scheduledFor != null)
                Text(l10n.scheduled(message.scheduledFor!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
