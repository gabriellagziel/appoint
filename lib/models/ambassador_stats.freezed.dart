// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ambassador_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

AmbassadorStats _$AmbassadorStatsFromJson(Map<String, dynamic> json) {
  return _AmbassadorStats.fromJson(json);
}

/// @nodoc
mixin _$AmbassadorStats {
  String get country => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  int get ambassadors => throw _privateConstructorUsedError;
  int get referrals => throw _privateConstructorUsedError;
  double get surveyScore => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String country, String language, int ambassadors,
            int referrals, double surveyScore, DateTime date)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String country, String language, int ambassadors,
            int referrals, double surveyScore, DateTime date)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String country, String language, int ambassadors,
            int referrals, double surveyScore, DateTime date)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AmbassadorStatsCopyWith<AmbassadorStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmbassadorStatsCopyWith<$Res> {
  factory $AmbassadorStatsCopyWith(
          AmbassadorStats value, $Res Function(AmbassadorStats) then) =
      _$AmbassadorStatsCopyWithImpl<$Res, AmbassadorStats>;
  @useResult
  $Res call(
      {String country,
      String language,
      int ambassadors,
      int referrals,
      double surveyScore,
      DateTime date});
}

/// @nodoc
class _$AmbassadorStatsCopyWithImpl<$Res, $Val extends AmbassadorStats>
    implements $AmbassadorStatsCopyWith<$Res> {
  _$AmbassadorStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = null,
    Object? language = null,
    Object? ambassadors = null,
    Object? referrals = null,
    Object? surveyScore = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      ambassadors: null == ambassadors
          ? _value.ambassadors
          : ambassadors // ignore: cast_nullable_to_non_nullable
              as int,
      referrals: null == referrals
          ? _value.referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as int,
      surveyScore: null == surveyScore
          ? _value.surveyScore
          : surveyScore // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AmbassadorStatsImplCopyWith<$Res>
    implements $AmbassadorStatsCopyWith<$Res> {
  factory _$$AmbassadorStatsImplCopyWith(_$AmbassadorStatsImpl value,
          $Res Function(_$AmbassadorStatsImpl) then) =
      __$$AmbassadorStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String country,
      String language,
      int ambassadors,
      int referrals,
      double surveyScore,
      DateTime date});
}

/// @nodoc
class __$$AmbassadorStatsImplCopyWithImpl<$Res>
    extends _$AmbassadorStatsCopyWithImpl<$Res, _$AmbassadorStatsImpl>
    implements _$$AmbassadorStatsImplCopyWith<$Res> {
  __$$AmbassadorStatsImplCopyWithImpl(
      _$AmbassadorStatsImpl _value, $Res Function(_$AmbassadorStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = null,
    Object? language = null,
    Object? ambassadors = null,
    Object? referrals = null,
    Object? surveyScore = null,
    Object? date = null,
  }) {
    return _then(_$AmbassadorStatsImpl(
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      ambassadors: null == ambassadors
          ? _value.ambassadors
          : ambassadors // ignore: cast_nullable_to_non_nullable
              as int,
      referrals: null == referrals
          ? _value.referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as int,
      surveyScore: null == surveyScore
          ? _value.surveyScore
          : surveyScore // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AmbassadorStatsImpl implements _AmbassadorStats {
  const _$AmbassadorStatsImpl(
      {required this.country,
      required this.language,
      required this.ambassadors,
      required this.referrals,
      required this.surveyScore,
      required this.date});

  factory _$AmbassadorStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AmbassadorStatsImplFromJson(json);

  @override
  final String country;
  @override
  final String language;
  @override
  final int ambassadors;
  @override
  final int referrals;
  @override
  final double surveyScore;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'AmbassadorStats(country: $country, language: $language, ambassadors: $ambassadors, referrals: $referrals, surveyScore: $surveyScore, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmbassadorStatsImpl &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.ambassadors, ambassadors) ||
                other.ambassadors == ambassadors) &&
            (identical(other.referrals, referrals) ||
                other.referrals == referrals) &&
            (identical(other.surveyScore, surveyScore) ||
                other.surveyScore == surveyScore) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, country, language, ambassadors,
      referrals, surveyScore, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AmbassadorStatsImplCopyWith<_$AmbassadorStatsImpl> get copyWith =>
      __$$AmbassadorStatsImplCopyWithImpl<_$AmbassadorStatsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String country, String language, int ambassadors,
            int referrals, double surveyScore, DateTime date)
        $default,
  ) {
    return $default(
        country, language, ambassadors, referrals, surveyScore, date);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String country, String language, int ambassadors,
            int referrals, double surveyScore, DateTime date)?
        $default,
  ) {
    return $default?.call(
        country, language, ambassadors, referrals, surveyScore, date);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String country, String language, int ambassadors,
            int referrals, double surveyScore, DateTime date)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          country, language, ambassadors, referrals, surveyScore, date);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AmbassadorStatsImplToJson(
      this,
    );
  }
}

