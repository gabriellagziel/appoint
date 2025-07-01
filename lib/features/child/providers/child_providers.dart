import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Basic profile information shown on the child dashboard.
class ChildInfo {
  final String nickname;
  final String avatarUrl;

  ChildInfo({required this.nickname, required this.avatarUrl});

  ChildInfo copyWith({final String? nickname, final String? avatarUrl}) {
    return ChildInfo(
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

/// Fake provider with placeholder child profile data.
final childInfoProvider = StateProvider<ChildInfo>((final ref) {
  return ChildInfo(
    nickname: 'PlayerOne',
    avatarUrl: 'https://via.placeholder.com/150',
  );
});

/// Parental control settings managed via a StateNotifier.
class ChildSettings {
  final bool playtimeEnabled;
  final bool notificationsEnabled;
  final bool contentFilterEnabled;

  ChildSettings({
    required this.playtimeEnabled,
    required this.notificationsEnabled,
    required this.contentFilterEnabled,
  });

  ChildSettings copyWith({
    final bool? playtimeEnabled,
    final bool? notificationsEnabled,
    final bool? contentFilterEnabled,
  }) {
    return ChildSettings(
      playtimeEnabled: playtimeEnabled ?? this.playtimeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      contentFilterEnabled: contentFilterEnabled ?? this.contentFilterEnabled,
    );
  }
}

class ChildSettingsNotifier extends StateNotifier<ChildSettings> {
  ChildSettingsNotifier()
      : super(ChildSettings(
          playtimeEnabled: true,
          notificationsEnabled: true,
          contentFilterEnabled: true,
        ));

  void togglePlaytime(final bool value) {
    state = state.copyWith(playtimeEnabled: value);
  }

  void toggleNotifications(final bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleContentFilter(final bool value) {
    state = state.copyWith(contentFilterEnabled: value);
  }
}

/// Provider exposing the current parental control settings.
final childSettingsProvider =
    StateNotifierProvider<ChildSettingsNotifier, ChildSettings>((final ref) {
  return ChildSettingsNotifier();
});
