// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ambassador_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AmbassadorProfile _$AmbassadorProfileFromJson(Map<String, dynamic> json) {
  return _AmbassadorProfile.fromJson(json);
}

/// @nodoc
mixin _$AmbassadorProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  AmbassadorStatus get status => throw _privateConstructorUsedError;
  AmbassadorTier get tier => throw _privateConstructorUsedError;
  DateTime get assignedAt => throw _privateConstructorUsedError;
  DateTime get lastActivityDate => throw _privateConstructorUsedError;
  int get totalReferrals => throw _privateConstructorUsedError;
  int get activeReferrals => throw _privateConstructorUsedError;
  int get monthlyReferrals => throw _privateConstructorUsedError;
  DateTime get lastMonthlyResetAt => throw _privateConstructorUsedError;
  List<AmbassadorReward> get earnedRewards =>
      throw _privateConstructorUsedError;
  AmbassadorMetrics get metrics => throw _privateConstructorUsedError;
  String? get shareLink => throw _privateConstructorUsedError;
  String? get qrCodeUrl => throw _privateConstructorUsedError;
  DateTime? get statusChangedAt => throw _privateConstructorUsedError;
  DateTime? get tierChangedAt => throw _privateConstructorUsedError;
  DateTime? get lastNotificationSentAt => throw _privateConstructorUsedError;
  DateTime? get nextMonthlyReviewAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customData => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String countryCode,
            String languageCode,
            AmbassadorStatus status,
            AmbassadorTier tier,
            DateTime assignedAt,
            DateTime lastActivityDate,
            int totalReferrals,
            int activeReferrals,
            int monthlyReferrals,
            DateTime lastMonthlyResetAt,
            List<AmbassadorReward> earnedRewards,
            AmbassadorMetrics metrics,
            String? shareLink,
            String? qrCodeUrl,
            DateTime? statusChangedAt,
            DateTime? tierChangedAt,
            DateTime? lastNotificationSentAt,
            DateTime? nextMonthlyReviewAt,
            Map<String, dynamic>? customData)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String userId,
            String countryCode,
            String languageCode,
            AmbassadorStatus status,
            AmbassadorTier tier,
            DateTime assignedAt,
            DateTime lastActivityDate,
            int totalReferrals,
            int activeReferrals,
            int monthlyReferrals,
            DateTime lastMonthlyResetAt,
            List<AmbassadorReward> earnedRewards,
            AmbassadorMetrics metrics,
            String? shareLink,
            String? qrCodeUrl,
            DateTime? statusChangedAt,
            DateTime? tierChangedAt,
            DateTime? lastNotificationSentAt,
            DateTime? nextMonthlyReviewAt,
            Map<String, dynamic>? customData)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String countryCode,
            String languageCode,
            AmbassadorStatus status,
            AmbassadorTier tier,
            DateTime assignedAt,
            DateTime lastActivityDate,
            int totalReferrals,
            int activeReferrals,
            int monthlyReferrals,
            DateTime lastMonthlyResetAt,
            List<AmbassadorReward> earnedRewards,
            AmbassadorMetrics metrics,
            String? shareLink,
            String? qrCodeUrl,
            DateTime? statusChangedAt,
            DateTime? tierChangedAt,
            DateTime? lastNotificationSentAt,
            DateTime? nextMonthlyReviewAt,
            Map<String, dynamic>? customData)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AmbassadorProfileCopyWith<AmbassadorProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmbassadorProfileCopyWith<$Res> {
  factory $AmbassadorProfileCopyWith(
          AmbassadorProfile value, $Res Function(AmbassadorProfile) then) =
      _$AmbassadorProfileCopyWithImpl<$Res, AmbassadorProfile>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String countryCode,
      String languageCode,
      AmbassadorStatus status,
      AmbassadorTier tier,
      DateTime assignedAt,
      DateTime lastActivityDate,
      int totalReferrals,
      int activeReferrals,
      int monthlyReferrals,
      DateTime lastMonthlyResetAt,
      List<AmbassadorReward> earnedRewards,
      AmbassadorMetrics metrics,
      String? shareLink,
      String? qrCodeUrl,
      DateTime? statusChangedAt,
      DateTime? tierChangedAt,
      DateTime? lastNotificationSentAt,
      DateTime? nextMonthlyReviewAt,
      Map<String, dynamic>? customData});

  $AmbassadorMetricsCopyWith<$Res> get metrics;
}

