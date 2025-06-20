import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_session.freezed.dart';
part 'playtime_session.g.dart';

@freezed
class PlaytimeSession with _$PlaytimeSession {
  const factory PlaytimeSession({
    required String id,
    required String gameId,
    required List<String> participants,
    required DateTime scheduledTime,
    required String mode, // virtual/live
    required String backgroundId,
  }) = _PlaytimeSession;

  factory PlaytimeSession.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeSessionFromJson(json);
}
