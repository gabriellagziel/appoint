import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_game.freezed.dart';
part 'playtime_game.g.dart';

@freezed
class PlaytimeGame with _$PlaytimeGame {
  const factory PlaytimeGame({
    required final String id,
    required final String name,
    required final String createdBy,
    required final String status, // pending, approved, rejected
    final DateTime? createdAt,
  }) = _PlaytimeGame;

  factory PlaytimeGame.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeGameFromJson(json);
}