/// @nodoc
class _$AmbassadorProfileCopyWithImpl<$Res, $Val extends AmbassadorProfile>
    implements $AmbassadorProfileCopyWith<$Res> {
  _$AmbassadorProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? countryCode = null,
    Object? languageCode = null,
    Object? status = null,
    Object? tier = null,
    Object? assignedAt = null,
    Object? lastActivityDate = null,
    Object? totalReferrals = null,
    Object? activeReferrals = null,
    Object? monthlyReferrals = null,
    Object? lastMonthlyResetAt = null,
    Object? earnedRewards = null,
    Object? metrics = null,
    Object? shareLink = freezed,
    Object? qrCodeUrl = freezed,
    Object? statusChangedAt = freezed,
    Object? tierChangedAt = freezed,
    Object? lastNotificationSentAt = freezed,
    Object? nextMonthlyReviewAt = freezed,
    Object? customData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AmbassadorStatus,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AmbassadorTier,
      assignedAt: null == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityDate: null == lastActivityDate
          ? _value.lastActivityDate
          : lastActivityDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      activeReferrals: null == activeReferrals
          ? _value.activeReferrals
          : activeReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyReferrals: null == monthlyReferrals
          ? _value.monthlyReferrals
          : monthlyReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      lastMonthlyResetAt: null == lastMonthlyResetAt
          ? _value.lastMonthlyResetAt
          : lastMonthlyResetAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      earnedRewards: null == earnedRewards
          ? _value.earnedRewards
          : earnedRewards // ignore: cast_nullable_to_non_nullable
              as List<AmbassadorReward>,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as AmbassadorMetrics,
      shareLink: freezed == shareLink
          ? _value.shareLink
          : shareLink // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      statusChangedAt: freezed == statusChangedAt
          ? _value.statusChangedAt
          : statusChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tierChangedAt: freezed == tierChangedAt
          ? _value.tierChangedAt
          : tierChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastNotificationSentAt: freezed == lastNotificationSentAt
          ? _value.lastNotificationSentAt
          : lastNotificationSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextMonthlyReviewAt: freezed == nextMonthlyReviewAt
          ? _value.nextMonthlyReviewAt
          : nextMonthlyReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customData: freezed == customData
          ? _value.customData
          : customData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AmbassadorMetricsCopyWith<$Res> get metrics {
    return $AmbassadorMetricsCopyWith<$Res>(_value.metrics, (value) {
      return _then(_value.copyWith(metrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AmbassadorProfileImplCopyWith<$Res>
    implements $AmbassadorProfileCopyWith<$Res> {
  factory _$$AmbassadorProfileImplCopyWith(_$AmbassadorProfileImpl value,
          $Res Function(_$AmbassadorProfileImpl) then) =
      __$$AmbassadorProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String countryCode,
      String languageCode,
      AmbassadorStatus status,
      AmbassadorTier tier,
      DateTime assignedAt,
      DateTime lastActivityDate,
      int totalReferrals,
      int activeReferrals,
      int monthlyReferrals,
      DateTime lastMonthlyResetAt,
      List<AmbassadorReward> earnedRewards,
      AmbassadorMetrics metrics,
      String? shareLink,
      String? qrCodeUrl,
      DateTime? statusChangedAt,
      DateTime? tierChangedAt,
      DateTime? lastNotificationSentAt,
      DateTime? nextMonthlyReviewAt,
      Map<String, dynamic>? customData});

  @override
  $AmbassadorMetricsCopyWith<$Res> get metrics;
}

/// @nodoc
class __$$AmbassadorProfileImplCopyWithImpl<$Res>
    extends _$AmbassadorProfileCopyWithImpl<$Res, _$AmbassadorProfileImpl>
    implements _$$AmbassadorProfileImplCopyWith<$Res> {
  __$$AmbassadorProfileImplCopyWithImpl(_$AmbassadorProfileImpl _value,
      $Res Function(_$AmbassadorProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? countryCode = null,
    Object? languageCode = null,
    Object? status = null,
    Object? tier = null,
    Object? assignedAt = null,
    Object? lastActivityDate = null,
    Object? totalReferrals = null,
    Object? activeReferrals = null,
    Object? monthlyReferrals = null,
    Object? lastMonthlyResetAt = null,
    Object? earnedRewards = null,
    Object? metrics = null,
    Object? shareLink = freezed,
    Object? qrCodeUrl = freezed,
    Object? statusChangedAt = freezed,
    Object? tierChangedAt = freezed,
    Object? lastNotificationSentAt = freezed,
    Object? nextMonthlyReviewAt = freezed,
    Object? customData = freezed,
  }) {
    return _then(_$AmbassadorProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AmbassadorStatus,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AmbassadorTier,
      assignedAt: null == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityDate: null == lastActivityDate
          ? _value.lastActivityDate
          : lastActivityDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      activeReferrals: null == activeReferrals
          ? _value.activeReferrals
          : activeReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyReferrals: null == monthlyReferrals
          ? _value.monthlyReferrals
          : monthlyReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      lastMonthlyResetAt: null == lastMonthlyResetAt
          ? _value.lastMonthlyResetAt
          : lastMonthlyResetAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      earnedRewards: null == earnedRewards
          ? _value._earnedRewards
          : earnedRewards // ignore: cast_nullable_to_non_nullable
              as List<AmbassadorReward>,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as AmbassadorMetrics,
      shareLink: freezed == shareLink
          ? _value.shareLink
          : shareLink // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      statusChangedAt: freezed == statusChangedAt
          ? _value.statusChangedAt
          : statusChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tierChangedAt: freezed == tierChangedAt
          ? _value.tierChangedAt
          : tierChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastNotificationSentAt: freezed == lastNotificationSentAt
          ? _value.lastNotificationSentAt
          : lastNotificationSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextMonthlyReviewAt: freezed == nextMonthlyReviewAt
          ? _value.nextMonthlyReviewAt
          : nextMonthlyReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customData: freezed == customData
          ? _value._customData
          : customData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AmbassadorProfileImpl implements _AmbassadorProfile {
  const _$AmbassadorProfileImpl(
      {required this.id,
      required this.userId,
      required this.countryCode,
      required this.languageCode,
      required this.status,
      required this.tier,
      required this.assignedAt,
      required this.lastActivityDate,
      required this.totalReferrals,
      required this.activeReferrals,
      required this.monthlyReferrals,
      required this.lastMonthlyResetAt,
      required final List<AmbassadorReward> earnedRewards,
      required this.metrics,
      this.shareLink,
      this.qrCodeUrl,
      this.statusChangedAt,
      this.tierChangedAt,
      this.lastNotificationSentAt,
      this.nextMonthlyReviewAt,
      final Map<String, dynamic>? customData})
      : _earnedRewards = earnedRewards,
        _customData = customData;

  factory _$AmbassadorProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$AmbassadorProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String countryCode;
  @override
  final String languageCode;
  @override
  final AmbassadorStatus status;
  @override
  final AmbassadorTier tier;
  @override
  final DateTime assignedAt;
  @override
  final DateTime lastActivityDate;
  @override
  final int totalReferrals;
  @override
  final int activeReferrals;
  @override
  final int monthlyReferrals;
  @override
  final DateTime lastMonthlyResetAt;
  final List<AmbassadorReward> _earnedRewards;
  @override
  List<AmbassadorReward> get earnedRewards {
    if (_earnedRewards is EqualUnmodifiableListView) return _earnedRewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_earnedRewards);
  }

  @override
  final AmbassadorMetrics metrics;
  @override
  final String? shareLink;
  @override
  final String? qrCodeUrl;
  @override
  final DateTime? statusChangedAt;
  @override
  final DateTime? tierChangedAt;
  @override
  final DateTime? lastNotificationSentAt;
  @override
  final DateTime? nextMonthlyReviewAt;
  final Map<String, dynamic>? _customData;
  @override
  Map<String, dynamic>? get customData {
    final value = _customData;
    if (value == null) return null;
    if (_customData is EqualUnmodifiableMapView) return _customData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AmbassadorProfile(id: $id, userId: $userId, countryCode: $countryCode, languageCode: $languageCode, status: $status, tier: $tier, assignedAt: $assignedAt, lastActivityDate: $lastActivityDate, totalReferrals: $totalReferrals, activeReferrals: $activeReferrals, monthlyReferrals: $monthlyReferrals, lastMonthlyResetAt: $lastMonthlyResetAt, earnedRewards: $earnedRewards, metrics: $metrics, shareLink: $shareLink, qrCodeUrl: $qrCodeUrl, statusChangedAt: $statusChangedAt, tierChangedAt: $tierChangedAt, lastNotificationSentAt: $lastNotificationSentAt, nextMonthlyReviewAt: $nextMonthlyReviewAt, customData: $customData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmbassadorProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.lastActivityDate, lastActivityDate) ||
                other.lastActivityDate == lastActivityDate) &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.activeReferrals, activeReferrals) ||
                other.activeReferrals == activeReferrals) &&
            (identical(other.monthlyReferrals, monthlyReferrals) ||
                other.monthlyReferrals == monthlyReferrals) &&
            (identical(other.lastMonthlyResetAt, lastMonthlyResetAt) ||
                other.lastMonthlyResetAt == lastMonthlyResetAt) &&
            const DeepCollectionEquality()
                .equals(other._earnedRewards, _earnedRewards) &&
            (identical(other.metrics, metrics) || other.metrics == metrics) &&
            (identical(other.shareLink, shareLink) ||
                other.shareLink == shareLink) &&
            (identical(other.qrCodeUrl, qrCodeUrl) ||
                other.qrCodeUrl == qrCodeUrl) &&
            (identical(other.statusChangedAt, statusChangedAt) ||
                other.statusChangedAt == statusChangedAt) &&
            (identical(other.tierChangedAt, tierChangedAt) ||
                other.tierChangedAt == tierChangedAt) &&
            (identical(other.lastNotificationSentAt, lastNotificationSentAt) ||
                other.lastNotificationSentAt == lastNotificationSentAt) &&
            (identical(other.nextMonthlyReviewAt, nextMonthlyReviewAt) ||
                other.nextMonthlyReviewAt == nextMonthlyReviewAt) &&
            const DeepCollectionEquality()
                .equals(other._customData, _customData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        countryCode,
        languageCode,
        status,
        tier,
        assignedAt,
        lastActivityDate,
        totalReferrals,
        activeReferrals,
        monthlyReferrals,
        lastMonthlyResetAt,
        const DeepCollectionEquality().hash(_earnedRewards),
        metrics,
        shareLink,
        qrCodeUrl,
        statusChangedAt,
        tierChangedAt,
        lastNotificationSentAt,
        nextMonthlyReviewAt,
        const DeepCollectionEquality().hash(_customData)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AmbassadorProfileImplCopyWith<_$AmbassadorProfileImpl> get copyWith =>
      __$$AmbassadorProfileImplCopyWithImpl<_$AmbassadorProfileImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String countryCode,
            String languageCode,
            AmbassadorStatus status,
            AmbassadorTier tier,
            DateTime assignedAt,
            DateTime lastActivityDate,
            int totalReferrals,
            int activeReferrals,
            int monthlyReferrals,
            DateTime lastMonthlyResetAt,
            List<AmbassadorReward> earnedRewards,
            AmbassadorMetrics metrics,
            String? shareLink,
            String? qrCodeUrl,
            DateTime? statusChangedAt,
            DateTime? tierChangedAt,
            DateTime? lastNotificationSentAt,
            DateTime? nextMonthlyReviewAt,
            Map<String, dynamic>? customData)
        $default,
  ) {
    return $default(
        id,
        userId,
        countryCode,
        languageCode,
        status,
        tier,
        assignedAt,
        lastActivityDate,
        totalReferrals,
        activeReferrals,
        monthlyReferrals,
        lastMonthlyResetAt,
        earnedRewards,
        metrics,
        shareLink,
        qrCodeUrl,
        statusChangedAt,
        tierChangedAt,
        lastNotificationSentAt,
        nextMonthlyReviewAt,
        customData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String userId,
            String countryCode,
            String languageCode,
            AmbassadorStatus status,
            AmbassadorTier tier,
            DateTime assignedAt,
            DateTime lastActivityDate,
            int totalReferrals,
            int activeReferrals,
            int monthlyReferrals,
            DateTime lastMonthlyResetAt,
            List<AmbassadorReward> earnedRewards,
            AmbassadorMetrics metrics,
            String? shareLink,
            String? qrCodeUrl,
            DateTime? statusChangedAt,
            DateTime? tierChangedAt,
            DateTime? lastNotificationSentAt,
            DateTime? nextMonthlyReviewAt,
            Map<String, dynamic>? customData)?
        $default,
  ) {
    return $default?.call(
        id,
        userId,
        countryCode,
        languageCode,
        status,
        tier,
        assignedAt,
        lastActivityDate,
        totalReferrals,
        activeReferrals,
        monthlyReferrals,
        lastMonthlyResetAt,
        earnedRewards,
        metrics,
        shareLink,
        qrCodeUrl,
        statusChangedAt,
        tierChangedAt,
        lastNotificationSentAt,
        nextMonthlyReviewAt,
        customData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String userId,
            String countryCode,
            String languageCode,
            AmbassadorStatus status,
            AmbassadorTier tier,
            DateTime assignedAt,
            DateTime lastActivityDate,
            int totalReferrals,
            int activeReferrals,
            int monthlyReferrals,
            DateTime lastMonthlyResetAt,
            List<AmbassadorReward> earnedRewards,
            AmbassadorMetrics metrics,
            String? shareLink,
            String? qrCodeUrl,
            DateTime? statusChangedAt,
            DateTime? tierChangedAt,
            DateTime? lastNotificationSentAt,
            DateTime? nextMonthlyReviewAt,
            Map<String, dynamic>? customData)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          userId,
          countryCode,
          languageCode,
          status,
          tier,
          assignedAt,
          lastActivityDate,
          totalReferrals,
          activeReferrals,
          monthlyReferrals,
          lastMonthlyResetAt,
          earnedRewards,
          metrics,
          shareLink,
          qrCodeUrl,
          statusChangedAt,
          tierChangedAt,
          lastNotificationSentAt,
          nextMonthlyReviewAt,
          customData);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AmbassadorProfileImplToJson(
      this,
    );
  }
}

abstract class _AmbassadorProfile implements AmbassadorProfile {
  const factory _AmbassadorProfile(
      {required final String id,
      required final String userId,
      required final String countryCode,
      required final String languageCode,
      required final AmbassadorStatus status,
      required final AmbassadorTier tier,
      required final DateTime assignedAt,
      required final DateTime lastActivityDate,
      required final int totalReferrals,
      required final int activeReferrals,
      required final int monthlyReferrals,
      required final DateTime lastMonthlyResetAt,
      required final List<AmbassadorReward> earnedRewards,
      required final AmbassadorMetrics metrics,
      final String? shareLink,
      final String? qrCodeUrl,
      final DateTime? statusChangedAt,
      final DateTime? tierChangedAt,
      final DateTime? lastNotificationSentAt,
      final DateTime? nextMonthlyReviewAt,
      final Map<String, dynamic>? customData}) = _$AmbassadorProfileImpl;

  factory _AmbassadorProfile.fromJson(Map<String, dynamic> json) =
      _$AmbassadorProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get countryCode;
  @override
  String get languageCode;
  @override
  AmbassadorStatus get status;
  @override
  AmbassadorTier get tier;
  @override
  DateTime get assignedAt;
  @override
  DateTime get lastActivityDate;
  @override
  int get totalReferrals;
  @override
  int get activeReferrals;
  @override
  int get monthlyReferrals;
  @override
  DateTime get lastMonthlyResetAt;
  @override
  List<AmbassadorReward> get earnedRewards;
  @override
  AmbassadorMetrics get metrics;
  @override
  String? get shareLink;
  @override
  String? get qrCodeUrl;
  @override
  DateTime? get statusChangedAt;
  @override
  DateTime? get tierChangedAt;
  @override
  DateTime? get lastNotificationSentAt;
  @override
  DateTime? get nextMonthlyReviewAt;
  @override
  Map<String, dynamic>? get customData;
  @override
  @JsonKey(ignore: true)
  _$$AmbassadorProfileImplCopyWith<_$AmbassadorProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AmbassadorReward _$AmbassadorRewardFromJson(Map<String, dynamic> json) {
  return _AmbassadorReward.fromJson(json);
}

/// @nodoc
mixin _$AmbassadorReward {
  String get id => throw _privateConstructorUsedError;
  AmbassadorRewardType get type => throw _privateConstructorUsedError;
  AmbassadorTier get tier => throw _privateConstructorUsedError;
  DateTime get earnedAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            AmbassadorRewardType type,
            AmbassadorTier tier,
            DateTime earnedAt,
            DateTime expiresAt,
            bool isActive,
            String? description,
            Map<String, dynamic>? metadata)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            AmbassadorRewardType type,
            AmbassadorTier tier,
            DateTime earnedAt,
            DateTime expiresAt,
            bool isActive,
            String? description,
            Map<String, dynamic>? metadata)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            AmbassadorRewardType type,
            AmbassadorTier tier,
            DateTime earnedAt,
            DateTime expiresAt,
            bool isActive,
            String? description,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AmbassadorRewardCopyWith<AmbassadorReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmbassadorRewardCopyWith<$Res> {
  factory $AmbassadorRewardCopyWith(
          AmbassadorReward value, $Res Function(AmbassadorReward) then) =
      _$AmbassadorRewardCopyWithImpl<$Res, AmbassadorReward>;
  @useResult
  $Res call(
      {String id,
      AmbassadorRewardType type,
      AmbassadorTier tier,
      DateTime earnedAt,
      DateTime expiresAt,
      bool isActive,
      String? description,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$AmbassadorRewardCopyWithImpl<$Res, $Val extends AmbassadorReward>
    implements $AmbassadorRewardCopyWith<$Res> {
  _$AmbassadorRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? tier = null,
    Object? earnedAt = null,
    Object? expiresAt = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AmbassadorRewardType,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AmbassadorTier,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AmbassadorRewardImplCopyWith<$Res>
    implements $AmbassadorRewardCopyWith<$Res> {
  factory _$$AmbassadorRewardImplCopyWith(_$AmbassadorRewardImpl value,
          $Res Function(_$AmbassadorRewardImpl) then) =
      __$$AmbassadorRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AmbassadorRewardType type,
      AmbassadorTier tier,
      DateTime earnedAt,
      DateTime expiresAt,
      bool isActive,
      String? description,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$AmbassadorRewardImplCopyWithImpl<$Res>
    extends _$AmbassadorRewardCopyWithImpl<$Res, _$AmbassadorRewardImpl>
    implements _$$AmbassadorRewardImplCopyWith<$Res> {
  __$$AmbassadorRewardImplCopyWithImpl(_$AmbassadorRewardImpl _value,
      $Res Function(_$AmbassadorRewardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? tier = null,
    Object? earnedAt = null,
    Object? expiresAt = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$AmbassadorRewardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AmbassadorRewardType,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AmbassadorTier,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AmbassadorRewardImpl implements _AmbassadorReward {
  const _$AmbassadorRewardImpl(
      {required this.id,
      required this.type,
      required this.tier,
      required this.earnedAt,
      required this.expiresAt,
      required this.isActive,
      this.description,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$AmbassadorRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$AmbassadorRewardImplFromJson(json);

  @override
  final String id;
  @override
  final AmbassadorRewardType type;
  @override
  final AmbassadorTier tier;
  @override
  final DateTime earnedAt;
  @override
  final DateTime expiresAt;
  @override
  final bool isActive;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AmbassadorReward(id: $id, type: $type, tier: $tier, earnedAt: $earnedAt, expiresAt: $expiresAt, isActive: $isActive, description: $description, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmbassadorRewardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      tier,
      earnedAt,
      expiresAt,
      isActive,
      description,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AmbassadorRewardImplCopyWith<_$AmbassadorRewardImpl> get copyWith =>
      __$$AmbassadorRewardImplCopyWithImpl<_$AmbassadorRewardImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            AmbassadorRewardType type,
            AmbassadorTier tier,
            DateTime earnedAt,
            DateTime expiresAt,
            bool isActive,
            String? description,
            Map<String, dynamic>? metadata)
        $default,
  ) {
    return $default(
        id, type, tier, earnedAt, expiresAt, isActive, description, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            AmbassadorRewardType type,
            AmbassadorTier tier,
            DateTime earnedAt,
            DateTime expiresAt,
            bool isActive,
            String? description,
            Map<String, dynamic>? metadata)?
        $default,
  ) {
    return $default?.call(
        id, type, tier, earnedAt, expiresAt, isActive, description, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            AmbassadorRewardType type,
            AmbassadorTier tier,
            DateTime earnedAt,
            DateTime expiresAt,
            bool isActive,
            String? description,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id, type, tier, earnedAt, expiresAt, isActive, description, metadata);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AmbassadorRewardImplToJson(
      this,
    );
  }
}

abstract class _AmbassadorReward implements AmbassadorReward {
  const factory _AmbassadorReward(
      {required final String id,
      required final AmbassadorRewardType type,
      required final AmbassadorTier tier,
      required final DateTime earnedAt,
      required final DateTime expiresAt,
      required final bool isActive,
      final String? description,
      final Map<String, dynamic>? metadata}) = _$AmbassadorRewardImpl;

  factory _AmbassadorReward.fromJson(Map<String, dynamic> json) =
      _$AmbassadorRewardImpl.fromJson;

  @override
  String get id;
  @override
  AmbassadorRewardType get type;
  @override
  AmbassadorTier get tier;
  @override
  DateTime get earnedAt;
  @override
  DateTime get expiresAt;
  @override
  bool get isActive;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$AmbassadorRewardImplCopyWith<_$AmbassadorRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AmbassadorMetrics _$AmbassadorMetricsFromJson(Map<String, dynamic> json) {
  return _AmbassadorMetrics.fromJson(json);
}

/// @nodoc
mixin _$AmbassadorMetrics {
  int get conversionRate => throw _privateConstructorUsedError;
  int get averageReferralsPerMonth => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime get lastReferralDate => throw _privateConstructorUsedError;
  Map<String, int> get monthlyBreakdown => throw _privateConstructorUsedError;
  double get engagementScore => throw _privateConstructorUsedError;
  int get countryRanking => throw _privateConstructorUsedError;
  int get globalRanking => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int conversionRate,
            int averageReferralsPerMonth,
            int streakDays,
            int longestStreak,
            DateTime lastReferralDate,
            Map<String, int> monthlyBreakdown,
            double engagementScore,
            int countryRanking,
            int globalRanking)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int conversionRate,
            int averageReferralsPerMonth,
            int streakDays,
            int longestStreak,
            DateTime lastReferralDate,
            Map<String, int> monthlyBreakdown,
            double engagementScore,
            int countryRanking,
            int globalRanking)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int conversionRate,
            int averageReferralsPerMonth,
            int streakDays,
            int longestStreak,
            DateTime lastReferralDate,
            Map<String, int> monthlyBreakdown,
            double engagementScore,
            int countryRanking,
            int globalRanking)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AmbassadorMetricsCopyWith<AmbassadorMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmbassadorMetricsCopyWith<$Res> {
  factory $AmbassadorMetricsCopyWith(
          AmbassadorMetrics value, $Res Function(AmbassadorMetrics) then) =
      _$AmbassadorMetricsCopyWithImpl<$Res, AmbassadorMetrics>;
  @useResult
  $Res call(
      {int conversionRate,
      int averageReferralsPerMonth,
      int streakDays,
      int longestStreak,
      DateTime lastReferralDate,
      Map<String, int> monthlyBreakdown,
      double engagementScore,
      int countryRanking,
      int globalRanking});
}

/// @nodoc
class _$AmbassadorMetricsCopyWithImpl<$Res, $Val extends AmbassadorMetrics>
    implements $AmbassadorMetricsCopyWith<$Res> {
  _$AmbassadorMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversionRate = null,
    Object? averageReferralsPerMonth = null,
    Object? streakDays = null,
    Object? longestStreak = null,
    Object? lastReferralDate = null,
    Object? monthlyBreakdown = null,
    Object? engagementScore = null,
    Object? countryRanking = null,
    Object? globalRanking = null,
  }) {
    return _then(_value.copyWith(
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as int,
      averageReferralsPerMonth: null == averageReferralsPerMonth
          ? _value.averageReferralsPerMonth
          : averageReferralsPerMonth // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastReferralDate: null == lastReferralDate
          ? _value.lastReferralDate
          : lastReferralDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      monthlyBreakdown: null == monthlyBreakdown
          ? _value.monthlyBreakdown
          : monthlyBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      engagementScore: null == engagementScore
          ? _value.engagementScore
          : engagementScore // ignore: cast_nullable_to_non_nullable
              as double,
      countryRanking: null == countryRanking
          ? _value.countryRanking
          : countryRanking // ignore: cast_nullable_to_non_nullable
              as int,
      globalRanking: null == globalRanking
          ? _value.globalRanking
          : globalRanking // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AmbassadorMetricsImplCopyWith<$Res>
    implements $AmbassadorMetricsCopyWith<$Res> {
  factory _$$AmbassadorMetricsImplCopyWith(_$AmbassadorMetricsImpl value,
          $Res Function(_$AmbassadorMetricsImpl) then) =
      __$$AmbassadorMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int conversionRate,
      int averageReferralsPerMonth,
      int streakDays,
      int longestStreak,
      DateTime lastReferralDate,
      Map<String, int> monthlyBreakdown,
      double engagementScore,
      int countryRanking,
      int globalRanking});
}

/// @nodoc
class __$$AmbassadorMetricsImplCopyWithImpl<$Res>
    extends _$AmbassadorMetricsCopyWithImpl<$Res, _$AmbassadorMetricsImpl>
    implements _$$AmbassadorMetricsImplCopyWith<$Res> {
  __$$AmbassadorMetricsImplCopyWithImpl(_$AmbassadorMetricsImpl _value,
      $Res Function(_$AmbassadorMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversionRate = null,
    Object? averageReferralsPerMonth = null,
    Object? streakDays = null,
    Object? longestStreak = null,
    Object? lastReferralDate = null,
    Object? monthlyBreakdown = null,
    Object? engagementScore = null,
    Object? countryRanking = null,
    Object? globalRanking = null,
  }) {
    return _then(_$AmbassadorMetricsImpl(
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as int,
      averageReferralsPerMonth: null == averageReferralsPerMonth
          ? _value.averageReferralsPerMonth
          : averageReferralsPerMonth // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastReferralDate: null == lastReferralDate
          ? _value.lastReferralDate
          : lastReferralDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      monthlyBreakdown: null == monthlyBreakdown
          ? _value._monthlyBreakdown
          : monthlyBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      engagementScore: null == engagementScore
          ? _value.engagementScore
          : engagementScore // ignore: cast_nullable_to_non_nullable
              as double,
      countryRanking: null == countryRanking
          ? _value.countryRanking
          : countryRanking // ignore: cast_nullable_to_non_nullable
              as int,
      globalRanking: null == globalRanking
          ? _value.globalRanking
          : globalRanking // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AmbassadorMetricsImpl implements _AmbassadorMetrics {
  const _$AmbassadorMetricsImpl(
      {required this.conversionRate,
      required this.averageReferralsPerMonth,
      required this.streakDays,
      required this.longestStreak,
      required this.lastReferralDate,
      required final Map<String, int> monthlyBreakdown,
      required this.engagementScore,
      required this.countryRanking,
      required this.globalRanking})
      : _monthlyBreakdown = monthlyBreakdown;

  factory _$AmbassadorMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AmbassadorMetricsImplFromJson(json);

  @override
  final int conversionRate;
  @override
  final int averageReferralsPerMonth;
  @override
  final int streakDays;
  @override
  final int longestStreak;
  @override
  final DateTime lastReferralDate;
  final Map<String, int> _monthlyBreakdown;
  @override
  Map<String, int> get monthlyBreakdown {
    if (_monthlyBreakdown is EqualUnmodifiableMapView) return _monthlyBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_monthlyBreakdown);
  }

  @override
  final double engagementScore;
  @override
  final int countryRanking;
  @override
  final int globalRanking;

  @override
  String toString() {
    return 'AmbassadorMetrics(conversionRate: $conversionRate, averageReferralsPerMonth: $averageReferralsPerMonth, streakDays: $streakDays, longestStreak: $longestStreak, lastReferralDate: $lastReferralDate, monthlyBreakdown: $monthlyBreakdown, engagementScore: $engagementScore, countryRanking: $countryRanking, globalRanking: $globalRanking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmbassadorMetricsImpl &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate) &&
            (identical(
                    other.averageReferralsPerMonth, averageReferralsPerMonth) ||
                other.averageReferralsPerMonth == averageReferralsPerMonth) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastReferralDate, lastReferralDate) ||
                other.lastReferralDate == lastReferralDate) &&
            const DeepCollectionEquality()
                .equals(other._monthlyBreakdown, _monthlyBreakdown) &&
            (identical(other.engagementScore, engagementScore) ||
                other.engagementScore == engagementScore) &&
            (identical(other.countryRanking, countryRanking) ||
                other.countryRanking == countryRanking) &&
            (identical(other.globalRanking, globalRanking) ||
                other.globalRanking == globalRanking));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      conversionRate,
      averageReferralsPerMonth,
      streakDays,
      longestStreak,
      lastReferralDate,
      const DeepCollectionEquality().hash(_monthlyBreakdown),
      engagementScore,
      countryRanking,
      globalRanking);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AmbassadorMetricsImplCopyWith<_$AmbassadorMetricsImpl> get copyWith =>
      __$$AmbassadorMetricsImplCopyWithImpl<_$AmbassadorMetricsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int conversionRate,
            int averageReferralsPerMonth,
            int streakDays,
            int longestStreak,
            DateTime lastReferralDate,
            Map<String, int> monthlyBreakdown,
            double engagementScore,
            int countryRanking,
            int globalRanking)
        $default,
  ) {
    return $default(
        conversionRate,
        averageReferralsPerMonth,
        streakDays,
        longestStreak,
        lastReferralDate,
        monthlyBreakdown,
        engagementScore,
        countryRanking,
        globalRanking);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int conversionRate,
            int averageReferralsPerMonth,
            int streakDays,
            int longestStreak,
            DateTime lastReferralDate,
            Map<String, int> monthlyBreakdown,
            double engagementScore,
            int countryRanking,
            int globalRanking)?
        $default,
  ) {
    return $default?.call(
        conversionRate,
        averageReferralsPerMonth,
        streakDays,
        longestStreak,
        lastReferralDate,
        monthlyBreakdown,
        engagementScore,
        countryRanking,
        globalRanking);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int conversionRate,
            int averageReferralsPerMonth,
            int streakDays,
            int longestStreak,
            DateTime lastReferralDate,
            Map<String, int> monthlyBreakdown,
            double engagementScore,
            int countryRanking,
            int globalRanking)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          conversionRate,
          averageReferralsPerMonth,
          streakDays,
          longestStreak,
          lastReferralDate,
          monthlyBreakdown,
          engagementScore,
          countryRanking,
          globalRanking);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AmbassadorMetricsImplToJson(
      this,
    );
  }
}

abstract class _AmbassadorMetrics implements AmbassadorMetrics {
  const factory _AmbassadorMetrics(
      {required final int conversionRate,
      required final int averageReferralsPerMonth,
      required final int streakDays,
      required final int longestStreak,
      required final DateTime lastReferralDate,
      required final Map<String, int> monthlyBreakdown,
      required final double engagementScore,
      required final int countryRanking,
      required final int globalRanking}) = _$AmbassadorMetricsImpl;

  factory _AmbassadorMetrics.fromJson(Map<String, dynamic> json) =
      _$AmbassadorMetricsImpl.fromJson;

  @override
  int get conversionRate;
  @override
  int get averageReferralsPerMonth;
  @override
  int get streakDays;
  @override
  int get longestStreak;
  @override
  DateTime get lastReferralDate;
  @override
  Map<String, int> get monthlyBreakdown;
  @override
  double get engagementScore;
  @override
  int get countryRanking;
  @override
  int get globalRanking;
  @override
  @JsonKey(ignore: true)
  _$$AmbassadorMetricsImplCopyWith<_$AmbassadorMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AmbassadorReferral _$AmbassadorReferralFromJson(Map<String, dynamic> json) {
  return _AmbassadorReferral.fromJson(json);
}

/// @nodoc
mixin _$AmbassadorReferral {
  String get id => throw _privateConstructorUsedError;
  String get ambassadorId => throw _privateConstructorUsedError;
  String get referredUserId => throw _privateConstructorUsedError;
  DateTime get referredAt => throw _privateConstructorUsedError;
  DateTime get activatedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String? get conversionDetails => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String ambassadorId,
            String referredUserId,
            DateTime referredAt,
            DateTime activatedAt,
            bool isActive,
            String source,
            String? conversionDetails,
            Map<String, dynamic>? metadata)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String ambassadorId,
            String referredUserId,
            DateTime referredAt,
            DateTime activatedAt,
            bool isActive,
            String source,
            String? conversionDetails,
            Map<String, dynamic>? metadata)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String ambassadorId,
            String referredUserId,
            DateTime referredAt,
            DateTime activatedAt,
            bool isActive,
            String source,
            String? conversionDetails,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AmbassadorReferralCopyWith<AmbassadorReferral> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmbassadorReferralCopyWith<$Res> {
  factory $AmbassadorReferralCopyWith(
          AmbassadorReferral value, $Res Function(AmbassadorReferral) then) =
      _$AmbassadorReferralCopyWithImpl<$Res, AmbassadorReferral>;
  @useResult
  $Res call(
      {String id,
      String ambassadorId,
      String referredUserId,
      DateTime referredAt,
      DateTime activatedAt,
      bool isActive,
      String source,
      String? conversionDetails,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$AmbassadorReferralCopyWithImpl<$Res, $Val extends AmbassadorReferral>
    implements $AmbassadorReferralCopyWith<$Res> {
  _$AmbassadorReferralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ambassadorId = null,
    Object? referredUserId = null,
    Object? referredAt = null,
    Object? activatedAt = null,
    Object? isActive = null,
    Object? source = null,
    Object? conversionDetails = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ambassadorId: null == ambassadorId
          ? _value.ambassadorId
          : ambassadorId // ignore: cast_nullable_to_non_nullable
              as String,
      referredUserId: null == referredUserId
          ? _value.referredUserId
          : referredUserId // ignore: cast_nullable_to_non_nullable
              as String,
      referredAt: null == referredAt
          ? _value.referredAt
          : referredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      activatedAt: null == activatedAt
          ? _value.activatedAt
          : activatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      conversionDetails: freezed == conversionDetails
          ? _value.conversionDetails
          : conversionDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AmbassadorReferralImplCopyWith<$Res>
    implements $AmbassadorReferralCopyWith<$Res> {
  factory _$$AmbassadorReferralImplCopyWith(_$AmbassadorReferralImpl value,
          $Res Function(_$AmbassadorReferralImpl) then) =
      __$$AmbassadorReferralImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ambassadorId,
      String referredUserId,
      DateTime referredAt,
      DateTime activatedAt,
      bool isActive,
      String source,
      String? conversionDetails,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$AmbassadorReferralImplCopyWithImpl<$Res>
    extends _$AmbassadorReferralCopyWithImpl<$Res, _$AmbassadorReferralImpl>
    implements _$$AmbassadorReferralImplCopyWith<$Res> {
  __$$AmbassadorReferralImplCopyWithImpl(_$AmbassadorReferralImpl _value,
      $Res Function(_$AmbassadorReferralImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ambassadorId = null,
    Object? referredUserId = null,
    Object? referredAt = null,
    Object? activatedAt = null,
    Object? isActive = null,
    Object? source = null,
    Object? conversionDetails = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$AmbassadorReferralImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ambassadorId: null == ambassadorId
          ? _value.ambassadorId
          : ambassadorId // ignore: cast_nullable_to_non_nullable
              as String,
      referredUserId: null == referredUserId
          ? _value.referredUserId
          : referredUserId // ignore: cast_nullable_to_non_nullable
              as String,
      referredAt: null == referredAt
          ? _value.referredAt
          : referredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      activatedAt: null == activatedAt
          ? _value.activatedAt
          : activatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      conversionDetails: freezed == conversionDetails
          ? _value.conversionDetails
          : conversionDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AmbassadorReferralImpl implements _AmbassadorReferral {
  const _$AmbassadorReferralImpl(
      {required this.id,
      required this.ambassadorId,
      required this.referredUserId,
      required this.referredAt,
      required this.activatedAt,
      required this.isActive,
      required this.source,
      this.conversionDetails,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$AmbassadorReferralImpl.fromJson(Map<String, dynamic> json) =>
      _$$AmbassadorReferralImplFromJson(json);

  @override
  final String id;
  @override
  final String ambassadorId;
  @override
  final String referredUserId;
  @override
  final DateTime referredAt;
  @override
  final DateTime activatedAt;
  @override
  final bool isActive;
  @override
  final String source;
  @override
  final String? conversionDetails;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AmbassadorReferral(id: $id, ambassadorId: $ambassadorId, referredUserId: $referredUserId, referredAt: $referredAt, activatedAt: $activatedAt, isActive: $isActive, source: $source, conversionDetails: $conversionDetails, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmbassadorReferralImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ambassadorId, ambassadorId) ||
                other.ambassadorId == ambassadorId) &&
            (identical(other.referredUserId, referredUserId) ||
                other.referredUserId == referredUserId) &&
            (identical(other.referredAt, referredAt) ||
                other.referredAt == referredAt) &&
            (identical(other.activatedAt, activatedAt) ||
                other.activatedAt == activatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.conversionDetails, conversionDetails) ||
                other.conversionDetails == conversionDetails) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ambassadorId,
      referredUserId,
      referredAt,
      activatedAt,
      isActive,
      source,
      conversionDetails,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AmbassadorReferralImplCopyWith<_$AmbassadorReferralImpl> get copyWith =>
      __$$AmbassadorReferralImplCopyWithImpl<_$AmbassadorReferralImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String ambassadorId,
            String referredUserId,
            DateTime referredAt,
            DateTime activatedAt,
            bool isActive,
            String source,
            String? conversionDetails,
            Map<String, dynamic>? metadata)
        $default,
  ) {
    return $default(id, ambassadorId, referredUserId, referredAt, activatedAt,
        isActive, source, conversionDetails, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String ambassadorId,
            String referredUserId,
            DateTime referredAt,
            DateTime activatedAt,
            bool isActive,
            String source,
            String? conversionDetails,
            Map<String, dynamic>? metadata)?
        $default,
  ) {
    return $default?.call(id, ambassadorId, referredUserId, referredAt,
        activatedAt, isActive, source, conversionDetails, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String ambassadorId,
            String referredUserId,
            DateTime referredAt,
            DateTime activatedAt,
            bool isActive,
            String source,
            String? conversionDetails,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, ambassadorId, referredUserId, referredAt, activatedAt,
          isActive, source, conversionDetails, metadata);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AmbassadorReferralImplToJson(
      this,
    );
  }
}

abstract class _AmbassadorReferral implements AmbassadorReferral {
  const factory _AmbassadorReferral(
      {required final String id,
      required final String ambassadorId,
      required final String referredUserId,
      required final DateTime referredAt,
      required final DateTime activatedAt,
      required final bool isActive,
      required final String source,
      final String? conversionDetails,
      final Map<String, dynamic>? metadata}) = _$AmbassadorReferralImpl;

  factory _AmbassadorReferral.fromJson(Map<String, dynamic> json) =
      _$AmbassadorReferralImpl.fromJson;

  @override
  String get id;
  @override
  String get ambassadorId;
  @override
  String get referredUserId;
  @override
  DateTime get referredAt;
  @override
  DateTime get activatedAt;
  @override
  bool get isActive;
  @override
  String get source;
  @override
  String? get conversionDetails;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$AmbassadorReferralImplCopyWith<_$AmbassadorReferralImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
