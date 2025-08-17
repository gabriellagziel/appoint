import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/create_meeting_state.dart';
import '../providers.dart';

class InfoStep extends ConsumerWidget {
  const InfoStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(REDACTED_TOKEN);
    final ctrl = ref.read(REDACTED_TOKEN.notifier);
    final titleCtrl = TextEditingController(text: state.title);
    final descCtrl = TextEditingController(text: state.description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What kind of meeting do you want to set up?',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _TypeGrid(
          current: state.type,
          onSelect: ctrl.setType,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: descCtrl,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ctrl.setInfo(title: titleCtrl.text, description: descCtrl.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _TypeGrid extends StatelessWidget {
  const _TypeGrid({required this.current, required this.onSelect});
  final MeetingType? current;
  final void Function(MeetingType) onSelect;

  @override
  Widget build(BuildContext context) {
    const options = <_TypeCardData>[
      _TypeCardData('One-on-One', Icons.person, MeetingType.oneOnOne),
      _TypeCardData('Group / Event', Icons.groups, MeetingType.group),
      _TypeCardData('Virtual Call', Icons.video_call, MeetingType.personal),
      _TypeCardData('Business', Icons.business, MeetingType.business),
      _TypeCardData('Playtime', Icons.sports_esports, MeetingType.playtime),
      _TypeCardData('Open Call', Icons.campaign, MeetingType.openCall),
    ];
    return LayoutBuilder(builder: (context, c) {
      final isWide = c.maxWidth > 600;
      final cross = isWide ? 3 : 2;
      return GridView.count(
        crossAxisCount: cross,
        shrinkWrap: true,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.6,
        children: options.map((o) {
          final selected = current == o.type;
          return InkWell(
            onTap: () => onSelect(o.type),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                ),
                color: selected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.06)
                    : null,
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(o.icon),
                  const SizedBox(width: 8),
                  Expanded(child: Text(o.label)),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _TypeCardData {
  final String label;
  final IconData icon;
  final MeetingType type;
  const _TypeCardData(this.label, this.icon, this.type);
}
