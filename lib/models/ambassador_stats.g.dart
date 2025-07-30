// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambassador_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AmbassadorStatsImpl _$$AmbassadorStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$AmbassadorStatsImpl(
      country: json['country'] as String,
      language: json['language'] as String,
      ambassadors: (json['ambassadors'] as num).toInt(),
      referrals: (json['referrals'] as num).toInt(),
      surveyScore: (json['survey_score'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$AmbassadorStatsImplToJson(
        _$AmbassadorStatsImpl instance) =>
    <String, dynamic>{
      'country': instance.country,
      'language': instance.language,
      'ambassadors': instance.ambassadors,
      'referrals': instance.referrals,
      'survey_score': instance.surveyScore,
      'date': instance.date.toIso8601String(),
    };
