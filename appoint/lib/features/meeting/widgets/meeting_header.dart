import 'package:flutter/material.dart';
import '../../../services/navigation/meeting_links.dart';

class MeetingHeader extends StatelessWidget {
  final Map<String, dynamic> meeting;
  const MeetingHeader({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    final title = meeting['title'] ?? 'Untitled';
    final rawStart = meeting['start'] ?? meeting['startsAt'];
    DateTime? startTime;
    if (rawStart is String) startTime = DateTime.tryParse(rawStart);
    if (rawStart is DateTime) startTime = rawStart;
    try {
      // Firestore Timestamp support when mapped as dynamic
      // ignore: unnecessary_cast
      final ts = rawStart as dynamic;
      if (startTime == null && ts?.toDate != null) {
        startTime = ts.toDate() as DateTime;
      }
    } catch (_) {}

    final isVirtualExplicit = meeting['isVirtual'] == true;
    final virtualUrl = meeting['virtualUrl'];
    final loc = meeting['location'];
    final lat = (loc is Map<String, dynamic> ? loc['lat'] : meeting['lat']);
    final lng = (loc is Map<String, dynamic> ? loc['lng'] : meeting['lng']);
    final locLabel =
        (loc is Map<String, dynamic> ? loc['address'] : meeting['location']);
    final isVirtual = isVirtualExplicit ||
        (virtualUrl != null && (virtualUrl as String).isNotEmpty);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 8,
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (startTime != null) Text(startTime.toString()),
            if (isVirtual && virtualUrl != null)
              TextButton(
                onPressed: () => openVirtualUrl(virtualUrl),
                child: const Text('Join'),
              ),
            if (!isVirtual && lat != null && lng != null)
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () =>
                        openMapFrrm(lat: lat, lng: lng, label: locLabel),
                    child: const Text('Go'),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        openMapGoogle(lat: lat, lng: lng, label: locLabel),
                    child: const Text('Open in Google Maps'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
