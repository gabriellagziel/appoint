// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_broadcast_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

AdminBroadcastMessage _$AdminBroadcastMessageFromJson(
    Map<String, dynamic> json) {
  return _AdminBroadcastMessage.fromJson(json);
}

/// @nodoc
mixin _$AdminBroadcastMessage {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  BroadcastMessageType get type => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;
  String? get externalLink => throw _privateConstructorUsedError;
  List<String>? get pollOptions => throw _privateConstructorUsedError;
  BroadcastTargetingFilters get targetingFilters =>
      throw _privateConstructorUsedError;
  String get createdByAdminId => throw _privateConstructorUsedError;
  String get createdByAdminName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get scheduledFor => throw _privateConstructorUsedError;
  BroadcastMessageStatus get status => throw _privateConstructorUsedError;
  int? get estimatedRecipients => throw _privateConstructorUsedError;
  int? get actualRecipients => throw _privateConstructorUsedError;
  int? get openedCount => throw _privateConstructorUsedError;
  int? get clickedCount => throw _privateConstructorUsedError;
  Map<String, int>? get pollResponses => throw _privateConstructorUsedError;
  List<String>? get failedRecipients => throw _privateConstructorUsedError;
  String? get failureReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminBroadcastMessageCopyWith<AdminBroadcastMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminBroadcastMessageCopyWith<$Res> {
  factory $AdminBroadcastMessageCopyWith(AdminBroadcastMessage value,
          $Res Function(AdminBroadcastMessage) then) =
      _$REDACTED_TOKEN<$Res, AdminBroadcastMessage>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      BroadcastMessageType type,
      String? imageUrl,
      String? videoUrl,
      String? externalLink,
      List<String>? pollOptions,
      BroadcastTargetingFilters targetingFilters,
      String createdByAdminId,
      String createdByAdminName,
      DateTime createdAt,
      DateTime? scheduledFor,
      BroadcastMessageStatus status,
      int? estimatedRecipients,
      int? actualRecipients,
      int? openedCount,
      int? clickedCount,
      Map<String, int>? pollResponses,
      List<String>? failedRecipients,
      String? failureReason});

  $REDACTED_TOKEN<$Res> get targetingFilters;
}

