import 'package:flutter/material.dart';

class SuggestionsStrip extends StatelessWidget {
  const SuggestionsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final chips = const [
      _Sug('Plan your week', Icons.auto_graph),
      _Sug('Add recurring reminder', Icons.repeat),
      _Sug('Invite a friend', Icons.person_add_alt_1),
      _Sug('Set focus time', Icons.timelapse),
    ];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = chips[i];
          return ActionChip(
            key: Key('suggestion_$i'),
            avatar: Icon(c.icon, size: 18),
            label: Text(c.label),
            onPressed: () {/* future: navigate to tips */},
          );
        },
      ),
    );
  }
}

class _Sug {
  final String label;
  final IconData icon;
  const _Sug(this.label, this.icon);
}
