import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final void Function(String flow) onPick;
  final String tMeeting;
  final String tReminder;
  final String tGroup;
  final String tPlaytime;
  const QuickActions({
    super.key,
    required this.onPick,
    required this.tMeeting,
    required this.tReminder,
    required this.tGroup,
    required this.tPlaytime,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _QA(icon: Icons.event, label: tMeeting, flow: 'meeting'),
      _QA(icon: Icons.alarm, label: tReminder, flow: 'reminder'),
      _QA(icon: Icons.group, label: tGroup, flow: 'group'),
      _QA(icon: Icons.videogame_asset, label: tPlaytime, flow: 'playtime'),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (c, i) {
        final it = items[i];
        return InkWell(
          onTap: () => onPick(it.flow),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(it.icon, size: 28),
                const SizedBox(height: 8),
                Text(it.label, textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QA {
  final IconData icon;
  final String label;
  final String flow;
  _QA({required this.icon, required this.label, required this.flow});
}
