class AgendaItem {
  final String id;
  final String title;
  final DateTime time;
  final AgendaItemType type;
  final Map<String, dynamic>? metadata;

  const AgendaItem({
    required this.id,
    required this.title,
    required this.time,
    required this.type,
    this.metadata,
  });

  bool get isMeeting => type == AgendaItemType.meeting;
  bool get isReminder => type == AgendaItemType.reminder;

  factory AgendaItem.fromMap(Map<String, dynamic> data) {
    return AgendaItem(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      time:
          data['time'] != null ? DateTime.parse(data['time']) : DateTime.now(),
      type: AgendaItemType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => AgendaItemType.meeting,
      ),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'type': type.name,
      'metadata': metadata,
    };
  }
}

enum AgendaItemType {
  meeting,
  reminder,
}