abstract class _AmbassadorStats implements AmbassadorStats {
  const factory _AmbassadorStats(
      {required final String country,
      required final String language,
      required final int ambassadors,
      required final int referrals,
      required final double surveyScore,
      required final DateTime date}) = _$AmbassadorStatsImpl;

  factory _AmbassadorStats.fromJson(Map<String, dynamic> json) =
      _$AmbassadorStatsImpl.fromJson;

  @override
  String get country;
  @override
  String get language;
  @override
  int get ambassadors;
  @override
  int get referrals;
  @override
  double get surveyScore;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$$AmbassadorStatsImplCopyWith<_$AmbassadorStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AmbassadorData {
  List<AmbassadorStats> get stats => throw _privateConstructorUsedError;
  List<ChartDataPoint> get chartData => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<AmbassadorStats> stats, List<ChartDataPoint> chartData)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<AmbassadorStats> stats, List<ChartDataPoint> chartData)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<AmbassadorStats> stats, List<ChartDataPoint> chartData)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AmbassadorDataCopyWith<AmbassadorData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmbassadorDataCopyWith<$Res> {
  factory $AmbassadorDataCopyWith(
          AmbassadorData value, $Res Function(AmbassadorData) then) =
      _$AmbassadorDataCopyWithImpl<$Res, AmbassadorData>;
  @useResult
  $Res call({List<AmbassadorStats> stats, List<ChartDataPoint> chartData});
}

/// @nodoc
class _$AmbassadorDataCopyWithImpl<$Res, $Val extends AmbassadorData>
    implements $AmbassadorDataCopyWith<$Res> {
  _$AmbassadorDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? chartData = null,
  }) {
    return _then(_value.copyWith(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<AmbassadorStats>,
      chartData: null == chartData
          ? _value.chartData
          : chartData // ignore: cast_nullable_to_non_nullable
              as List<ChartDataPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AmbassadorDataImplCopyWith<$Res>
    implements $AmbassadorDataCopyWith<$Res> {
  factory _$$AmbassadorDataImplCopyWith(_$AmbassadorDataImpl value,
          $Res Function(_$AmbassadorDataImpl) then) =
      __$$AmbassadorDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AmbassadorStats> stats, List<ChartDataPoint> chartData});
}

/// @nodoc
class __$$AmbassadorDataImplCopyWithImpl<$Res>
    extends _$AmbassadorDataCopyWithImpl<$Res, _$AmbassadorDataImpl>
    implements _$$AmbassadorDataImplCopyWith<$Res> {
  __$$AmbassadorDataImplCopyWithImpl(
      _$AmbassadorDataImpl _value, $Res Function(_$AmbassadorDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? chartData = null,
  }) {
    return _then(_$AmbassadorDataImpl(
      stats: null == stats
          ? _value._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<AmbassadorStats>,
      chartData: null == chartData
          ? _value._chartData
          : chartData // ignore: cast_nullable_to_non_nullable
              as List<ChartDataPoint>,
    ));
  }
}

/// @nodoc

class _$AmbassadorDataImpl implements _AmbassadorData {
  const _$AmbassadorDataImpl(
      {required final List<AmbassadorStats> stats,
      required final List<ChartDataPoint> chartData})
      : _stats = stats,
        _chartData = chartData;

  final List<AmbassadorStats> _stats;
  @override
  List<AmbassadorStats> get stats {
    if (_stats is EqualUnmodifiableListView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stats);
  }

  final List<ChartDataPoint> _chartData;
  @override
  List<ChartDataPoint> get chartData {
    if (_chartData is EqualUnmodifiableListView) return _chartData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chartData);
  }

  @override
  String toString() {
    return 'AmbassadorData(stats: $stats, chartData: $chartData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmbassadorDataImpl &&
            const DeepCollectionEquality().equals(other._stats, _stats) &&
            const DeepCollectionEquality()
                .equals(other._chartData, _chartData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stats),
      const DeepCollectionEquality().hash(_chartData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AmbassadorDataImplCopyWith<_$AmbassadorDataImpl> get copyWith =>
      __$$AmbassadorDataImplCopyWithImpl<_$AmbassadorDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<AmbassadorStats> stats, List<ChartDataPoint> chartData)
        $default,
  ) {
    return $default(stats, chartData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<AmbassadorStats> stats, List<ChartDataPoint> chartData)?
        $default,
  ) {
    return $default?.call(stats, chartData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<AmbassadorStats> stats, List<ChartDataPoint> chartData)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(stats, chartData);
    }
    return orElse();
  }
}