/// @nodoc
class _$REDACTED_TOKEN<$Res,
        $Val extends AdminBroadcastMessage>
    implements $AdminBroadcastMessageCopyWith<$Res> {
  _$REDACTED_TOKEN(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? externalLink = freezed,
    Object? pollOptions = freezed,
    Object? targetingFilters = null,
    Object? createdByAdminId = null,
    Object? createdByAdminName = null,
    Object? createdAt = null,
    Object? scheduledFor = freezed,
    Object? status = null,
    Object? estimatedRecipients = freezed,
    Object? actualRecipients = freezed,
    Object? openedCount = freezed,
    Object? clickedCount = freezed,
    Object? pollResponses = freezed,
    Object? failedRecipients = freezed,
    Object? failureReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BroadcastMessageType,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalLink: freezed == externalLink
          ? _value.externalLink
          : externalLink // ignore: cast_nullable_to_non_nullable
              as String?,
      pollOptions: freezed == pollOptions
          ? _value.pollOptions
          : pollOptions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      targetingFilters: null == targetingFilters
          ? _value.targetingFilters
          : targetingFilters // ignore: cast_nullable_to_non_nullable
              as BroadcastTargetingFilters,
      createdByAdminId: null == createdByAdminId
          ? _value.createdByAdminId
          : createdByAdminId // ignore: cast_nullable_to_non_nullable
              as String,
      createdByAdminName: null == createdByAdminName
          ? _value.createdByAdminName
          : createdByAdminName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BroadcastMessageStatus,
      estimatedRecipients: freezed == estimatedRecipients
          ? _value.estimatedRecipients
          : estimatedRecipients // ignore: cast_nullable_to_non_nullable
              as int?,
      actualRecipients: freezed == actualRecipients
          ? _value.actualRecipients
          : actualRecipients // ignore: cast_nullable_to_non_nullable
              as int?,
      openedCount: freezed == openedCount
          ? _value.openedCount
          : openedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      clickedCount: freezed == clickedCount
          ? _value.clickedCount
          : clickedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pollResponses: freezed == pollResponses
          ? _value.pollResponses
          : pollResponses // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      failedRecipients: freezed == failedRecipients
          ? _value.failedRecipients
          : failedRecipients // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $REDACTED_TOKEN<$Res> get targetingFilters {
    return $REDACTED_TOKEN<$Res>(_value.targetingFilters,
        (value) {
      return _then(_value.copyWith(targetingFilters: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$REDACTED_TOKEN<$Res>
    implements $AdminBroadcastMessageCopyWith<$Res> {
  factory _$$REDACTED_TOKEN(
          _$AdminBroadcastMessageImpl value,
          $Res Function(_$AdminBroadcastMessageImpl) then) =
      __$$REDACTED_TOKEN<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      BroadcastMessageType type,
      String? imageUrl,
      String? videoUrl,
      String? externalLink,
      List<String>? pollOptions,
      BroadcastTargetingFilters targetingFilters,
      String createdByAdminId,
      String createdByAdminName,
      DateTime createdAt,
      DateTime? scheduledFor,
      BroadcastMessageStatus status,
      int? estimatedRecipients,
      int? actualRecipients,
      int? openedCount,
      int? clickedCount,
      Map<String, int>? pollResponses,
      List<String>? failedRecipients,
      String? failureReason});

  @override
  $REDACTED_TOKEN<$Res> get targetingFilters;
}

/// @nodoc
class __$$REDACTED_TOKEN<$Res>
    extends _$REDACTED_TOKEN<$Res,
        _$AdminBroadcastMessageImpl>
    implements _$$REDACTED_TOKEN<$Res> {
  __$$REDACTED_TOKEN(_$AdminBroadcastMessageImpl _value,
      $Res Function(_$AdminBroadcastMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? imageUrl = freezed,
    Object? videoUrl = freezed,
    Object? externalLink = freezed,
    Object? pollOptions = freezed,
    Object? targetingFilters = null,
    Object? createdByAdminId = null,
    Object? createdByAdminName = null,
    Object? createdAt = null,
    Object? scheduledFor = freezed,
    Object? status = null,
    Object? estimatedRecipients = freezed,
    Object? actualRecipients = freezed,
    Object? openedCount = freezed,
    Object? clickedCount = freezed,
    Object? pollResponses = freezed,
    Object? failedRecipients = freezed,
    Object? failureReason = freezed,
  }) {
    return _then(_$AdminBroadcastMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BroadcastMessageType,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalLink: freezed == externalLink
          ? _value.externalLink
          : externalLink // ignore: cast_nullable_to_non_nullable
              as String?,
      pollOptions: freezed == pollOptions
          ? _value._pollOptions
          : pollOptions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      targetingFilters: null == targetingFilters
          ? _value.targetingFilters
          : targetingFilters // ignore: cast_nullable_to_non_nullable
              as BroadcastTargetingFilters,
      createdByAdminId: null == createdByAdminId
          ? _value.createdByAdminId
          : createdByAdminId // ignore: cast_nullable_to_non_nullable
              as String,
      createdByAdminName: null == createdByAdminName
          ? _value.createdByAdminName
          : createdByAdminName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BroadcastMessageStatus,
      estimatedRecipients: freezed == estimatedRecipients
          ? _value.estimatedRecipients
          : estimatedRecipients // ignore: cast_nullable_to_non_nullable
              as int?,
      actualRecipients: freezed == actualRecipients
          ? _value.actualRecipients
          : actualRecipients // ignore: cast_nullable_to_non_nullable
              as int?,
      openedCount: freezed == openedCount
          ? _value.openedCount
          : openedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      clickedCount: freezed == clickedCount
          ? _value.clickedCount
          : clickedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pollResponses: freezed == pollResponses
          ? _value._pollResponses
          : pollResponses // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      failedRecipients: freezed == failedRecipients
          ? _value._failedRecipients
          : failedRecipients // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminBroadcastMessageImpl implements _AdminBroadcastMessage {
  const _$AdminBroadcastMessageImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.type,
      this.imageUrl,
      this.videoUrl,
      this.externalLink,
      final List<String>? pollOptions,
      required this.targetingFilters,
      required this.createdByAdminId,
      required this.createdByAdminName,
      required this.createdAt,
      this.scheduledFor,
      required this.status,
      this.estimatedRecipients,
      this.actualRecipients,
      this.openedCount,
      this.clickedCount,
      final Map<String, int>? pollResponses,
      final List<String>? failedRecipients,
      this.failureReason})
      : _pollOptions = pollOptions,
        _pollResponses = pollResponses,
        _failedRecipients = failedRecipients;

  factory _$AdminBroadcastMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$REDACTED_TOKEN(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final BroadcastMessageType type;
  @override
  final String? imageUrl;
  @override
  final String? videoUrl;
  @override
  final String? externalLink;
  final List<String>? _pollOptions;
  @override
  List<String>? get pollOptions {
    final value = _pollOptions;
    if (value == null) return null;
    if (_pollOptions is EqualUnmodifiableListView) return _pollOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final BroadcastTargetingFilters targetingFilters;
  @override
  final String createdByAdminId;
  @override
  final String createdByAdminName;
  @override
  final DateTime createdAt;
  @override
  final DateTime? scheduledFor;
  @override
  final BroadcastMessageStatus status;
  @override
  final int? estimatedRecipients;
  @override
  final int? actualRecipients;
  @override
  final int? openedCount;
  @override
  final int? clickedCount;
  final Map<String, int>? _pollResponses;
  @override
  Map<String, int>? get pollResponses {
    final value = _pollResponses;
    if (value == null) return null;
    if (_pollResponses is EqualUnmodifiableMapView) return _pollResponses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _failedRecipients;
  @override
  List<String>? get failedRecipients {
    final value = _failedRecipients;
    if (value == null) return null;
    if (_failedRecipients is EqualUnmodifiableListView)
      return _failedRecipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? failureReason;

  @override
  String toString() {
    return 'AdminBroadcastMessage(id: $id, title: $title, content: $content, type: $type, imageUrl: $imageUrl, videoUrl: $videoUrl, externalLink: $externalLink, pollOptions: $pollOptions, targetingFilters: $targetingFilters, createdByAdminId: $createdByAdminId, createdByAdminName: $createdByAdminName, createdAt: $createdAt, scheduledFor: $scheduledFor, status: $status, estimatedRecipients: $estimatedRecipients, actualRecipients: $actualRecipients, openedCount: $openedCount, clickedCount: $clickedCount, pollResponses: $pollResponses, failedRecipients: $failedRecipients, failureReason: $failureReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminBroadcastMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.externalLink, externalLink) ||
                other.externalLink == externalLink) &&
            const DeepCollectionEquality()
                .equals(other._pollOptions, _pollOptions) &&
            (identical(other.targetingFilters, targetingFilters) ||
                other.targetingFilters == targetingFilters) &&
            (identical(other.createdByAdminId, createdByAdminId) ||
                other.createdByAdminId == createdByAdminId) &&
            (identical(other.createdByAdminName, createdByAdminName) ||
                other.createdByAdminName == createdByAdminName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedRecipients, estimatedRecipients) ||
                other.estimatedRecipients == estimatedRecipients) &&
            (identical(other.actualRecipients, actualRecipients) ||
                other.actualRecipients == actualRecipients) &&
            (identical(other.openedCount, openedCount) ||
                other.openedCount == openedCount) &&
            (identical(other.clickedCount, clickedCount) ||
                other.clickedCount == clickedCount) &&
            const DeepCollectionEquality()
                .equals(other._pollResponses, _pollResponses) &&
            const DeepCollectionEquality()
                .equals(other._failedRecipients, _failedRecipients) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        content,
        type,
        imageUrl,
        videoUrl,
        externalLink,
        const DeepCollectionEquality().hash(_pollOptions),
        targetingFilters,
        createdByAdminId,
        createdByAdminName,
        createdAt,
        scheduledFor,
        status,
        estimatedRecipients,
        actualRecipients,
        openedCount,
        clickedCount,
        const DeepCollectionEquality().hash(_pollResponses),
        const DeepCollectionEquality().hash(_failedRecipients),
        failureReason
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$REDACTED_TOKEN<_$AdminBroadcastMessageImpl>
      get copyWith => __$$REDACTED_TOKEN<
          _$AdminBroadcastMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminBroadcastMessageImplToJson(
      this,
    );
  }
}

abstract class _AdminBroadcastMessage implements AdminBroadcastMessage {
  const factory _AdminBroadcastMessage(
      {required final String id,
      required final String title,
      required final String content,
      required final BroadcastMessageType type,
      final String? imageUrl,
      final String? videoUrl,
      final String? externalLink,
      final List<String>? pollOptions,
      required final BroadcastTargetingFilters targetingFilters,
      required final String createdByAdminId,
      required final String createdByAdminName,
      required final DateTime createdAt,
      final DateTime? scheduledFor,
      required final BroadcastMessageStatus status,
      final int? estimatedRecipients,
      final int? actualRecipients,
      final int? openedCount,
      final int? clickedCount,
      final Map<String, int>? pollResponses,
      final List<String>? failedRecipients,
      final String? failureReason}) = _$AdminBroadcastMessageImpl;

  factory _AdminBroadcastMessage.fromJson(Map<String, dynamic> json) =
      _$AdminBroadcastMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  BroadcastMessageType get type;
  @override
  String? get imageUrl;
  @override
  String? get videoUrl;
  @override
  String? get externalLink;
  @override
  List<String>? get pollOptions;
  @override
  BroadcastTargetingFilters get targetingFilters;
  @override
  String get createdByAdminId;
  @override
  String get createdByAdminName;
  @override
  DateTime get createdAt;
  @override
  DateTime? get scheduledFor;
  @override
  BroadcastMessageStatus get status;
  @override
  int? get estimatedRecipients;
  @override
  int? get actualRecipients;
  @override
  int? get openedCount;
  @override
  int? get clickedCount;
  @override
  Map<String, int>? get pollResponses;
  @override
  List<String>? get failedRecipients;
  @override
  String? get failureReason;
  @override
  @JsonKey(ignore: true)
  _$$REDACTED_TOKEN<_$AdminBroadcastMessageImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BroadcastTargetingFilters _$REDACTED_TOKEN(
    Map<String, dynamic> json) {
  return _BroadcastTargetingFilters.fromJson(json);
}

/// @nodoc
mixin _$BroadcastTargetingFilters {
  List<String>? get countries => throw _privateConstructorUsedError;
  List<String>? get cities => throw _privateConstructorUsedError;
  int? get minAge => throw _privateConstructorUsedError;
  int? get maxAge => throw _privateConstructorUsedError;
  List<String>? get subscriptionTiers => throw _privateConstructorUsedError;
  List<String>? get accountTypes => throw _privateConstructorUsedError;
  List<String>? get languages => throw _privateConstructorUsedError;
  List<String>? get accountStatuses => throw _privateConstructorUsedError;
  DateTime? get joinedAfter => throw _privateConstructorUsedError;
  DateTime? get joinedBefore => throw _privateConstructorUsedError;
  List<String>? get userRoles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $REDACTED_TOKEN<BroadcastTargetingFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $REDACTED_TOKEN<$Res> {
  factory $REDACTED_TOKEN(BroadcastTargetingFilters value,
          $Res Function(BroadcastTargetingFilters) then) =
      _$REDACTED_TOKEN<$Res, BroadcastTargetingFilters>;
  @useResult
  $Res call(
      {List<String>? countries,
      List<String>? cities,
      int? minAge,
      int? maxAge,
      List<String>? subscriptionTiers,
      List<String>? accountTypes,
      List<String>? languages,
      List<String>? accountStatuses,
      DateTime? joinedAfter,
      DateTime? joinedBefore,
      List<String>? userRoles});
}

/// @nodoc
class _$REDACTED_TOKEN<$Res,
        $Val extends BroadcastTargetingFilters>
    implements $REDACTED_TOKEN<$Res> {
  _$REDACTED_TOKEN(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = freezed,
    Object? cities = freezed,
    Object? minAge = freezed,
    Object? maxAge = freezed,
    Object? subscriptionTiers = freezed,
    Object? accountTypes = freezed,
    Object? languages = freezed,
    Object? accountStatuses = freezed,
    Object? joinedAfter = freezed,
    Object? joinedBefore = freezed,
    Object? userRoles = freezed,
  }) {
    return _then(_value.copyWith(
      countries: freezed == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cities: freezed == cities
          ? _value.cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
      subscriptionTiers: freezed == subscriptionTiers
          ? _value.subscriptionTiers
          : subscriptionTiers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      accountTypes: freezed == accountTypes
          ? _value.accountTypes
          : accountTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      languages: freezed == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      accountStatuses: freezed == accountStatuses
          ? _value.accountStatuses
          : accountStatuses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      joinedAfter: freezed == joinedAfter
          ? _value.joinedAfter
          : joinedAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      joinedBefore: freezed == joinedBefore
          ? _value.joinedBefore
          : joinedBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userRoles: freezed == userRoles
          ? _value.userRoles
          : userRoles // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$REDACTED_TOKEN<$Res>
    implements $REDACTED_TOKEN<$Res> {
  factory _$$REDACTED_TOKEN(
          _$BroadcastTargetingFiltersImpl value,
          $Res Function(_$BroadcastTargetingFiltersImpl) then) =
      __$$REDACTED_TOKEN<$Res>;
  @override
  @useResult
  $Res call(
      {List<String>? countries,
      List<String>? cities,
      int? minAge,
      int? maxAge,
      List<String>? subscriptionTiers,
      List<String>? accountTypes,
      List<String>? languages,
      List<String>? accountStatuses,
      DateTime? joinedAfter,
      DateTime? joinedBefore,
      List<String>? userRoles});
}

/// @nodoc
class __$$REDACTED_TOKEN<$Res>
    extends _$REDACTED_TOKEN<$Res,
        _$BroadcastTargetingFiltersImpl>
    implements _$$REDACTED_TOKEN<$Res> {
  __$$REDACTED_TOKEN(
      _$BroadcastTargetingFiltersImpl _value,
      $Res Function(_$BroadcastTargetingFiltersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = freezed,
    Object? cities = freezed,
    Object? minAge = freezed,
    Object? maxAge = freezed,
    Object? subscriptionTiers = freezed,
    Object? accountTypes = freezed,
    Object? languages = freezed,
    Object? accountStatuses = freezed,
    Object? joinedAfter = freezed,
    Object? joinedBefore = freezed,
    Object? userRoles = freezed,
  }) {
    return _then(_$BroadcastTargetingFiltersImpl(
      countries: freezed == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cities: freezed == cities
          ? _value._cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
      subscriptionTiers: freezed == subscriptionTiers
          ? _value._subscriptionTiers
          : subscriptionTiers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      accountTypes: freezed == accountTypes
          ? _value._accountTypes
          : accountTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      languages: freezed == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      accountStatuses: freezed == accountStatuses
          ? _value._accountStatuses
          : accountStatuses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      joinedAfter: freezed == joinedAfter
          ? _value.joinedAfter
          : joinedAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      joinedBefore: freezed == joinedBefore
          ? _value.joinedBefore
          : joinedBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userRoles: freezed == userRoles
          ? _value._userRoles
          : userRoles // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BroadcastTargetingFiltersImpl implements _BroadcastTargetingFilters {
  const _$BroadcastTargetingFiltersImpl(
      {final List<String>? countries,
      final List<String>? cities,
      this.minAge,
      this.maxAge,
      final List<String>? subscriptionTiers,
      final List<String>? accountTypes,
      final List<String>? languages,
      final List<String>? accountStatuses,
      this.joinedAfter,
      this.joinedBefore,
      final List<String>? userRoles})
      : _countries = countries,
        _cities = cities,
        _subscriptionTiers = subscriptionTiers,
        _accountTypes = accountTypes,
        _languages = languages,
        _accountStatuses = accountStatuses,
        _userRoles = userRoles;

  factory _$BroadcastTargetingFiltersImpl.fromJson(Map<String, dynamic> json) =>
      _$$REDACTED_TOKEN(json);

  final List<String>? _countries;
  @override
  List<String>? get countries {
    final value = _countries;
    if (value == null) return null;
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _cities;
  @override
  List<String>? get cities {
    final value = _cities;
    if (value == null) return null;
    if (_cities is EqualUnmodifiableListView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? minAge;
  @override
  final int? maxAge;
  final List<String>? _subscriptionTiers;
  @override
  List<String>? get subscriptionTiers {
    final value = _subscriptionTiers;
    if (value == null) return null;
    if (_subscriptionTiers is EqualUnmodifiableListView)
      return _subscriptionTiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _accountTypes;
  @override
  List<String>? get accountTypes {
    final value = _accountTypes;
    if (value == null) return null;
    if (_accountTypes is EqualUnmodifiableListView) return _accountTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _accountStatuses;
  @override
  List<String>? get accountStatuses {
    final value = _accountStatuses;
    if (value == null) return null;
    if (_accountStatuses is EqualUnmodifiableListView) return _accountStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? joinedAfter;
  @override
  final DateTime? joinedBefore;
  final List<String>? _userRoles;
  @override
  List<String>? get userRoles {
    final value = _userRoles;
    if (value == null) return null;
    if (_userRoles is EqualUnmodifiableListView) return _userRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BroadcastTargetingFilters(countries: $countries, cities: $cities, minAge: $minAge, maxAge: $maxAge, subscriptionTiers: $subscriptionTiers, accountTypes: $accountTypes, languages: $languages, accountStatuses: $accountStatuses, joinedAfter: $joinedAfter, joinedBefore: $joinedBefore, userRoles: $userRoles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BroadcastTargetingFiltersImpl &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            const DeepCollectionEquality().equals(other._cities, _cities) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge) &&
            const DeepCollectionEquality()
                .equals(other._subscriptionTiers, _subscriptionTiers) &&
            const DeepCollectionEquality()
                .equals(other._accountTypes, _accountTypes) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality()
                .equals(other._accountStatuses, _accountStatuses) &&
            (identical(other.joinedAfter, joinedAfter) ||
                other.joinedAfter == joinedAfter) &&
            (identical(other.joinedBefore, joinedBefore) ||
                other.joinedBefore == joinedBefore) &&
            const DeepCollectionEquality()
                .equals(other._userRoles, _userRoles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_countries),
      const DeepCollectionEquality().hash(_cities),
      minAge,
      maxAge,
      const DeepCollectionEquality().hash(_subscriptionTiers),
      const DeepCollectionEquality().hash(_accountTypes),
      const DeepCollectionEquality().hash(_languages),
      const DeepCollectionEquality().hash(_accountStatuses),
      joinedAfter,
      joinedBefore,
      const DeepCollectionEquality().hash(_userRoles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$REDACTED_TOKEN<_$BroadcastTargetingFiltersImpl>
      get copyWith => __$$REDACTED_TOKEN<
          _$BroadcastTargetingFiltersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$REDACTED_TOKEN(
      this,
    );
  }
}

abstract class _BroadcastTargetingFilters implements BroadcastTargetingFilters {
  const factory _BroadcastTargetingFilters(
      {final List<String>? countries,
      final List<String>? cities,
      final int? minAge,
      final int? maxAge,
      final List<String>? subscriptionTiers,
      final List<String>? accountTypes,
      final List<String>? languages,
      final List<String>? accountStatuses,
      final DateTime? joinedAfter,
      final DateTime? joinedBefore,
      final List<String>? userRoles}) = _$BroadcastTargetingFiltersImpl;

  factory _BroadcastTargetingFilters.fromJson(Map<String, dynamic> json) =
      _$BroadcastTargetingFiltersImpl.fromJson;

  @override
  List<String>? get countries;
  @override
  List<String>? get cities;
  @override
  int? get minAge;
  @override
  int? get maxAge;
  @override
  List<String>? get subscriptionTiers;
  @override
  List<String>? get accountTypes;
  @override
  List<String>? get languages;
  @override
  List<String>? get accountStatuses;
  @override
  DateTime? get joinedAfter;
  @override
  DateTime? get joinedBefore;
  @override
  List<String>? get userRoles;
  @override
  @JsonKey(ignore: true)
  _$$REDACTED_TOKEN<_$BroadcastTargetingFiltersImpl>
      get copyWith => throw _privateConstructorUsedError;
}
