class UserSettings {
  final int defaultSnoozeMinutes;
  const UserSettings({this.defaultSnoozeMinutes = 15});

  factory UserSettings.fromMap(Map<String, dynamic>? m) {
    final raw = m == null ? null : m['defaultSnoozeMinutes'];
    final value = raw is int ? raw : 15;
    return UserSettings(defaultSnoozeMinutes: value);
  }

  Map<String, dynamic> toMap() => {
        'defaultSnoozeMinutes': defaultSnoozeMinutes,
      };
}
