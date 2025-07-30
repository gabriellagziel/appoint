// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeetingParticipant _$MeetingParticipantFromJson(Map<String, dynamic> json) {
  return _MeetingParticipant.fromJson(json);
}

/// @nodoc
mixin _$MeetingParticipant {
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  ParticipantRole get role => throw _privateConstructorUsedError;
  bool get hasResponded => throw _privateConstructorUsedError;
  bool get willAttend => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String userId,
            String name,
            String? email,
            String? avatarUrl,
            ParticipantRole role,
            bool hasResponded,
            bool willAttend,
            @DateTimeConverter() DateTime? respondedAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String userId,
            String name,
            String? email,
            String? avatarUrl,
            ParticipantRole role,
            bool hasResponded,
            bool willAttend,
            @DateTimeConverter() DateTime? respondedAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String userId,
            String name,
            String? email,
            String? avatarUrl,
            ParticipantRole role,
            bool hasResponded,
            bool willAttend,
            @DateTimeConverter() DateTime? respondedAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeetingParticipantCopyWith<MeetingParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeetingParticipantCopyWith<$Res> {
  factory $MeetingParticipantCopyWith(
          MeetingParticipant value, $Res Function(MeetingParticipant) then) =
      _$MeetingParticipantCopyWithImpl<$Res, MeetingParticipant>;
  @useResult
  $Res call(
      {String userId,
      String name,
      String? email,
      String? avatarUrl,
      ParticipantRole role,
      bool hasResponded,
      bool willAttend,
      @DateTimeConverter() DateTime? respondedAt});
}

/// @nodoc
class _$MeetingParticipantCopyWithImpl<$Res, $Val extends MeetingParticipant>
    implements $MeetingParticipantCopyWith<$Res> {
  _$MeetingParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? hasResponded = null,
    Object? willAttend = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ParticipantRole,
      hasResponded: null == hasResponded
          ? _value.hasResponded
          : hasResponded // ignore: cast_nullable_to_non_nullable
              as bool,
      willAttend: null == willAttend
          ? _value.willAttend
          : willAttend // ignore: cast_nullable_to_non_nullable
              as bool,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeetingParticipantImplCopyWith<$Res>
    implements $MeetingParticipantCopyWith<$Res> {
  factory _$$MeetingParticipantImplCopyWith(_$MeetingParticipantImpl value,
          $Res Function(_$MeetingParticipantImpl) then) =
      __$$MeetingParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String name,
      String? email,
      String? avatarUrl,
      ParticipantRole role,
      bool hasResponded,
      bool willAttend,
      @DateTimeConverter() DateTime? respondedAt});
}

