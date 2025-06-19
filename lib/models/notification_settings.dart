class NotificationSettings {
  final bool push;

  NotificationSettings({required this.push});

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        push: json['push'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'push': push,
      };
}
