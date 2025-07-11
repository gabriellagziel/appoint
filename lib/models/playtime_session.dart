import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_session.freezed.dart';
part 'playtime_session.g.dart';

@freezed
class PlaytimeSession with _$PlaytimeSession {
  const factory PlaytimeSession({
    required final String id,
    required final String gameId,
    required final List<String> participants,
    required final DateTime scheduledTime,
    required final String mode, // virtual/live
    required final String backgroundId,
  }) = _PlaytimeSession;

  factory PlaytimeSession.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeSessionFromJson(json);
}
