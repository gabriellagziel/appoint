class NotificationPayload {
  NotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    this.data,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      NotificationPayload(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        data: json['data'] as Map<String, dynamic>?,
      );
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
}
