// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playtime_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaytimeSessionImpl _$$PlaytimeSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaytimeSessionImpl(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      mode: json['mode'] as String,
      backgroundId: json['backgroundId'] as String,
    );

Map<String, dynamic> _$$PlaytimeSessionImplToJson(
        _$PlaytimeSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'participants': instance.participants,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'mode': instance.mode,
      'backgroundId': instance.backgroundId,
    };
