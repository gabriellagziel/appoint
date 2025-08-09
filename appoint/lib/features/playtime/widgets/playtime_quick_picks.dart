import 'package:flutter/material.dart';
import '../models/playtime_model.dart';

class PlaytimeQuickPicks extends StatelessWidget {
  final PlaytimeType type;
  final String? selectedGame;
  final Function(PopularGame) onGameSelected;

  const PlaytimeQuickPicks({
    super.key,
    required this.type,
    this.selectedGame,
    required this.onGameSelected,
  });

  @override
  Widget build(BuildContext context) {
    final games = popularGames.where((game) {
      if (type == PlaytimeType.physical) {
        return game.platform == null; // Physical games have no platform
      } else {
        return game.platform != null; // Virtual games have platform
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular ${type == PlaytimeType.physical ? 'Physical' : 'Virtual'} Games',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: games.map((game) => _buildGameChip(context, game)).toList(),
        ),
      ],
    );
  }

  Widget _buildGameChip(BuildContext context, PopularGame game) {
    final isSelected = selectedGame == game.name;
    final isCompetitive = game.isCompetitive;
    final isFamilyFriendly = game.isFamilyFriendly;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (game.icon != null) ...[
            Text(game.icon!),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              game.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onGameSelected(game);
        }
      },
      backgroundColor: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      avatar: isCompetitive
          ? Icon(
              Icons.emoji_events,
              size: 16,
              color:
                  isSelected ? Theme.of(context).primaryColor : Colors.orange,
            )
          : isFamilyFriendly
              ? Icon(
                  Icons.family_restroom,
                  size: 16,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.green,
                )
              : null,
    );
  }
}