/// @nodoc
class __$$MeetingParticipantImplCopyWithImpl<$Res>
    extends _$MeetingParticipantCopyWithImpl<$Res, _$MeetingParticipantImpl>
    implements _$$MeetingParticipantImplCopyWith<$Res> {
  __$$MeetingParticipantImplCopyWithImpl(_$MeetingParticipantImpl _value,
      $Res Function(_$MeetingParticipantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? hasResponded = null,
    Object? willAttend = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_$MeetingParticipantImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ParticipantRole,
      hasResponded: null == hasResponded
          ? _value.hasResponded
          : hasResponded // ignore: cast_nullable_to_non_nullable
              as bool,
      willAttend: null == willAttend
          ? _value.willAttend
          : willAttend // ignore: cast_nullable_to_non_nullable
              as bool,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MeetingParticipantImpl implements _MeetingParticipant {
  const _$MeetingParticipantImpl(
      {required this.userId,
      required this.name,
      this.email,
      this.avatarUrl,
      this.role = ParticipantRole.participant,
      this.hasResponded = false,
      this.willAttend = true,
      @DateTimeConverter() this.respondedAt});

  factory _$MeetingParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeetingParticipantImplFromJson(json);

  @override
  final String userId;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final ParticipantRole role;
  @override
  @JsonKey()
  final bool hasResponded;
  @override
  @JsonKey()
  final bool willAttend;
  @override
  @DateTimeConverter()
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'MeetingParticipant(userId: $userId, name: $name, email: $email, avatarUrl: $avatarUrl, role: $role, hasResponded: $hasResponded, willAttend: $willAttend, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeetingParticipantImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.hasResponded, hasResponded) ||
                other.hasResponded == hasResponded) &&
            (identical(other.willAttend, willAttend) ||
                other.willAttend == willAttend) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, name, email, avatarUrl,
      role, hasResponded, willAttend, respondedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeetingParticipantImplCopyWith<_$MeetingParticipantImpl> get copyWith =>
      __$$MeetingParticipantImplCopyWithImpl<_$MeetingParticipantImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String userId,
            String name,
            String? email,
            String? avatarUrl,
            ParticipantRole role,
            bool hasResponded,
            bool willAttend,
            @DateTimeConverter() DateTime? respondedAt)
        $default,
  ) {
    return $default(userId, name, email, avatarUrl, role, hasResponded,
        willAttend, respondedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String userId,
            String name,
            String? email,
            String? avatarUrl,
            ParticipantRole role,
            bool hasResponded,
            bool willAttend,
            @DateTimeConverter() DateTime? respondedAt)?
        $default,
  ) {
    return $default?.call(userId, name, email, avatarUrl, role, hasResponded,
        willAttend, respondedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String userId,
            String name,
            String? email,
            String? avatarUrl,
            ParticipantRole role,
            bool hasResponded,
            bool willAttend,
            @DateTimeConverter() DateTime? respondedAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(userId, name, email, avatarUrl, role, hasResponded,
          willAttend, respondedAt);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MeetingParticipantImplToJson(
      this,
    );
  }
}

abstract class _MeetingParticipant implements MeetingParticipant {
  const factory _MeetingParticipant(
          {required final String userId,
          required final String name,
          final String? email,
          final String? avatarUrl,
          final ParticipantRole role,
          final bool hasResponded,
          final bool willAttend,
          @DateTimeConverter() final DateTime? respondedAt}) =
      _$MeetingParticipantImpl;

  factory _MeetingParticipant.fromJson(Map<String, dynamic> json) =
      _$MeetingParticipantImpl.fromJson;

  @override
  String get userId;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get avatarUrl;
  @override
  ParticipantRole get role;
  @override
  bool get hasResponded;
  @override
  bool get willAttend;
  @override
  @DateTimeConverter()
  DateTime? get respondedAt;
  @override
  @JsonKey(ignore: true)
  _$$MeetingParticipantImplCopyWith<_$MeetingParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Meeting _$MeetingFromJson(Map<String, dynamic> json) {
  return _Meeting.fromJson(json);
}

/// @nodoc
mixin _$Meeting {
  String get id => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @DateTimeConverter()
  @JsonKey(name: 'startTime')
  DateTime get startTime => throw _privateConstructorUsedError;
  @DateTimeConverter()
  @JsonKey(name: 'endTime')
  DateTime get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get virtualMeetingUrl => throw _privateConstructorUsedError;
  List<MeetingParticipant> get participants =>
      throw _privateConstructorUsedError;
  MeetingStatus get status => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Event-specific features (only available for events)
  String? get customFormId => throw _privateConstructorUsedError;
  String? get checklistId => throw _privateConstructorUsedError;
  String? get groupChatId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get eventSettings =>
      throw _privateConstructorUsedError; // Business-related fields
  String? get businessProfileId => throw _privateConstructorUsedError;
  bool? get isRecurring => throw _privateConstructorUsedError;
  String? get recurringPattern => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String organizerId,
            String title,
            @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
            @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
            String? description,
            String? location,
            String? virtualMeetingUrl,
            List<MeetingParticipant> participants,
            MeetingStatus status,
            @DateTimeConverter() DateTime? createdAt,
            @DateTimeConverter() DateTime? updatedAt,
            String? customFormId,
            String? checklistId,
            String? groupChatId,
            Map<String, dynamic>? eventSettings,
            String? businessProfileId,
            bool? isRecurring,
            String? recurringPattern)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String organizerId,
            String title,
            @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
            @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
            String? description,
            String? location,
            String? virtualMeetingUrl,
            List<MeetingParticipant> participants,
            MeetingStatus status,
            @DateTimeConverter() DateTime? createdAt,
            @DateTimeConverter() DateTime? updatedAt,
            String? customFormId,
            String? checklistId,
            String? groupChatId,
            Map<String, dynamic>? eventSettings,
            String? businessProfileId,
            bool? isRecurring,
            String? recurringPattern)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String organizerId,
            String title,
            @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
            @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
            String? description,
            String? location,
            String? virtualMeetingUrl,
            List<MeetingParticipant> participants,
            MeetingStatus status,
            @DateTimeConverter() DateTime? createdAt,
            @DateTimeConverter() DateTime? updatedAt,
            String? customFormId,
            String? checklistId,
            String? groupChatId,
            Map<String, dynamic>? eventSettings,
            String? businessProfileId,
            bool? isRecurring,
            String? recurringPattern)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeetingCopyWith<Meeting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeetingCopyWith<$Res> {
  factory $MeetingCopyWith(Meeting value, $Res Function(Meeting) then) =
      _$MeetingCopyWithImpl<$Res, Meeting>;
  @useResult
  $Res call(
      {String id,
      String organizerId,
      String title,
      @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
      @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
      String? description,
      String? location,
      String? virtualMeetingUrl,
      List<MeetingParticipant> participants,
      MeetingStatus status,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? updatedAt,
      String? customFormId,
      String? checklistId,
      String? groupChatId,
      Map<String, dynamic>? eventSettings,
      String? businessProfileId,
      bool? isRecurring,
      String? recurringPattern});
}

