// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_share_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmartShareLink _$SmartShareLinkFromJson(Map<String, dynamic> json) {
  return _SmartShareLink.fromJson(json);
}

/// @nodoc
mixin _$SmartShareLink {
  String get meetingId => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  String? get contextId => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get shareChannel => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String meetingId, String creatorId, String? contextId,
            String? groupId, DateTime? createdAt, String? shareChannel)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String meetingId, String creatorId, String? contextId,
            String? groupId, DateTime? createdAt, String? shareChannel)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String meetingId, String creatorId, String? contextId,
            String? groupId, DateTime? createdAt, String? shareChannel)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmartShareLinkCopyWith<SmartShareLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartShareLinkCopyWith<$Res> {
  factory $SmartShareLinkCopyWith(
          SmartShareLink value, $Res Function(SmartShareLink) then) =
      _$SmartShareLinkCopyWithImpl<$Res, SmartShareLink>;
  @useResult
  $Res call(
      {String meetingId,
      String creatorId,
      String? contextId,
      String? groupId,
      DateTime? createdAt,
      String? shareChannel});
}

/// @nodoc
class _$SmartShareLinkCopyWithImpl<$Res, $Val extends SmartShareLink>
    implements $SmartShareLinkCopyWith<$Res> {
  _$SmartShareLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meetingId = null,
    Object? creatorId = null,
    Object? contextId = freezed,
    Object? groupId = freezed,
    Object? createdAt = freezed,
    Object? shareChannel = freezed,
  }) {
    return _then(_value.copyWith(
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      contextId: freezed == contextId
          ? _value.contextId
          : contextId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shareChannel: freezed == shareChannel
          ? _value.shareChannel
          : shareChannel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartShareLinkImplCopyWith<$Res>
    implements $SmartShareLinkCopyWith<$Res> {
  factory _$$SmartShareLinkImplCopyWith(_$SmartShareLinkImpl value,
          $Res Function(_$SmartShareLinkImpl) then) =
      __$$SmartShareLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String meetingId,
      String creatorId,
      String? contextId,
      String? groupId,
      DateTime? createdAt,
      String? shareChannel});
}

/// @nodoc
class __$$SmartShareLinkImplCopyWithImpl<$Res>
    extends _$SmartShareLinkCopyWithImpl<$Res, _$SmartShareLinkImpl>
    implements _$$SmartShareLinkImplCopyWith<$Res> {
  __$$SmartShareLinkImplCopyWithImpl(
      _$SmartShareLinkImpl _value, $Res Function(_$SmartShareLinkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meetingId = null,
    Object? creatorId = null,
    Object? contextId = freezed,
    Object? groupId = freezed,
    Object? createdAt = freezed,
    Object? shareChannel = freezed,
  }) {
    return _then(_$SmartShareLinkImpl(
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      contextId: freezed == contextId
          ? _value.contextId
          : contextId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shareChannel: freezed == shareChannel
          ? _value.shareChannel
          : shareChannel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartShareLinkImpl implements _SmartShareLink {
  const _$SmartShareLinkImpl(
      {required this.meetingId,
      required this.creatorId,
      this.contextId,
      this.groupId,
      this.createdAt,
      this.shareChannel});

  factory _$SmartShareLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartShareLinkImplFromJson(json);

  @override
  final String meetingId;
  @override
  final String creatorId;
  @override
  final String? contextId;
  @override
  final String? groupId;
  @override
  final DateTime? createdAt;
  @override
  final String? shareChannel;

  @override
  String toString() {
    return 'SmartShareLink(meetingId: $meetingId, creatorId: $creatorId, contextId: $contextId, groupId: $groupId, createdAt: $createdAt, shareChannel: $shareChannel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartShareLinkImpl &&
            (identical(other.meetingId, meetingId) ||
                other.meetingId == meetingId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.contextId, contextId) ||
                other.contextId == contextId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.shareChannel, shareChannel) ||
                other.shareChannel == shareChannel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, meetingId, creatorId, contextId,
      groupId, createdAt, shareChannel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartShareLinkImplCopyWith<_$SmartShareLinkImpl> get copyWith =>
      __$$SmartShareLinkImplCopyWithImpl<_$SmartShareLinkImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String meetingId, String creatorId, String? contextId,
            String? groupId, DateTime? createdAt, String? shareChannel)
        $default,
  ) {
    return $default(
        meetingId, creatorId, contextId, groupId, createdAt, shareChannel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String meetingId, String creatorId, String? contextId,
            String? groupId, DateTime? createdAt, String? shareChannel)?
        $default,
  ) {
    return $default?.call(
        meetingId, creatorId, contextId, groupId, createdAt, shareChannel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String meetingId, String creatorId, String? contextId,
            String? groupId, DateTime? createdAt, String? shareChannel)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          meetingId, creatorId, contextId, groupId, createdAt, shareChannel);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartShareLinkImplToJson(
      this,
    );
  }
}

abstract class _SmartShareLink implements SmartShareLink {
  const factory _SmartShareLink(
      {required final String meetingId,
      required final String creatorId,
      final String? contextId,
      final String? groupId,
      final DateTime? createdAt,
      final String? shareChannel}) = _$SmartShareLinkImpl;

  factory _SmartShareLink.fromJson(Map<String, dynamic> json) =
      _$SmartShareLinkImpl.fromJson;

  @override
  String get meetingId;
  @override
  String get creatorId;
  @override
  String? get contextId;
  @override
  String? get groupId;
  @override
  DateTime? get createdAt;
  @override
  String? get shareChannel;
  @override
  @JsonKey(ignore: true)
  _$$SmartShareLinkImplCopyWith<_$SmartShareLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShareAnalytics _$ShareAnalyticsFromJson(Map<String, dynamic> json) {
  return _ShareAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ShareAnalytics {
  String get meetingId => throw _privateConstructorUsedError;
  String get channel => throw _privateConstructorUsedError;
  DateTime get sharedAt => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get recipientId => throw _privateConstructorUsedError;
  ShareStatus? get status => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String meetingId,
            String channel,
            DateTime sharedAt,
            String? groupId,
            String? recipientId,
            ShareStatus? status,
            DateTime? respondedAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String meetingId,
            String channel,
            DateTime sharedAt,
            String? groupId,
            String? recipientId,
            ShareStatus? status,
            DateTime? respondedAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String meetingId,
            String channel,
            DateTime sharedAt,
            String? groupId,
            String? recipientId,
            ShareStatus? status,
            DateTime? respondedAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShareAnalyticsCopyWith<ShareAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareAnalyticsCopyWith<$Res> {
  factory $ShareAnalyticsCopyWith(
          ShareAnalytics value, $Res Function(ShareAnalytics) then) =
      _$ShareAnalyticsCopyWithImpl<$Res, ShareAnalytics>;
  @useResult
  $Res call(
      {String meetingId,
      String channel,
      DateTime sharedAt,
      String? groupId,
      String? recipientId,
      ShareStatus? status,
      DateTime? respondedAt});
}

/// @nodoc
class _$ShareAnalyticsCopyWithImpl<$Res, $Val extends ShareAnalytics>
    implements $ShareAnalyticsCopyWith<$Res> {
  _$ShareAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meetingId = null,
    Object? channel = null,
    Object? sharedAt = null,
    Object? groupId = freezed,
    Object? recipientId = freezed,
    Object? status = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      sharedAt: null == sharedAt
          ? _value.sharedAt
          : sharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShareStatus?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareAnalyticsImplCopyWith<$Res>
    implements $ShareAnalyticsCopyWith<$Res> {
  factory _$$ShareAnalyticsImplCopyWith(_$ShareAnalyticsImpl value,
          $Res Function(_$ShareAnalyticsImpl) then) =
      __$$ShareAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String meetingId,
      String channel,
      DateTime sharedAt,
      String? groupId,
      String? recipientId,
      ShareStatus? status,
      DateTime? respondedAt});
}

/// @nodoc
class __$$ShareAnalyticsImplCopyWithImpl<$Res>
    extends _$ShareAnalyticsCopyWithImpl<$Res, _$ShareAnalyticsImpl>
    implements _$$ShareAnalyticsImplCopyWith<$Res> {
  __$$ShareAnalyticsImplCopyWithImpl(
      _$ShareAnalyticsImpl _value, $Res Function(_$ShareAnalyticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meetingId = null,
    Object? channel = null,
    Object? sharedAt = null,
    Object? groupId = freezed,
    Object? recipientId = freezed,
    Object? status = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_$ShareAnalyticsImpl(
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      sharedAt: null == sharedAt
          ? _value.sharedAt
          : sharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShareStatus?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareAnalyticsImpl implements _ShareAnalytics {
  const _$ShareAnalyticsImpl(
      {required this.meetingId,
      required this.channel,
      required this.sharedAt,
      this.groupId,
      this.recipientId,
      this.status,
      this.respondedAt});

  factory _$ShareAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareAnalyticsImplFromJson(json);

  @override
  final String meetingId;
  @override
  final String channel;
  @override
  final DateTime sharedAt;
  @override
  final String? groupId;
  @override
  final String? recipientId;
  @override
  final ShareStatus? status;
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'ShareAnalytics(meetingId: $meetingId, channel: $channel, sharedAt: $sharedAt, groupId: $groupId, recipientId: $recipientId, status: $status, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareAnalyticsImpl &&
            (identical(other.meetingId, meetingId) ||
                other.meetingId == meetingId) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.sharedAt, sharedAt) ||
                other.sharedAt == sharedAt) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, meetingId, channel, sharedAt,
      groupId, recipientId, status, respondedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareAnalyticsImplCopyWith<_$ShareAnalyticsImpl> get copyWith =>
      __$$ShareAnalyticsImplCopyWithImpl<_$ShareAnalyticsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String meetingId,
            String channel,
            DateTime sharedAt,
            String? groupId,
            String? recipientId,
            ShareStatus? status,
            DateTime? respondedAt)
        $default,
  ) {
    return $default(meetingId, channel, sharedAt, groupId, recipientId, status,
        respondedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String meetingId,
            String channel,
            DateTime sharedAt,
            String? groupId,
            String? recipientId,
            ShareStatus? status,
            DateTime? respondedAt)?
        $default,
  ) {
    return $default?.call(meetingId, channel, sharedAt, groupId, recipientId,
        status, respondedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String meetingId,
            String channel,
            DateTime sharedAt,
            String? groupId,
            String? recipientId,
            ShareStatus? status,
            DateTime? respondedAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(meetingId, channel, sharedAt, groupId, recipientId,
          status, respondedAt);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _ShareAnalytics implements ShareAnalytics {
  const factory _ShareAnalytics(
      {required final String meetingId,
      required final String channel,
      required final DateTime sharedAt,
      final String? groupId,
      final String? recipientId,
      final ShareStatus? status,
      final DateTime? respondedAt}) = _$ShareAnalyticsImpl;

  factory _ShareAnalytics.fromJson(Map<String, dynamic> json) =
      _$ShareAnalyticsImpl.fromJson;

  @override
  String get meetingId;
  @override
  String get channel;
  @override
  DateTime get sharedAt;
  @override
  String? get groupId;
  @override
  String? get recipientId;
  @override
  ShareStatus? get status;
  @override
  DateTime? get respondedAt;
  @override
  @JsonKey(ignore: true)
  _$$ShareAnalyticsImplCopyWith<_$ShareAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
