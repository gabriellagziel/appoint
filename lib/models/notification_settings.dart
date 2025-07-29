class NotificationSettings {
  NotificationSettings({required this.push});

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        push: json['push'] ?? false,
      );
  final bool push;

  Map<String, dynamic> toJson() => {
        'push': push,
      };
}
