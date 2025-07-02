import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/playtime_background.freezed.dart';
part '../generated/models/playtime_background.g.dart';

@freezed
class PlaytimeBackground with _$PlaytimeBackground {
  const factory PlaytimeBackground({
    required final String id,
    required final String imageUrl,
    required final String createdBy,
  }) = _PlaytimeBackground;

  factory PlaytimeBackground.fromJson(final Map<String, dynamic> json) =>
      _$PlaytimeBackgroundFromJson(json);
}