/// @nodoc
class _$MeetingCopyWithImpl<$Res, $Val extends Meeting>
    implements $MeetingCopyWith<$Res> {
  _$MeetingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizerId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? virtualMeetingUrl = freezed,
    Object? participants = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? customFormId = freezed,
    Object? checklistId = freezed,
    Object? groupChatId = freezed,
    Object? eventSettings = freezed,
    Object? businessProfileId = freezed,
    Object? isRecurring = freezed,
    Object? recurringPattern = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      virtualMeetingUrl: freezed == virtualMeetingUrl
          ? _value.virtualMeetingUrl
          : virtualMeetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MeetingParticipant>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MeetingStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customFormId: freezed == customFormId
          ? _value.customFormId
          : customFormId // ignore: cast_nullable_to_non_nullable
              as String?,
      checklistId: freezed == checklistId
          ? _value.checklistId
          : checklistId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupChatId: freezed == groupChatId
          ? _value.groupChatId
          : groupChatId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventSettings: freezed == eventSettings
          ? _value.eventSettings
          : eventSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      businessProfileId: freezed == businessProfileId
          ? _value.businessProfileId
          : businessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringPattern: freezed == recurringPattern
          ? _value.recurringPattern
          : recurringPattern // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeetingImplCopyWith<$Res> implements $MeetingCopyWith<$Res> {
  factory _$$MeetingImplCopyWith(
          _$MeetingImpl value, $Res Function(_$MeetingImpl) then) =
      __$$MeetingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizerId,
      String title,
      @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
      @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
      String? description,
      String? location,
      String? virtualMeetingUrl,
      List<MeetingParticipant> participants,
      MeetingStatus status,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? updatedAt,
      String? customFormId,
      String? checklistId,
      String? groupChatId,
      Map<String, dynamic>? eventSettings,
      String? businessProfileId,
      bool? isRecurring,
      String? recurringPattern});
}

