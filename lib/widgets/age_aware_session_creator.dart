import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playtime_game.dart';
import '../models/playtime_session.dart';
import '../services/playtime_service.dart';
import '../exceptions/playtime_exceptions.dart';
import 'age_aware_game_selector.dart';

/// Widget for creating playtime sessions with age validation
class AgeAwareSessionCreator extends ConsumerStatefulWidget {
  final String userId;
  final VoidCallback? onSessionCreated;

  const AgeAwareSessionCreator({
    super.key,
    required this.userId,
    this.onSessionCreated,
  });

  @override
  ConsumerState<AgeAwareSessionCreator> createState() => _AgeAwareSessionCreatorState();
}

class _AgeAwareSessionCreatorState extends ConsumerState<AgeAwareSessionCreator> {
  PlaytimeGame? selectedGame;
  bool isCreating = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Playtime Session'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedGame == null) ...[
              _buildGameSelectionSection(),
            ] else ...[
              _buildSelectedGameSection(),
              const SizedBox(height: 24),
              _buildSessionDetailsSection(),
              const SizedBox(height: 24),
              _buildCreateButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select a Game',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose a game that matches your age and interests. Games marked with restrictions require parent approval.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        AgeAwareGameSelector(
          userId: widget.userId,
          onGameSelected: _handleGameSelected,
          showRestrictedGames: true,
        ),
      ],
    );
  }

  Widget _buildSelectedGameSection() {
    if (selectedGame == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Selected Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedGame = null;
                  titleController.clear();
                  descriptionController.clear();
                });
              },
              child: const Text('Change Game'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      selectedGame!.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedGame!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedGame!.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildGameMetadata(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameMetadata() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildMetadataChip(
          'Age ${selectedGame!.minAge}-${selectedGame!.maxAge}',
          Icons.cake,
          Colors.purple,
        ),
        _buildMetadataChip(
          '${selectedGame!.maxParticipants} max',
          Icons.group,
          Colors.green,
        ),
        _buildMetadataChip(
          '${selectedGame!.estimatedDuration} min',
          Icons.access_time,
          Colors.orange,
        ),
        _buildMetadataChip(
          selectedGame!.type,
          selectedGame!.type == 'virtual' ? Icons.computer : Icons.place,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildMetadataChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Session Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Session Title',
            hintText: 'Give your session a fun name',
            border: OutlineInputBorder(),
          ),
          maxLength: 50,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Describe what you want to do in this session',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isCreating || titleController.text.trim().isEmpty
            ? null
            : _createSession,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isCreating
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Creating Session...'),
                ],
              )
            : const Text(
                'Create Session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  void _handleGameSelected(PlaytimeGame game) {
    setState(() {
      selectedGame = game;
      // Pre-fill title with game name if empty
      if (titleController.text.isEmpty) {
        titleController.text = '${game.name} Session';
      }
    });
  }

  Future<void> _createSession() async {
    if (selectedGame == null || titleController.text.trim().isEmpty) return;

    setState(() {
      isCreating = true;
    });

    try {
      // Create session object
      final session = PlaytimeSession(
        id: PlaytimeService.generateSessionId(),
        gameId: selectedGame!.id,
        type: selectedGame!.type,
        title: titleController.text.trim(),
        description: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : null,
        creatorId: widget.userId,
        participants: [
          PlaytimeParticipant(
            userId: widget.userId,
            displayName: 'Me', // This should come from user data
            role: 'creator',
            joinedAt: DateTime.now(),
            status: 'joined',
          ),
        ],
        duration: selectedGame!.estimatedDuration,
        parentApprovalStatus: PlaytimeParentApprovalStatus(
          required: selectedGame!.parentApprovalRequired,
        ),
        adminApprovalStatus: PlaytimeAdminApprovalStatus(),
        safetyFlags: PlaytimeSafetyFlags(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maxParticipants: selectedGame!.maxParticipants,
      );

      // Use the validation-enabled create method
      await PlaytimeService.createSessionWithValidation(session);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Session created successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // Navigate to session view
              },
            ),
          ),
        );

        // Call callback and navigate back
        widget.onSessionCreated?.call();
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        _handleCreationError(error);
      }
    } finally {
      if (mounted) {
        setState(() {
          isCreating = false;
        });
      }
    }
  }

  void _handleCreationError(Object error) {
    String message = 'Failed to create session';
    String? actionLabel;
    VoidCallback? action;

    if (error is AgeRestrictedError) {
      message = 'Age restriction: You are ${error.isTooYoung ? 'too young' : 'too old'} '
          'for "${error.gameName}".\nRequired age: ${error.ageRangeString}';
    } else if (error is ParentApprovalRequiredError) {
      message = 'This game requires parent approval before you can create a session.';
      actionLabel = 'Request Approval';
      action = () {
        // Navigate to parent approval request
      };
    } else if (error is SafetyRestrictedError) {
      message = 'Safety restriction: ${error.reason}';
    } else if (error is MaxParticipantsReachedError) {
      message = 'This session is full (${error.maxParticipants} participants maximum).';
    } else if (error is UserDataIncompleteError) {
      message = 'Unable to verify your age. Please complete your profile.';
      actionLabel = 'Update Profile';
      action = () {
        // Navigate to profile update
      };
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cannot Create Session'),
        content: Text(message),
        actions: [
          if (actionLabel != null && action != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                action();
              },
              child: Text(actionLabel),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}


