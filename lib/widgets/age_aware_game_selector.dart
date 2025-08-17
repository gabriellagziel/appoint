import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playtime_game.dart';
import '../services/playtime_service.dart';
import '../providers/playtime_provider.dart';
import '../exceptions/playtime_exceptions.dart';

/// Age-aware game selector widget that respects user age restrictions
class AgeAwareGameSelector extends ConsumerWidget {
  final String userId;
  final Function(PlaytimeGame) onGameSelected;
  final bool showRestrictedGames;
  final Widget? emptyWidget;

  const AgeAwareGameSelector({
    super.key,
    required this.userId,
    required this.onGameSelected,
    this.showRestrictedGames = true,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesWithApproval = ref.watch(playtimeGamesWithApprovalProvider(userId));
    final userAgeInfo = ref.watch(userAgeInfoProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Age info header
        userAgeInfo.when(
          data: (ageInfo) => _buildAgeInfoHeader(context, ageInfo),
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => const SizedBox.shrink(),
        ),
        
        const SizedBox(height: 16),
        
        // Games list
        gamesWithApproval.when(
          data: (games) => _buildGamesList(context, games),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(context, error, stack),
        ),
      ],
    );
  }

  Widget _buildAgeInfoHeader(BuildContext context, UserAgeInfo ageInfo) {
    if (ageInfo.isAdult) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              'Adult User - Full Access',
              style: TextStyle(
                color: Colors.green.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (ageInfo.calculatedAge != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.child_care, color: Colors.blue.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              'Age ${ageInfo.calculatedAge} - Age restrictions apply',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildGamesList(BuildContext context, List<GameWithApprovalStatus> games) {
    if (games.isEmpty) {
      return emptyWidget ?? 
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No games available for your age group',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
    }

    // Filter games based on showRestrictedGames setting
    final filteredGames = showRestrictedGames 
        ? games 
        : games.where((g) => g.canAccess).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredGames.length,
      itemBuilder: (context, index) {
        final gameStatus = filteredGames[index];
        return _buildGameCard(context, gameStatus);
      },
    );
  }

  Widget _buildGameCard(BuildContext context, GameWithApprovalStatus gameStatus) {
    final game = gameStatus.game;
    final isEnabled = gameStatus.canAccess && !gameStatus.needsParentApproval;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: isEnabled ? () => _handleGameSelection(context, gameStatus) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isEnabled ? null : Colors.grey.shade100,
          ),
          child: Row(
            children: [
              // Game icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isEnabled ? Colors.blue.shade100 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    game.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Game details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isEnabled ? Colors.grey.shade700 : Colors.grey.shade500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildGameStatusChip(gameStatus),
                  ],
                ),
              ),
              
              // Action icon
              Icon(
                isEnabled ? Icons.arrow_forward_ios : Icons.lock,
                color: isEnabled ? Colors.grey.shade400 : Colors.grey.shade500,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameStatusChip(GameWithApprovalStatus gameStatus) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text = gameStatus.displayMessage;

    if (!gameStatus.canAccess) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      icon = Icons.block;
    } else if (gameStatus.needsParentApproval) {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      icon = Icons.supervisor_account;
    } else {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stack) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error loading games',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleGameSelection(BuildContext context, GameWithApprovalStatus gameStatus) {
    if (gameStatus.needsParentApproval) {
      _showParentApprovalDialog(context, gameStatus.game);
    } else if (gameStatus.canAccess) {
      onGameSelected(gameStatus.game);
    } else {
      _showAccessDeniedDialog(context, gameStatus);
    }
  }

  void _showParentApprovalDialog(BuildContext context, PlaytimeGame game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parent Approval Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The game "${game.name}" requires parent approval before you can play.'),
            const SizedBox(height: 16),
            const Text(
              'Please ask your parent or guardian to approve this game in their parent dashboard.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAccessDeniedDialog(BuildContext context, GameWithApprovalStatus gameStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Access Restricted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You cannot access "${gameStatus.game.name}" because:'),
            const SizedBox(height: 8),
            Text(
              gameStatus.restrictionReason ?? 'Age restrictions apply',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              'Age range for this game: ${gameStatus.game.minAge}-${gameStatus.game.maxAge} years',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Simple game selection error handler
class GameSelectionErrorHandler {
  static void handleError(BuildContext context, Object error) {
    String message = 'An error occurred';
    String? action;

    if (error is AgeRestrictedError) {
      message = 'You are ${error.isTooYoung ? 'too young' : 'too old'} for this game.\n'
          'Required age: ${error.ageRangeString}';
    } else if (error is ParentApprovalRequiredError) {
      message = 'This game requires parent approval.\nPlease ask your parent or guardian to approve it.';
      action = 'Contact Parent';
    } else if (error is GameNotFoundError) {
      message = 'The selected game is no longer available.';
    } else if (error is UserDataIncompleteError) {
      message = 'Unable to verify your age. Please complete your profile.';
      action = 'Update Profile';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cannot Access Game'),
        content: Text(message),
        actions: [
          if (action != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle action (navigate to parent contact or profile)
              },
              child: Text(action),
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
















