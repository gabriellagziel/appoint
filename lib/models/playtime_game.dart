import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_game.freezed.dart';
part 'playtime_game.g.dart';

@freezed
class PlaytimeGame with _$PlaytimeGame {
  const factory PlaytimeGame({
    required String id,
    required String name,
    required String createdBy,
    required String status, // pending, approved, rejected
    DateTime? createdAt,
  }) = _PlaytimeGame;

  factory PlaytimeGame.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeGameFromJson(json);
}