/// @nodoc
class __$$MeetingImplCopyWithImpl<$Res>
    extends _$MeetingCopyWithImpl<$Res, _$MeetingImpl>
    implements _$$MeetingImplCopyWith<$Res> {
  __$$MeetingImplCopyWithImpl(
      _$MeetingImpl _value, $Res Function(_$MeetingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizerId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? virtualMeetingUrl = freezed,
    Object? participants = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? customFormId = freezed,
    Object? checklistId = freezed,
    Object? groupChatId = freezed,
    Object? eventSettings = freezed,
    Object? businessProfileId = freezed,
    Object? isRecurring = freezed,
    Object? recurringPattern = freezed,
  }) {
    return _then(_$MeetingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      virtualMeetingUrl: freezed == virtualMeetingUrl
          ? _value.virtualMeetingUrl
          : virtualMeetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MeetingParticipant>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MeetingStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customFormId: freezed == customFormId
          ? _value.customFormId
          : customFormId // ignore: cast_nullable_to_non_nullable
              as String?,
      checklistId: freezed == checklistId
          ? _value.checklistId
          : checklistId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupChatId: freezed == groupChatId
          ? _value.groupChatId
          : groupChatId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventSettings: freezed == eventSettings
          ? _value._eventSettings
          : eventSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      businessProfileId: freezed == businessProfileId
          ? _value.businessProfileId
          : businessProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringPattern: freezed == recurringPattern
          ? _value.recurringPattern
          : recurringPattern // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MeetingImpl implements _Meeting {
  const _$MeetingImpl(
      {required this.id,
      required this.organizerId,
      required this.title,
      @DateTimeConverter() @JsonKey(name: 'startTime') required this.startTime,
      @DateTimeConverter() @JsonKey(name: 'endTime') required this.endTime,
      this.description,
      this.location,
      this.virtualMeetingUrl,
      final List<MeetingParticipant> participants =
          const <MeetingParticipant>[],
      this.status = MeetingStatus.draft,
      @DateTimeConverter() this.createdAt,
      @DateTimeConverter() this.updatedAt,
      this.customFormId,
      this.checklistId,
      this.groupChatId,
      final Map<String, dynamic>? eventSettings,
      this.businessProfileId,
      this.isRecurring,
      this.recurringPattern})
      : _participants = participants,
        _eventSettings = eventSettings;

  factory _$MeetingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeetingImplFromJson(json);

  @override
  final String id;
  @override
  final String organizerId;
  @override
  final String title;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'startTime')
  final DateTime startTime;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'endTime')
  final DateTime endTime;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final String? virtualMeetingUrl;
  final List<MeetingParticipant> _participants;
  @override
  @JsonKey()
  List<MeetingParticipant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey()
  final MeetingStatus status;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @DateTimeConverter()
  final DateTime? updatedAt;
// Event-specific features (only available for events)
  @override
  final String? customFormId;
  @override
  final String? checklistId;
  @override
  final String? groupChatId;
  final Map<String, dynamic>? _eventSettings;
  @override
  Map<String, dynamic>? get eventSettings {
    final value = _eventSettings;
    if (value == null) return null;
    if (_eventSettings is EqualUnmodifiableMapView) return _eventSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Business-related fields
  @override
  final String? businessProfileId;
  @override
  final bool? isRecurring;
  @override
  final String? recurringPattern;

  @override
  String toString() {
    return 'Meeting(id: $id, organizerId: $organizerId, title: $title, startTime: $startTime, endTime: $endTime, description: $description, location: $location, virtualMeetingUrl: $virtualMeetingUrl, participants: $participants, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, customFormId: $customFormId, checklistId: $checklistId, groupChatId: $groupChatId, eventSettings: $eventSettings, businessProfileId: $businessProfileId, isRecurring: $isRecurring, recurringPattern: $recurringPattern)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeetingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.virtualMeetingUrl, virtualMeetingUrl) ||
                other.virtualMeetingUrl == virtualMeetingUrl) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.customFormId, customFormId) ||
                other.customFormId == customFormId) &&
            (identical(other.checklistId, checklistId) ||
                other.checklistId == checklistId) &&
            (identical(other.groupChatId, groupChatId) ||
                other.groupChatId == groupChatId) &&
            const DeepCollectionEquality()
                .equals(other._eventSettings, _eventSettings) &&
            (identical(other.businessProfileId, businessProfileId) ||
                other.businessProfileId == businessProfileId) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringPattern, recurringPattern) ||
                other.recurringPattern == recurringPattern));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        organizerId,
        title,
        startTime,
        endTime,
        description,
        location,
        virtualMeetingUrl,
        const DeepCollectionEquality().hash(_participants),
        status,
        createdAt,
        updatedAt,
        customFormId,
        checklistId,
        groupChatId,
        const DeepCollectionEquality().hash(_eventSettings),
        businessProfileId,
        isRecurring,
        recurringPattern
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeetingImplCopyWith<_$MeetingImpl> get copyWith =>
      __$$MeetingImplCopyWithImpl<_$MeetingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String organizerId,
            String title,
            @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
            @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
            String? description,
            String? location,
            String? virtualMeetingUrl,
            List<MeetingParticipant> participants,
            MeetingStatus status,
            @DateTimeConverter() DateTime? createdAt,
            @DateTimeConverter() DateTime? updatedAt,
            String? customFormId,
            String? checklistId,
            String? groupChatId,
            Map<String, dynamic>? eventSettings,
            String? businessProfileId,
            bool? isRecurring,
            String? recurringPattern)
        $default,
  ) {
    return $default(
        id,
        organizerId,
        title,
        startTime,
        endTime,
        description,
        location,
        virtualMeetingUrl,
        participants,
        status,
        createdAt,
        updatedAt,
        customFormId,
        checklistId,
        groupChatId,
        eventSettings,
        businessProfileId,
        isRecurring,
        recurringPattern);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String organizerId,
            String title,
            @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
            @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
            String? description,
            String? location,
            String? virtualMeetingUrl,
            List<MeetingParticipant> participants,
            MeetingStatus status,
            @DateTimeConverter() DateTime? createdAt,
            @DateTimeConverter() DateTime? updatedAt,
            String? customFormId,
            String? checklistId,
            String? groupChatId,
            Map<String, dynamic>? eventSettings,
            String? businessProfileId,
            bool? isRecurring,
            String? recurringPattern)?
        $default,
  ) {
    return $default?.call(
        id,
        organizerId,
        title,
        startTime,
        endTime,
        description,
        location,
        virtualMeetingUrl,
        participants,
        status,
        createdAt,
        updatedAt,
        customFormId,
        checklistId,
        groupChatId,
        eventSettings,
        businessProfileId,
        isRecurring,
        recurringPattern);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String organizerId,
            String title,
            @DateTimeConverter() @JsonKey(name: 'startTime') DateTime startTime,
            @DateTimeConverter() @JsonKey(name: 'endTime') DateTime endTime,
            String? description,
            String? location,
            String? virtualMeetingUrl,
            List<MeetingParticipant> participants,
            MeetingStatus status,
            @DateTimeConverter() DateTime? createdAt,
            @DateTimeConverter() DateTime? updatedAt,
            String? customFormId,
            String? checklistId,
            String? groupChatId,
            Map<String, dynamic>? eventSettings,
            String? businessProfileId,
            bool? isRecurring,
            String? recurringPattern)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          organizerId,
          title,
          startTime,
          endTime,
          description,
          location,
          virtualMeetingUrl,
          participants,
          status,
          createdAt,
          updatedAt,
          customFormId,
          checklistId,
          groupChatId,
          eventSettings,
          businessProfileId,
          isRecurring,
          recurringPattern);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MeetingImplToJson(
      this,
    );
  }
}

