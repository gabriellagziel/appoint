import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/playtime_controller.dart';
import '../models/playtime_model.dart';
import '../widgets/playtime_quick_picks.dart';

class PlaytimeConfigScreen extends ConsumerStatefulWidget {
  const PlaytimeConfigScreen({super.key});

  @override
  ConsumerState<PlaytimeConfigScreen> createState() =>
      _PlaytimeConfigScreenState();
}

class _PlaytimeConfigScreenState extends ConsumerState<PlaytimeConfigScreen> {
  final _roomCodeController = TextEditingController();
  final _serverCodeController = TextEditingController();
  final _gameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _roomCodeController.dispose();
    _serverCodeController.dispose();
    _gameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playtimeConfig = ref.watch(playtimeControllerProvider);
    final controller = ref.read(playtimeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playtime Configuration'),
        actions: [
          TextButton(
            onPressed: playtimeConfig?.isValid == true ? _saveConfig : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Playtime Type Selection
          _buildPlaytimeTypeSection(controller),
          const SizedBox(height: 24),

          // Game Selection
          _buildGameSelectionSection(controller),
          const SizedBox(height: 24),

          // Platform Selection (for virtual)
          if (playtimeConfig?.isVirtual == true) ...[
            _buildPlatformSection(controller),
            const SizedBox(height: 24),
          ],

          // Room/Server Code (for virtual)
          if (playtimeConfig?.requiresRoomCode == true) ...[
            _buildRoomCodeSection(controller),
            const SizedBox(height: 24),
          ],

          if (playtimeConfig?.requiresServerCode == true) ...[
            _buildServerCodeSection(controller),
            const SizedBox(height: 24),
          ],

          // Location (for physical)
          if (playtimeConfig?.requiresLocation == true) ...[
            _buildLocationSection(controller),
            const SizedBox(height: 24),
          ],

          // Max Players
          _buildMaxPlayersSection(controller),
          const SizedBox(height: 24),

          // Settings
          _buildSettingsSection(controller),
        ],
      ),
    );
  }

  Widget _buildPlaytimeTypeSection(PlaytimeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Playtime Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTypeCard(
                    PlaytimeType.physical,
                    controller,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeCard(
                    PlaytimeType.virtual,
                    controller,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(PlaytimeType type, PlaytimeController controller) {
    final config = ref.watch(playtimeControllerProvider);
    final isSelected = config?.type == type;
    final typeConfig = PlaytimeConfig(type: type);

    return InkWell(
      onTap: () => controller.setPlaytimeType(type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? typeConfig.color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? typeConfig.color.withValues(alpha: 0.1) : null,
        ),
        child: Column(
          children: [
            Icon(
              typeConfig.icon,
              color: typeConfig.color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              typeConfig.displayName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              typeConfig.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSelectionSection(PlaytimeController controller) {
    final config = ref.watch(playtimeControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Game',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _gameController,
              decoration: const InputDecoration(
                labelText: 'Game Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., Football, Minecraft, Chess',
              ),
              onChanged: (value) => controller.setGame(value),
            ),
            const SizedBox(height: 16),
            PlaytimeQuickPicks(
              type: config?.type ?? PlaytimeType.physical,
              selectedGame: config?.game,
              onGameSelected: (game) {
                controller.selectGame(game);
                _gameController.text = game.name;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSection(PlaytimeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Platform',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PlaytimePlatform>(
              decoration: const InputDecoration(
                labelText: 'Select Platform',
                border: OutlineInputBorder(),
              ),
              items: PlaytimePlatform.values.map((platform) {
                final config = PlaytimeConfig(
                    type: PlaytimeType.virtual, platform: platform);
                return DropdownMenuItem(
                  value: platform,
                  child: Text(config.platformDisplayName ?? platform.name),
                );
              }).toList(),
              onChanged: (platform) {
                if (platform != null) {
                  controller.setPlatform(platform);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCodeSection(PlaytimeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Code',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _roomCodeController,
              decoration: const InputDecoration(
                labelText: 'Room Code',
                border: OutlineInputBorder(),
                hintText: 'Enter room code',
              ),
              onChanged: (value) => controller.setRoomCode(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerCodeSection(PlaytimeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discord Server',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _serverCodeController,
              decoration: const InputDecoration(
                labelText: 'Server Code',
                border: OutlineInputBorder(),
                hintText: 'Enter Discord server code',
              ),
              onChanged: (value) => controller.setServerCode(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(PlaytimeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Meeting Location',
                border: OutlineInputBorder(),
                hintText: 'e.g., Central Park, Community Center',
              ),
              onChanged: (value) => controller.setLocation(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaxPlayersSection(PlaytimeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Maximum Players',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Max Players',
                border: OutlineInputBorder(),
              ),
              items: [2, 4, 6, 8, 10, 12, 16, 20].map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text('$count players'),
                );
              }).toList(),
              onChanged: (count) {
                if (count != null) {
                  controller.setMaxPlayers(count);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(PlaytimeController controller) {
    final config = ref.watch(playtimeControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Competitive'),
              subtitle: const Text('Enable competitive mode'),
              value: config?.isCompetitive ?? false,
              onChanged: (value) => controller.setCompetitive(value),
            ),
            SwitchListTile(
              title: const Text('Family Friendly'),
              subtitle: const Text('Suitable for all ages'),
              value: config?.isFamilyFriendly ?? true,
              onChanged: (value) => controller.setFamilyFriendly(value),
            ),
          ],
        ),
      ),
    );
  }

  void _saveConfig() {
    final config = ref.read(playtimeControllerProvider);
    if (config != null) {
      // TODO: Save configuration and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playtime configuration saved!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
