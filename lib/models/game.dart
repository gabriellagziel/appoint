import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required final String id,
    required final String title,
    required final String description,
    required final String imageUrl,
    required final int minAge,
    required final int maxAge,
    required final List<String> categories,
    required final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
