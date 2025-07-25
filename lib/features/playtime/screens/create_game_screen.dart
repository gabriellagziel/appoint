import 'dart:io';

import 'package:appoint/config/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/models/playtime_game.dart';
import 'package:appoint/providers/playtime_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateGameScreen extends ConsumerStatefulWidget {
  const CreateGameScreen({super.key});

  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Action';
  int _minAge = 5;
  int _maxAge = 12;
  int _maxParticipants = 4;
  int _estimatedDuration = 30;
  File? _selectedImage;
  bool _isPublic = true;
  bool _parentApprovalRequired = false;

  final List<String> _categories = [
    'Action',
    'Adventure',
    'Puzzle',
    'Strategy',
    'Sports',
    'Educational',
    'Creative',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Game'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Game Icon Section
            _buildImageSection(l10n),
            const SizedBox(height: 24),

            // Basic Information
            _buildBasicInformation(l10n),
            const SizedBox(height: 24),

            // Game Settings
            _buildGameSettings(l10n),
            const SizedBox(height: 24),

            // Privacy Settings
            _buildPrivacySettings(l10n),
            const SizedBox(height: 32),

            // Create Button
            _buildCreateButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Icon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
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
                          'Add Icon',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );

  Widget _buildBasicInformation(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),

        // Game Name
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Game Name',
            hintText: 'Enter game name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.games),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a game name';
            }
            if (value.length < 3) {
              return 'Game name must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Game Description
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Game Description',
            hintText: 'Describe your game',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.description),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a game description';
            }
            if (value.length < 10) {
              return 'Description must be at least 10 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Category
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.category),
          ),
          items: _categories.map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            ),).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
      ],
    );

  Widget _buildGameSettings(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),

        // Age Range
        Text(
          'Age Range: $_minAge - $_maxAge years',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(_minAge.toDouble(), _maxAge.toDouble()),
          min: 3,
          max: 18,
          divisions: 15,
          labels: RangeLabels('$_minAge', '$_maxAge'),
          onChanged: (values) {
            setState(() {
              final _minAge = values.start.round();
              final _maxAge = values.end.round();
            });
          },
        ),
        const SizedBox(height: 16),

        // Max Participants
        Text(
          'Max Participants: $_maxParticipants',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _maxParticipants.toDouble(),
          min: 2,
          max: 10,
          divisions: 8,
          label: '$_maxParticipants',
          onChanged: (value) {
            setState(() {
              final _maxParticipants = value.round();
            });
          },
        ),
        const SizedBox(height: 16),

        // Estimated Duration
        Text(
          'Estimated Duration: $_estimatedDuration minutes',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _estimatedDuration.toDouble(),
          min: 15,
          max: 120,
          divisions: 21,
          label: '$_estimatedDuration',
          onChanged: (value) {
            setState(() {
              final _estimatedDuration = value.round();
            });
          },
        ),
      ],
    );

  Widget _buildPrivacySettings(AppLocalizations l10n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),

        // Public/Private Toggle
        SwitchListTile(
          title: const Text('Make Game Public'),
          subtitle: const Text('Allow other users to find and join this game'),
          value: _isPublic,
          onChanged: (value) {
            setState(() {
              _isPublic = value;
            });
          },
          activeColor: AppTheme.primaryColor,
        ),

        // Parent Approval Toggle
        SwitchListTile(
          title: const Text('Require Parent Approval'),
          subtitle: const Text('Parents must approve before children can join'),
          value: _parentApprovalRequired,
          onChanged: (value) {
            setState(() {
              _parentApprovalRequired = value;
            });
          },
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );

  Widget _buildCreateButton(AppLocalizations l10n) => Consumer(
      builder: (context, final ref, final child) {
        final createGameState = ref.watch(playtimeGameNotifierProvider);

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: createGameState.isLoading ? null : _createGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: createGameState.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Create Game',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );

  Future<void> _pickImage() async {
    if (kIsWeb) {
      return;
    }
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (image != null) {
      setState(() {
        final _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _createGame() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final game = PlaytimeGame(
        id: '',
        name: _nameController.text.trim(),
        createdBy: '', // Will be set by service
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await ref.read(playtimeGameNotifierProvider.notifier).createGame(game);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create game: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
