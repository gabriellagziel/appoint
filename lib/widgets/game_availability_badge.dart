import 'package:flutter/material.dart';
import '../services/coppa_service.dart';

/// Badge widget to show game availability status based on user age
class GameAvailabilityBadge extends StatelessWidget {
  final int userAge;
  final int gameMinAge;
  final bool parentApprovalRequired;
  final bool parentApprovalGranted;
  final bool compact;

  const GameAvailabilityBadge({
    super.key,
    required this.userAge,
    required this.gameMinAge,
    required this.parentApprovalRequired,
    this.parentApprovalGranted = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getAvailabilityStatus();

    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        border: Border.all(color: status.color, width: 1),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: compact ? 12 : 14,
            color: status.color,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              status.label,
              style: TextStyle(
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: status.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _AvailabilityStatus _getAvailabilityStatus() {
    // Adults can play anything
    if (COPPAService.isAdult(userAge)) {
      return _AvailabilityStatus(
        icon: Icons.check_circle,
        label: 'Available',
        color: Colors.green,
        type: GameAvailabilityType.available,
      );
    }

    final isAgeAppropriate =
        COPPAService.isGameAgeAppropriate(userAge, gameMinAge);
    final needsApproval =
        COPPAService.requiresParentApproval(userAge, gameMinAge);

    // Game is not age-appropriate and no parent approval
    if (!isAgeAppropriate && !parentApprovalGranted) {
      if (COPPAService.isSubjectToCOPPA(userAge)) {
        // Children under 13 - completely restricted without approval
        return _AvailabilityStatus(
          icon: Icons.block,
          label: 'Restricted',
          color: Colors.red,
          type: GameAvailabilityType.restricted,
        );
      } else {
        // Teens - needs parent approval for age-inappropriate games
        return _AvailabilityStatus(
          icon: Icons.pending,
          label: 'Needs Approval',
          color: Colors.orange,
          type: GameAvailabilityType.needsApproval,
        );
      }
    }

    // Age-appropriate game but still needs parent approval (for children)
    if (isAgeAppropriate && needsApproval && !parentApprovalGranted) {
      return _AvailabilityStatus(
        icon: Icons.schedule,
        label: 'Needs Approval',
        color: Colors.orange,
        type: GameAvailabilityType.needsApproval,
      );
    }

    // Game is available (either age-appropriate for teens or approved by parent)
    return _AvailabilityStatus(
      icon: Icons.check_circle,
      label: 'Available',
      color: Colors.green,
      type: GameAvailabilityType.available,
    );
  }
}

enum GameAvailabilityType {
  available,
  needsApproval,
  restricted,
}

class _AvailabilityStatus {
  final IconData icon;
  final String label;
  final Color color;
  final GameAvailabilityType type;

  const _AvailabilityStatus({
    required this.icon,
    required this.label,
    required this.color,
    required this.type,
  });
}

/// Extension to easily create availability badges
extension GameAvailabilityBadgeExtension on Widget {
  Widget withAvailabilityBadge({
    required int userAge,
    required int gameMinAge,
    required bool parentApprovalRequired,
    bool parentApprovalGranted = false,
    bool compact = false,
    AlignmentGeometry alignment = Alignment.topRight,
  }) {
    return Stack(
      children: [
        this,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: GameAvailabilityBadge(
                userAge: userAge,
                gameMinAge: gameMinAge,
                parentApprovalRequired: parentApprovalRequired,
                parentApprovalGranted: parentApprovalGranted,
                compact: compact,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper function to check if user can immediately play a game
bool canPlayGameImmediately({
  required int userAge,
  required int gameMinAge,
  bool parentApprovalGranted = false,
}) {
  if (COPPAService.isAdult(userAge)) return true;

  final isAgeAppropriate =
      COPPAService.isGameAgeAppropriate(userAge, gameMinAge);
  final needsApproval =
      COPPAService.requiresParentApproval(userAge, gameMinAge);

  if (!isAgeAppropriate && !parentApprovalGranted) return false;
  if (needsApproval && !parentApprovalGranted) return false;

  return true;
}

/// Helper function to get availability message for UI
String getAvailabilityMessage({
  required int userAge,
  required int gameMinAge,
  bool parentApprovalRequired = false,
  bool parentApprovalGranted = false,
}) {
  if (COPPAService.isAdult(userAge)) {
    return 'You can play this game immediately.';
  }

  final isAgeAppropriate =
      COPPAService.isGameAgeAppropriate(userAge, gameMinAge);
  final needsApproval =
      COPPAService.requiresParentApproval(userAge, gameMinAge);

  if (!isAgeAppropriate && !parentApprovalGranted) {
    if (COPPAService.isSubjectToCOPPA(userAge)) {
      return 'This game is not suitable for your age. Ask a parent for special permission.';
    } else {
      return 'This game requires parent approval because it\'s rated for ages $gameMinAge+.';
    }
  }

  if (needsApproval && !parentApprovalGranted) {
    return 'This game requires parent approval before you can play.';
  }

  return 'You can play this game!';
}