abstract class _AmbassadorData implements AmbassadorData {
  const factory _AmbassadorData(
      {required final List<AmbassadorStats> stats,
      required final List<ChartDataPoint> chartData}) = _$AmbassadorDataImpl;

  @override
  List<AmbassadorStats> get stats;
  @override
  List<ChartDataPoint> get chartData;
  @override
  @JsonKey(ignore: true)
  _$$AmbassadorDataImplCopyWith<_$AmbassadorDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChartDataPoint {
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String label, double value, String category) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String label, double value, String category)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String label, double value, String category)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChartDataPointCopyWith<ChartDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartDataPointCopyWith<$Res> {
  factory $ChartDataPointCopyWith(
          ChartDataPoint value, $Res Function(ChartDataPoint) then) =
      _$ChartDataPointCopyWithImpl<$Res, ChartDataPoint>;
  @useResult
  $Res call({String label, double value, String category});
}

/// @nodoc
class _$ChartDataPointCopyWithImpl<$Res, $Val extends ChartDataPoint>
    implements $ChartDataPointCopyWith<$Res> {
  _$ChartDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartDataPointImplCopyWith<$Res>
    implements $ChartDataPointCopyWith<$Res> {
  factory _$$ChartDataPointImplCopyWith(_$ChartDataPointImpl value,
          $Res Function(_$ChartDataPointImpl) then) =
      __$$ChartDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value, String category});
}

/// @nodoc
class __$$ChartDataPointImplCopyWithImpl<$Res>
    extends _$ChartDataPointCopyWithImpl<$Res, _$ChartDataPointImpl>
    implements _$$ChartDataPointImplCopyWith<$Res> {
  __$$ChartDataPointImplCopyWithImpl(
      _$ChartDataPointImpl _value, $Res Function(_$ChartDataPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? category = null,
  }) {
    return _then(_$ChartDataPointImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChartDataPointImpl implements _ChartDataPoint {
  const _$ChartDataPointImpl(
      {required this.label, required this.value, required this.category});

  @override
  final String label;
  @override
  final double value;
  @override
  final String category;

  @override
  String toString() {
    return 'ChartDataPoint(label: $label, value: $value, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartDataPointImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, value, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartDataPointImplCopyWith<_$ChartDataPointImpl> get copyWith =>
      __$$ChartDataPointImplCopyWithImpl<_$ChartDataPointImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String label, double value, String category) $default,
  ) {
    return $default(label, value, category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String label, double value, String category)? $default,
  ) {
    return $default?.call(label, value, category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String label, double value, String category)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(label, value, category);
    }
    return orElse();
  }
}

abstract class _ChartDataPoint implements ChartDataPoint {
  const factory _ChartDataPoint(
      {required final String label,
      required final double value,
      required final String category}) = _$ChartDataPointImpl;

  @override
  String get label;
  @override
  double get value;
  @override
  String get category;
  @override
  @JsonKey(ignore: true)
  _$$ChartDataPointImplCopyWith<_$ChartDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
