import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_background.freezed.dart';
part 'playtime_background.g.dart';

@freezed
class PlaytimeBackground with _$PlaytimeBackground {
  const factory PlaytimeBackground({
    required final String id,
    required final String imageUrl,
    required final String createdBy,
  }) = _PlaytimeBackground;

  factory PlaytimeBackground.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeBackgroundFromJson(json);
}
