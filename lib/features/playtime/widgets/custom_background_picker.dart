import 'dart:io';

import 'package:appoint/config/theme.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/playtime_background.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:appoint/widgets/bottom_sheet_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CustomBackgroundPicker extends ConsumerStatefulWidget {
  CustomBackgroundPicker({
    super.key,
    this.selectedBackgroundId,
    required this.onBackgroundSelected,
    this.showUploadOption = true,
  });
  final String? selectedBackgroundId;
  final Function(String backgroundId) onBackgroundSelected;
  final bool showUploadOption;

  @override
  ConsumerState<CustomBackgroundPicker> createState() =>
      _CustomBackgroundPickerState();
}

class _CustomBackgroundPickerState
    extends ConsumerState<CustomBackgroundPicker> {
  String? _selectedBackgroundId;
  final bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _selectedBackgroundId = widget.selectedBackgroundId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Background',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),

        // Background Grid
        Consumer(
          builder: (context, final ref, final child) {
            final backgroundsAsync = ref.watch(allBackgroundsProvider);

            return backgroundsAsync.when(
              data: (backgrounds) {
                if (backgrounds.isEmpty) {
                  return _buildEmptyState(l10n);
                }

                return Column(
                  children: [
                    // All Backgrounds
                    _buildBackgroundSection(
                      'Available Backgrounds',
                      backgrounds,
                      l10n,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, final stack) => Text('Error: $error'),
            );
          },
        ),

        // Upload Button
        if (widget.showUploadOption) ...[
          const SizedBox(height: 16),
          _buildUploadButton(l10n),
        ],
      ],
    );
  }

  Widget _buildBackgroundSection(
    final String title,
    List<PlaytimeBackground> backgrounds,
    final AppLocalizations l10n,
  ) {
    if (backgrounds.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: backgrounds.length,
            itemBuilder: (context, final index) {
              final background = backgrounds[index];
              return _buildBackgroundCard(background);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundCard(PlaytimeBackground background) {
    final isSelected = _selectedBackgroundId == background.id;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedBackgroundId = background.id;
          });
          widget.onBackgroundSelected(background.id);
        },
        child: Card(
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? const BorderSide(color: AppTheme.primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  background.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, final error, final stackTrace) =>
                      Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              // Selection Indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              // Created by Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    background.createdBy,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No backgrounds available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your first background to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildUploadButton(AppLocalizations l10n) => Consumer(
        builder: (context, final ref, final child) {
          final uploadState = ref.watch(playtimeBackgroundNotifierProvider);

          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isUploading || uploadState.isLoading
                  ? null
                  : _showUploadDialog,
              icon: _isUploading || uploadState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.upload),
              label: Text(
                _isUploading || uploadState.isLoading
                    ? 'Uploading...'
                    : 'Upload Background',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
        },
      );

  void _showUploadDialog() {
    BottomSheetManager.show(
      context: context,
      child: _UploadBackgroundDialog(
        onBackgroundUploaded: (backgroundId) {
          setState(() {
            _selectedBackgroundId = backgroundId;
          });
          widget.onBackgroundSelected(backgroundId);
        },
      ),
    );
  }
}

class _UploadBackgroundDialog extends ConsumerStatefulWidget {
  const _UploadBackgroundDialog({required this.onBackgroundUploaded});
  final Function(String backgroundId) onBackgroundUploaded;

  @override
  ConsumerState<_UploadBackgroundDialog> createState() =>
      _UploadBackgroundDialogState();
}

class _UploadBackgroundDialogState
    extends ConsumerState<_UploadBackgroundDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  String _selectedCategory = 'Nature';
  final List<String> _selectedTags = [];
  bool _isUploading = false;

  final List<String> _categories = [
    'Nature',
    'Fantasy',
    'Space',
    'Animals',
    'Sports',
    'Art',
    'Other',
  ];

  final List<String> _availableTags = [
    'fun',
    'colorful',
    'adventure',
    'magical',
    'space',
    'ocean',
    'forest',
    'mountains',
    'animals',
    'sports',
    'art',
    'abstract',
    'cartoon',
    'realistic',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload Background',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image Selection
                      _buildImageSelection(),
                      const SizedBox(height: 16),

                      // Basic Info
                      _buildBasicInfo(),
                      const SizedBox(height: 16),

                      // Category Selection
                      _buildCategorySelection(),
                      const SizedBox(height: 16),

                      // Tags Selection
                      _buildTagsSelection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      );

  Widget _buildImageSelection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Background Image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 32,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to select image',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );

  Widget _buildBasicInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Background Name',
              hintText: 'Enter a name for your background',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your background',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
        ],
      );

  Widget _buildCategorySelection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ],
      );

  Widget _buildTagsSelection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                backgroundColor: Colors.grey[100],
                selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
        ],
      );

  Widget _buildActionButtons() => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isUploading ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  _canUpload() && !_isUploading ? _uploadBackground : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Upload'),
            ),
          ),
        ],
      );

  Future<void> _pickImage() async {
    if (kIsWeb) {
      return;
    }
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  bool _canUpload() =>
      _selectedImage != null &&
      _nameController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  Future<void> _uploadBackground() async {
    if (kIsWeb) {
      return;
    }
    if (!_canUpload()) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to upload a background'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await ref
          .read(playtimeBackgroundNotifierProvider.notifier)
          .createBackground(
            _nameController.text.trim(),
            _descriptionController.text.trim(),
            _selectedImage!.path,
            _selectedCategory,
            _selectedTags,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Background uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
        // Refresh the background list
        ref.invalidate(allBackgroundsProvider);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload background: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
