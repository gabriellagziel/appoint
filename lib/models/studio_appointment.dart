class StudioAppointment {
  StudioAppointment({
    required this.id,
    required this.title,
    required this.time,
    required this.client,
    this.notes,
  });

  factory StudioAppointment.fromJson(Map<String, dynamic> json) =>
      StudioAppointment(
        id: json['id'] as String,
        title: json['title'] as String,
        time: DateTime.parse(json['time'] as String),
        client: json['client'] as String,
        notes: json['notes'] as String?,
      );
  final String id;
  final String title;
  final DateTime time;
  final String client;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time.toIso8601String(),
        'client': client,
        'notes': notes,
      };

  StudioAppointment copyWith({
    final String? id,
    final String? title,
    final DateTime? time,
    final String? client,
    final String? notes,
  }) =>
      StudioAppointment(
        id: id ?? this.id,
        title: title ?? this.title,
        time: time ?? this.time,
        client: client ?? this.client,
        notes: notes ?? this.notes,
      );
}
