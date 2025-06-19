class NotificationSettings {
  final bool push;
  final bool email;

  NotificationSettings({required this.push, required this.email});

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      push: json['push'] ?? false,
      email: json['email'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'push': push,
        'email': email,
      };
}
