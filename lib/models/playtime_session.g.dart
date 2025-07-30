// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playtime_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaytimeSessionImpl _$$PlaytimeSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaytimeSessionImpl(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      mode: json['mode'] as String,
      backgroundId: json['background_id'] as String,
    );

Map<String, dynamic> _$$PlaytimeSessionImplToJson(
        _$PlaytimeSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'game_id': instance.gameId,
      'participants': instance.participants,
      'scheduled_time': instance.scheduledTime.toIso8601String(),
      'mode': instance.mode,
      'background_id': instance.backgroundId,
    };
