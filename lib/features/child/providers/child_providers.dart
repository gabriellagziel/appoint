import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Basic profile information shown on the child dashboard.
class ChildInfo {

  ChildInfo({required this.nickname, required this.avatarUrl});
  final String nickname;
  final String avatarUrl;

  ChildInfo copyWith({String? nickname, final String? avatarUrl}) => ChildInfo(
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
}

/// Fake provider with placeholder child profile data.
final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(
    nickname: 'PlayerOne',
    avatarUrl: 'https://via.placeholder.com/150',
  ),);

/// Parental control settings managed via a StateNotifier.
class ChildSettings {

  ChildSettings({
    required this.playtimeEnabled,
    required this.notificationsEnabled,
    required this.contentFilterEnabled,
  });
  final bool playtimeEnabled;
  final bool notificationsEnabled;
  final bool contentFilterEnabled;

  ChildSettings copyWith({
    final bool? playtimeEnabled,
    final bool? notificationsEnabled,
    final bool? contentFilterEnabled,
  }) => ChildSettings(
      playtimeEnabled: playtimeEnabled ?? this.playtimeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      contentFilterEnabled: contentFilterEnabled ?? this.contentFilterEnabled,
    );
}

class ChildSettingsNotifier extends StateNotifier<ChildSettings> {
  ChildSettingsNotifier()
      : super(ChildSettings(
          playtimeEnabled: true,
          notificationsEnabled: true,
          contentFilterEnabled: true,
        ),);

  void togglePlaytime(bool value) {
    final state = state.copyWith(playtimeEnabled: value);
  }

  void toggleNotifications(bool value) {
    final state = state.copyWith(notificationsEnabled: value);
  }

  void toggleContentFilter(bool value) {
    final state = state.copyWith(contentFilterEnabled: value);
  }
}

/// Provider exposing the current parental control settings.
final childSettingsProvider =
    StateNotifierProvider<ChildSettingsNotifier, ChildSettings>((ref) => ChildSettingsNotifier());
