import 'package:flutter/material.dart';

class MeetingHeader extends StatelessWidget {
  final Map<String, dynamic> meeting;
  const MeetingHeader({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    final title = meeting['title'] ?? 'Untitled';
    final when = meeting['startsAt']; // Timestamp
    final isVirtual = meeting['isVirtual'] == true;
    final virtualUrl = meeting['virtualUrl'];
    final location = meeting['location'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 8,
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (when != null) Text(when.toDate().toString()),
            if (isVirtual && virtualUrl != null)
              TextButton(
                  onPressed: () {/* launch URL */}, child: const Text('Join')),
            if (!isVirtual && location != null)
              TextButton(
                  onPressed: () {/* open OSS map deeplink */},
                  child: const Text('Go')),
          ],
        ),
      ),
    );
  }
}