abstract class _Meeting implements Meeting {
  const factory _Meeting(
      {required final String id,
      required final String organizerId,
      required final String title,
      @DateTimeConverter()
      @JsonKey(name: 'startTime')
      required final DateTime startTime,
      @DateTimeConverter()
      @JsonKey(name: 'endTime')
      required final DateTime endTime,
      final String? description,
      final String? location,
      final String? virtualMeetingUrl,
      final List<MeetingParticipant> participants,
      final MeetingStatus status,
      @DateTimeConverter() final DateTime? createdAt,
      @DateTimeConverter() final DateTime? updatedAt,
      final String? customFormId,
      final String? checklistId,
      final String? groupChatId,
      final Map<String, dynamic>? eventSettings,
      final String? businessProfileId,
      final bool? isRecurring,
      final String? recurringPattern}) = _$MeetingImpl;

  factory _Meeting.fromJson(Map<String, dynamic> json) = _$MeetingImpl.fromJson;

  @override
  String get id;
  @override
  String get organizerId;
  @override
  String get title;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'startTime')
  DateTime get startTime;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'endTime')
  DateTime get endTime;
  @override
  String? get description;
  @override
  String? get location;
  @override
  String? get virtualMeetingUrl;
  @override
  List<MeetingParticipant> get participants;
  @override
  MeetingStatus get status;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  @DateTimeConverter()
  DateTime? get updatedAt;
  @override // Event-specific features (only available for events)
  String? get customFormId;
  @override
  String? get checklistId;
  @override
  String? get groupChatId;
  @override
  Map<String, dynamic>? get eventSettings;
  @override // Business-related fields
  String? get businessProfileId;
  @override
  bool? get isRecurring;
  @override
  String? get recurringPattern;
  @override
  @JsonKey(ignore: true)
  _$$MeetingImplCopyWith<_$MeetingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
