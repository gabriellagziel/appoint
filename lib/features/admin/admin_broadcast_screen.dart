import 'dart:io';

import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/utils/admin_localizations.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:appoint/services/broadcast_service.dart' hide adminBroadcastServiceProvider;
import 'package:appoint/infra/firebase_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AdminBroadcastScreen extends ConsumerStatefulWidget {
  const AdminBroadcastScreen({super.key});

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
  DateTime? _scheduledFor;
  File? _selectedImage;
  File? _selectedVideo;
  List<String> _pollOptions = ['', ''];
  int _estimatedRecipients = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final broadcastMessages = ref.watch(broadcastMessagesProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.adminBroadcast ?? 'Admin Broadcast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: l10n != null 
                ? () => _showComposeDialog(context, l10n!, theme)
                : null,
          ),
        ],
      ),
      body: isAdmin.when(
        data: (hasAdminAccess) {
          if (hasAdminAccess != true) {
            return Center(
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
            data: _buildMessagesList,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, final stack) =>
                Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) => Center(
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

  Widget _buildMessagesList(List<AdminBroadcastMessage> messages) {
    final l10n = AppLocalizations.of(context);

    if (messages.isEmpty) {
      return Center(
        child: Text(l10n?.noBroadcastMessages ?? 'No broadcast messages'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, final index) {
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
                  l10n?.content(message.content) ?? 'Content: ${message.content}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n?.type(message.type.toString()) ?? 'Type: ${message.type}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (message.actualRecipients != null)
                  Text(
                    l10n?.recipients(message.actualRecipients!) ?? 'Recipients: ${message.actualRecipients}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (message.openedCount != null)
                  Text(
                    l10n?.opened(message.openedCount!) ?? 'Opened: ${message.openedCount}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                Text(
                  l10n?.created(message.createdAt) ?? 'Created: ${message.createdAt}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (message.scheduledFor != null)
                  Text(
                    l10n?.scheduled(message.scheduledFor!) ?? 'Scheduled: ${message.scheduledFor}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (message.status == BroadcastMessageStatus.pending)
                      TextButton(
                        onPressed: () => _sendMessage(message.id),
                        child: Text(l10n?.sendNow ?? 'Send Now'),
                      ),
                    TextButton(
                      onPressed: () => _showMessageDetails(message),
                      child: Text(l10n?.details ?? 'Details'),
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

  Widget _buildStatusChip(BroadcastMessageStatus status) {
    Color color;
    String text;

    switch (status) {
      case BroadcastMessageStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case BroadcastMessageStatus.sending:
        color = Colors.blue;
        text = 'Sending';
        break;
      case BroadcastMessageStatus.sent:
        color = Colors.green;
        text = 'Sent';
        break;
      case BroadcastMessageStatus.failed:
        color = Colors.red;
        text = 'Failed';
        break;
      case BroadcastMessageStatus.partially_sent:
        color = Colors.amber;
        text = 'Partial';
        break;
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  void _showComposeDialog(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    // Check admin privileges before showing the dialog
    final isAdmin = ref.read(isAdminProvider);
    isAdmin.when(
      data: (hasAdminAccess) {
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
          builder: (context) => AlertDialog(
            title: Text(l10n.composeBroadcastMessage),
            content: SizedBox(
              width: double.maxFinite,
              child: _buildComposeForm(l10n, theme),
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
      error: (error, final stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorCheckingPermissions(error)),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  Widget _buildComposeForm(AppLocalizations l10n, ThemeData theme) {

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BroadcastMessageType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.messageType,
                border: const OutlineInputBorder(),
              ),
              items: BroadcastMessageType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                ),).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: l10n.content,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterContent;
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
                            '${l10n.imageSelected}: ${_selectedImage!.path.split('/').last}',
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
                            '${l10n.videoSelected}: ${_selectedVideo!.path.split('/').last}',
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
                decoration: InputDecoration(
                  labelText: l10n.externalLink,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterLink;
                  }
                  return null;
                },
              ),
            if (_selectedType == BroadcastMessageType.poll) ...[
              const SizedBox(height: 16),
              Text(l10n.pollOptions),
              ...List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '${l10n.option} ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _pollOptions[index] = value;
                    },
                  ),
                ),),
            ],
            const SizedBox(height: 16),
            _buildTargetingFilters(l10n),
            const SizedBox(height: 16),
            _buildSchedulingOptions(l10n),
            if (_estimatedRecipients != 0) ...[
              const SizedBox(height: 16),
              Text(
                '${l10n.estimatedRecipients}: $_estimatedRecipients',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTargetingFilters(AppLocalizations l10n) {

    return ExpansionTile(
      title: Text(l10n.targetingFilters),
      children: [
        // Countries
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.countries,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(
                countries: value.isEmpty
                    ? null
                    : value.split(',').map((e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
        const SizedBox(height: 16),
        // Cities
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.cities,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(
                cities: value.isEmpty
                    ? null
                    : value.split(',').map((e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
        const SizedBox(height: 16),
        // Subscription Tiers
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.subscriptionTiers,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(
                subscriptionTiers: value.isEmpty
                    ? null
                    : value.split(',').map((e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
        const SizedBox(height: 16),
        // User Roles
        TextFormField(
          decoration: InputDecoration(
            labelText: l10n.userRoles,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(
                userRoles: value.isEmpty
                    ? null
                    : value.split(',').map((e) => e.trim()).toList(),
              );
            });
            _estimateRecipients();
          },
        ),
      ],
    );
  }

  Widget _buildSchedulingOptions(AppLocalizations l10n) {

    return ExpansionTile(
      title: Text(l10n.scheduling),
      children: [
        ListTile(
          title: Text(l10n.scheduleForLater),
          trailing: Switch(
            value: _scheduledFor != null,
            onChanged: (value) {
              if (value) {
                _selectScheduledDateTime();
              } else {
                setState(() {
                  _scheduledFor = null;
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

    if (!mounted) return;
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (!mounted) return;
      if (time != null) {
        setState(() {
          _scheduledFor = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
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
        _estimatedRecipients = 0;
      });
      return;
    }

    try {
      final service = ref.read(adminBroadcastServiceProvider);
      final count = await service.estimateTargetAudience(_filters);
      setState(() {
        _estimatedRecipients = count;
      });
    } catch (e) {
      if (!mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).errorEstimatingRecipients}: $e')),
        );
      }
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
          final _selectedImage = File(pickedFile.path);
          final _selectedVideo = null; // Clear video if image is selected
        });
      }
    } catch (e) {
      if (!mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).errorPickingImage}: $e')),
        );
      }
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
          final _selectedVideo = File(pickedFile.path);
          final _selectedImage = null; // Clear image if video is selected
        });
      }
    } catch (e) {
      if (!mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).errorPickingVideo}: $e')),
        );
      }
    }
  }

  // TODO(username): Implement media upload without Firebase Storage
  // Method removed as it was unused

  void _clearMedia() {
    setState(() {
      _selectedImage = null;
      final _selectedVideo = null;
    });
  }

  Future<void> _saveMessage() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    // Additional admin role check before saving
    final isAdmin = await ref.read(isAdminProvider.future);
    if (!isAdmin) {
      if (!mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noPermissionForBroadcast),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('${AppLocalizations.of(context).userNotAuthenticated}');
      }

      // Upload media files if selected
      String? imageUrl;
      String? videoUrl;

      if (_selectedImage != null) {
        try {
          final imageUrl = await FirebaseStorageService.instance.uploadBroadcastImage(_selectedImage!);
        } catch (e) {
          throw Exception('${AppLocalizations.of(context).failedToUploadImage}: $e');
        }
      }

      if (_selectedVideo != null) {
        try {
          final videoUrl = await FirebaseStorageService.instance.uploadBroadcastVideo(_selectedVideo!);
        } catch (e) {
          throw Exception('${AppLocalizations.of(context).failedToUploadVideo}: $e');
        }
      }

      // TODO(username): Implement actual message creation
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
            ? _pollOptions.where((option) => option.isNotEmpty).toList()
            : null,
        targetingFilters: _filters,
        createdByAdminId: user.uid,
        createdByAdminName: user.displayName ?? 'Admin',
        createdAt: DateTime.now(),
        scheduledFor: _scheduledFor,
        status: BroadcastMessageStatus.pending,
        estimatedRecipients: _estimatedRecipients,
      );

      final service = ref.read(adminBroadcastServiceProvider);
      await service.createBroadcastMessage(message);

      // Clear form and media
      _clearMedia();
      _titleController.clear();
      _contentController.clear();
      _linkController.clear();

      if (!mounted) return;
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.messageSavedSuccessfully)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorSavingMessage(e))),
        );
      }
    }
  }

  Future<void> _sendMessage(String messageId) async {
    final l10n = AppLocalizations.of(context);

    try {
      final service = ref.read(adminBroadcastServiceProvider);
      await service.sendBroadcastMessage(messageId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.messageSentSuccessfully)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSendingMessage(e))),
      );
    }
  }

  void _showMessageDetails(AdminBroadcastMessage message) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                const Text('${AppLocalizations.of(context).image}:',
                    style: TextStyle(fontWeight: FontWeight.bold),),
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
                        (context, final error, final stackTrace) => Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                  ),
                ),
              ],
              if (message.videoUrl != null) ...[
                const SizedBox(height: 8),
                const Text('${AppLocalizations.of(context).video}:',
                    style: TextStyle(fontWeight: FontWeight.bold),),
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
                    .map((option) => Text('• $option')),
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
