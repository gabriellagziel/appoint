// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, REDACTED_TOKEN, REDACTED_TOKEN, unnecessary_const, avoid_init_to_null, REDACTED_TOKEN, REDACTED_TOKEN, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_form_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#REDACTED_TOKEN');

CustomFormField _$CustomFormFieldFromJson(Map<String, dynamic> json) {
  return _CustomFormField.fromJson(json);
}

/// @nodoc
mixin _$CustomFormField {
  String get id => throw _privateConstructorUsedError;
  CustomFormFieldType get type => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;
  String? get defaultValue => throw _privateConstructorUsedError;
  List<String>? get options =>
      throw _privateConstructorUsedError; // for choice and multiselect
  int? get minValue =>
      throw _privateConstructorUsedError; // for number and rating
  int? get maxValue =>
      throw _privateConstructorUsedError; // for number and rating
  int? get minLength => throw _privateConstructorUsedError; // for text fields
  int? get maxLength => throw _privateConstructorUsedError; // for text fields
  String? get validationPattern =>
      throw _privateConstructorUsedError; // regex for validation
  String? get validationMessage => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            CustomFormFieldType type,
            String label,
            int order,
            bool required,
            String? description,
            String? placeholder,
            String? defaultValue,
            List<String>? options,
            int? minValue,
            int? maxValue,
            int? minLength,
            int? maxLength,
            String? validationPattern,
            String? validationMessage)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            CustomFormFieldType type,
            String label,
            int order,
            bool required,
            String? description,
            String? placeholder,
            String? defaultValue,
            List<String>? options,
            int? minValue,
            int? maxValue,
            int? minLength,
            int? maxLength,
            String? validationPattern,
            String? validationMessage)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            CustomFormFieldType type,
            String label,
            int order,
            bool required,
            String? description,
            String? placeholder,
            String? defaultValue,
            List<String>? options,
            int? minValue,
            int? maxValue,
            int? minLength,
            int? maxLength,
            String? validationPattern,
            String? validationMessage)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomFormFieldCopyWith<CustomFormField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomFormFieldCopyWith<$Res> {
  factory $CustomFormFieldCopyWith(
          CustomFormField value, $Res Function(CustomFormField) then) =
      _$CustomFormFieldCopyWithImpl<$Res, CustomFormField>;
  @useResult
  $Res call(
      {String id,
      CustomFormFieldType type,
      String label,
      int order,
      bool required,
      String? description,
      String? placeholder,
      String? defaultValue,
      List<String>? options,
      int? minValue,
      int? maxValue,
      int? minLength,
      int? maxLength,
      String? validationPattern,
      String? validationMessage});
}

/// @nodoc
class _$CustomFormFieldCopyWithImpl<$Res, $Val extends CustomFormField>
    implements $CustomFormFieldCopyWith<$Res> {
  _$CustomFormFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? label = null,
    Object? order = null,
    Object? required = null,
    Object? description = freezed,
    Object? placeholder = freezed,
    Object? defaultValue = freezed,
    Object? options = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? minLength = freezed,
    Object? maxLength = freezed,
    Object? validationPattern = freezed,
    Object? validationMessage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CustomFormFieldType,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      minValue: freezed == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as int?,
      maxValue: freezed == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as int?,
      minLength: freezed == minLength
          ? _value.minLength
          : minLength // ignore: cast_nullable_to_non_nullable
              as int?,
      maxLength: freezed == maxLength
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int?,
      validationPattern: freezed == validationPattern
          ? _value.validationPattern
          : validationPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      validationMessage: freezed == validationMessage
          ? _value.validationMessage
          : validationMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomFormFieldImplCopyWith<$Res>
    implements $CustomFormFieldCopyWith<$Res> {
  factory _$$CustomFormFieldImplCopyWith(_$CustomFormFieldImpl value,
          $Res Function(_$CustomFormFieldImpl) then) =
      __$$CustomFormFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      CustomFormFieldType type,
      String label,
      int order,
      bool required,
      String? description,
      String? placeholder,
      String? defaultValue,
      List<String>? options,
      int? minValue,
      int? maxValue,
      int? minLength,
      int? maxLength,
      String? validationPattern,
      String? validationMessage});
}

/// @nodoc
class __$$CustomFormFieldImplCopyWithImpl<$Res>
    extends _$CustomFormFieldCopyWithImpl<$Res, _$CustomFormFieldImpl>
    implements _$$CustomFormFieldImplCopyWith<$Res> {
  __$$CustomFormFieldImplCopyWithImpl(
      _$CustomFormFieldImpl _value, $Res Function(_$CustomFormFieldImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? label = null,
    Object? order = null,
    Object? required = null,
    Object? description = freezed,
    Object? placeholder = freezed,
    Object? defaultValue = freezed,
    Object? options = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? minLength = freezed,
    Object? maxLength = freezed,
    Object? validationPattern = freezed,
    Object? validationMessage = freezed,
  }) {
    return _then(_$CustomFormFieldImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CustomFormFieldType,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      minValue: freezed == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as int?,
      maxValue: freezed == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as int?,
      minLength: freezed == minLength
          ? _value.minLength
          : minLength // ignore: cast_nullable_to_non_nullable
              as int?,
      maxLength: freezed == maxLength
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int?,
      validationPattern: freezed == validationPattern
          ? _value.validationPattern
          : validationPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      validationMessage: freezed == validationMessage
          ? _value.validationMessage
          : validationMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomFormFieldImpl implements _CustomFormField {
  const _$CustomFormFieldImpl(
      {required this.id,
      required this.type,
      required this.label,
      required this.order,
      this.required = false,
      this.description,
      this.placeholder,
      this.defaultValue,
      final List<String>? options,
      this.minValue,
      this.maxValue,
      this.minLength,
      this.maxLength,
      this.validationPattern,
      this.validationMessage})
      : _options = options;

  factory _$CustomFormFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomFormFieldImplFromJson(json);

  @override
  final String id;
  @override
  final CustomFormFieldType type;
  @override
  final String label;
  @override
  final int order;
  @override
  @JsonKey()
  final bool required;
  @override
  final String? description;
  @override
  final String? placeholder;
  @override
  final String? defaultValue;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// for choice and multiselect
  @override
  final int? minValue;
// for number and rating
  @override
  final int? maxValue;
// for number and rating
  @override
  final int? minLength;
// for text fields
  @override
  final int? maxLength;
// for text fields
  @override
  final String? validationPattern;
// regex for validation
  @override
  final String? validationMessage;

  @override
  String toString() {
    return 'CustomFormField(id: $id, type: $type, label: $label, order: $order, required: $required, description: $description, placeholder: $placeholder, defaultValue: $defaultValue, options: $options, minValue: $minValue, maxValue: $maxValue, minLength: $minLength, maxLength: $maxLength, validationPattern: $validationPattern, validationMessage: $validationMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomFormFieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.minLength, minLength) ||
                other.minLength == minLength) &&
            (identical(other.maxLength, maxLength) ||
                other.maxLength == maxLength) &&
            (identical(other.validationPattern, validationPattern) ||
                other.validationPattern == validationPattern) &&
            (identical(other.validationMessage, validationMessage) ||
                other.validationMessage == validationMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      label,
      order,
      required,
      description,
      placeholder,
      defaultValue,
      const DeepCollectionEquality().hash(_options),
      minValue,
      maxValue,
      minLength,
      maxLength,
      validationPattern,
      validationMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomFormFieldImplCopyWith<_$CustomFormFieldImpl> get copyWith =>
      __$$CustomFormFieldImplCopyWithImpl<_$CustomFormFieldImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            CustomFormFieldType type,
            String label,
            int order,
            bool required,
            String? description,
            String? placeholder,
            String? defaultValue,
            List<String>? options,
            int? minValue,
            int? maxValue,
            int? minLength,
            int? maxLength,
            String? validationPattern,
            String? validationMessage)
        $default,
  ) {
    return $default(
        id,
        type,
        label,
        order,
        required,
        description,
        placeholder,
        defaultValue,
        options,
        minValue,
        maxValue,
        minLength,
        maxLength,
        validationPattern,
        validationMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            CustomFormFieldType type,
            String label,
            int order,
            bool required,
            String? description,
            String? placeholder,
            String? defaultValue,
            List<String>? options,
            int? minValue,
            int? maxValue,
            int? minLength,
            int? maxLength,
            String? validationPattern,
            String? validationMessage)?
        $default,
  ) {
    return $default?.call(
        id,
        type,
        label,
        order,
        required,
        description,
        placeholder,
        defaultValue,
        options,
        minValue,
        maxValue,
        minLength,
        maxLength,
        validationPattern,
        validationMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            CustomFormFieldType type,
            String label,
            int order,
            bool required,
            String? description,
            String? placeholder,
            String? defaultValue,
            List<String>? options,
            int? minValue,
            int? maxValue,
            int? minLength,
            int? maxLength,
            String? validationPattern,
            String? validationMessage)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          type,
          label,
          order,
          required,
          description,
          placeholder,
          defaultValue,
          options,
          minValue,
          maxValue,
          minLength,
          maxLength,
          validationPattern,
          validationMessage);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomFormFieldImplToJson(
      this,
    );
  }
}

abstract class _CustomFormField implements CustomFormField {
  const factory _CustomFormField(
      {required final String id,
      required final CustomFormFieldType type,
      required final String label,
      required final int order,
      final bool required,
      final String? description,
      final String? placeholder,
      final String? defaultValue,
      final List<String>? options,
      final int? minValue,
      final int? maxValue,
      final int? minLength,
      final int? maxLength,
      final String? validationPattern,
      final String? validationMessage}) = _$CustomFormFieldImpl;

  factory _CustomFormField.fromJson(Map<String, dynamic> json) =
      _$CustomFormFieldImpl.fromJson;

  @override
  String get id;
  @override
  CustomFormFieldType get type;
  @override
  String get label;
  @override
  int get order;
  @override
  bool get required;
  @override
  String? get description;
  @override
  String? get placeholder;
  @override
  String? get defaultValue;
  @override
  List<String>? get options;
  @override // for choice and multiselect
  int? get minValue;
  @override // for number and rating
  int? get maxValue;
  @override // for number and rating
  int? get minLength;
  @override // for text fields
  int? get maxLength;
  @override // for text fields
  String? get validationPattern;
  @override // regex for validation
  String? get validationMessage;
  @override
  @JsonKey(ignore: true)
  _$$CustomFormFieldImplCopyWith<_$CustomFormFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FormResponse _$FormResponseFromJson(Map<String, dynamic> json) {
  return _FormResponse.fromJson(json);
}

/// @nodoc
mixin _$FormResponse {
  String get id => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  Map<String, dynamic> get responses =>
      throw _privateConstructorUsedError; // fieldId -> response value
  DateTime get submittedAt => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;
  Map<String, String>? get metadata => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String messageId,
            String userId,
            String userName,
            Map<String, dynamic> responses,
            DateTime submittedAt,
            String? userEmail,
            Map<String, String>? metadata)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String messageId,
            String userId,
            String userName,
            Map<String, dynamic> responses,
            DateTime submittedAt,
            String? userEmail,
            Map<String, String>? metadata)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String messageId,
            String userId,
            String userName,
            Map<String, dynamic> responses,
            DateTime submittedAt,
            String? userEmail,
            Map<String, String>? metadata)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormResponseCopyWith<FormResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormResponseCopyWith<$Res> {
  factory $FormResponseCopyWith(
          FormResponse value, $Res Function(FormResponse) then) =
      _$FormResponseCopyWithImpl<$Res, FormResponse>;
  @useResult
  $Res call(
      {String id,
      String messageId,
      String userId,
      String userName,
      Map<String, dynamic> responses,
      DateTime submittedAt,
      String? userEmail,
      Map<String, String>? metadata});
}

/// @nodoc
class _$FormResponseCopyWithImpl<$Res, $Val extends FormResponse>
    implements $FormResponseCopyWith<$Res> {
  _$FormResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messageId = null,
    Object? userId = null,
    Object? userName = null,
    Object? responses = null,
    Object? submittedAt = null,
    Object? userEmail = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      responses: null == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormResponseImplCopyWith<$Res>
    implements $FormResponseCopyWith<$Res> {
  factory _$$FormResponseImplCopyWith(
          _$FormResponseImpl value, $Res Function(_$FormResponseImpl) then) =
      __$$FormResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String messageId,
      String userId,
      String userName,
      Map<String, dynamic> responses,
      DateTime submittedAt,
      String? userEmail,
      Map<String, String>? metadata});
}

/// @nodoc
class __$$FormResponseImplCopyWithImpl<$Res>
    extends _$FormResponseCopyWithImpl<$Res, _$FormResponseImpl>
    implements _$$FormResponseImplCopyWith<$Res> {
  __$$FormResponseImplCopyWithImpl(
      _$FormResponseImpl _value, $Res Function(_$FormResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messageId = null,
    Object? userId = null,
    Object? userName = null,
    Object? responses = null,
    Object? submittedAt = null,
    Object? userEmail = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$FormResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      responses: null == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormResponseImpl implements _FormResponse {
  const _$FormResponseImpl(
      {required this.id,
      required this.messageId,
      required this.userId,
      required this.userName,
      required final Map<String, dynamic> responses,
      required this.submittedAt,
      this.userEmail,
      final Map<String, String>? metadata})
      : _responses = responses,
        _metadata = metadata;

  factory _$FormResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String messageId;
  @override
  final String userId;
  @override
  final String userName;
  final Map<String, dynamic> _responses;
  @override
  Map<String, dynamic> get responses {
    if (_responses is EqualUnmodifiableMapView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_responses);
  }

// fieldId -> response value
  @override
  final DateTime submittedAt;
  @override
  final String? userEmail;
  final Map<String, String>? _metadata;
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FormResponse(id: $id, messageId: $messageId, userId: $userId, userName: $userName, responses: $responses, submittedAt: $submittedAt, userEmail: $userEmail, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      messageId,
      userId,
      userName,
      const DeepCollectionEquality().hash(_responses),
      submittedAt,
      userEmail,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormResponseImplCopyWith<_$FormResponseImpl> get copyWith =>
      __$$FormResponseImplCopyWithImpl<_$FormResponseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String messageId,
            String userId,
            String userName,
            Map<String, dynamic> responses,
            DateTime submittedAt,
            String? userEmail,
            Map<String, String>? metadata)
        $default,
  ) {
    return $default(id, messageId, userId, userName, responses, submittedAt,
        userEmail, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String messageId,
            String userId,
            String userName,
            Map<String, dynamic> responses,
            DateTime submittedAt,
            String? userEmail,
            Map<String, String>? metadata)?
        $default,
  ) {
    return $default?.call(id, messageId, userId, userName, responses,
        submittedAt, userEmail, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String messageId,
            String userId,
            String userName,
            Map<String, dynamic> responses,
            DateTime submittedAt,
            String? userEmail,
            Map<String, String>? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, messageId, userId, userName, responses, submittedAt,
          userEmail, metadata);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FormResponseImplToJson(
      this,
    );
  }
}

abstract class _FormResponse implements FormResponse {
  const factory _FormResponse(
      {required final String id,
      required final String messageId,
      required final String userId,
      required final String userName,
      required final Map<String, dynamic> responses,
      required final DateTime submittedAt,
      final String? userEmail,
      final Map<String, String>? metadata}) = _$FormResponseImpl;

  factory _FormResponse.fromJson(Map<String, dynamic> json) =
      _$FormResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get messageId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  Map<String, dynamic> get responses;
  @override // fieldId -> response value
  DateTime get submittedAt;
  @override
  String? get userEmail;
  @override
  Map<String, String>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$FormResponseImplCopyWith<_$FormResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FormFieldStatistics _$FormFieldStatisticsFromJson(Map<String, dynamic> json) {
  return _FormFieldStatistics.fromJson(json);
}

/// @nodoc
mixin _$FormFieldStatistics {
  String get fieldId => throw _privateConstructorUsedError;
  String get fieldLabel => throw _privateConstructorUsedError;
  CustomFormFieldType get fieldType => throw _privateConstructorUsedError;
  int get totalResponses => throw _privateConstructorUsedError;
  int get validResponses => throw _privateConstructorUsedError;
  double? get averageValue =>
      throw _privateConstructorUsedError; // for numeric fields
  String? get mostCommonValue => throw _privateConstructorUsedError;
  Map<String, int>? get choiceDistribution =>
      throw _privateConstructorUsedError; // for choice fields
  List<String>? get allResponses => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String fieldId,
            String fieldLabel,
            CustomFormFieldType fieldType,
            int totalResponses,
            int validResponses,
            double? averageValue,
            String? mostCommonValue,
            Map<String, int>? choiceDistribution,
            List<String>? allResponses)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String fieldId,
            String fieldLabel,
            CustomFormFieldType fieldType,
            int totalResponses,
            int validResponses,
            double? averageValue,
            String? mostCommonValue,
            Map<String, int>? choiceDistribution,
            List<String>? allResponses)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String fieldId,
            String fieldLabel,
            CustomFormFieldType fieldType,
            int totalResponses,
            int validResponses,
            double? averageValue,
            String? mostCommonValue,
            Map<String, int>? choiceDistribution,
            List<String>? allResponses)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormFieldStatisticsCopyWith<FormFieldStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormFieldStatisticsCopyWith<$Res> {
  factory $FormFieldStatisticsCopyWith(
          FormFieldStatistics value, $Res Function(FormFieldStatistics) then) =
      _$FormFieldStatisticsCopyWithImpl<$Res, FormFieldStatistics>;
  @useResult
  $Res call(
      {String fieldId,
      String fieldLabel,
      CustomFormFieldType fieldType,
      int totalResponses,
      int validResponses,
      double? averageValue,
      String? mostCommonValue,
      Map<String, int>? choiceDistribution,
      List<String>? allResponses});
}

/// @nodoc
class _$FormFieldStatisticsCopyWithImpl<$Res, $Val extends FormFieldStatistics>
    implements $FormFieldStatisticsCopyWith<$Res> {
  _$FormFieldStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldId = null,
    Object? fieldLabel = null,
    Object? fieldType = null,
    Object? totalResponses = null,
    Object? validResponses = null,
    Object? averageValue = freezed,
    Object? mostCommonValue = freezed,
    Object? choiceDistribution = freezed,
    Object? allResponses = freezed,
  }) {
    return _then(_value.copyWith(
      fieldId: null == fieldId
          ? _value.fieldId
          : fieldId // ignore: cast_nullable_to_non_nullable
              as String,
      fieldLabel: null == fieldLabel
          ? _value.fieldLabel
          : fieldLabel // ignore: cast_nullable_to_non_nullable
              as String,
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as CustomFormFieldType,
      totalResponses: null == totalResponses
          ? _value.totalResponses
          : totalResponses // ignore: cast_nullable_to_non_nullable
              as int,
      validResponses: null == validResponses
          ? _value.validResponses
          : validResponses // ignore: cast_nullable_to_non_nullable
              as int,
      averageValue: freezed == averageValue
          ? _value.averageValue
          : averageValue // ignore: cast_nullable_to_non_nullable
              as double?,
      mostCommonValue: freezed == mostCommonValue
          ? _value.mostCommonValue
          : mostCommonValue // ignore: cast_nullable_to_non_nullable
              as String?,
      choiceDistribution: freezed == choiceDistribution
          ? _value.choiceDistribution
          : choiceDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      allResponses: freezed == allResponses
          ? _value.allResponses
          : allResponses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormFieldStatisticsImplCopyWith<$Res>
    implements $FormFieldStatisticsCopyWith<$Res> {
  factory _$$FormFieldStatisticsImplCopyWith(_$FormFieldStatisticsImpl value,
          $Res Function(_$FormFieldStatisticsImpl) then) =
      __$$REDACTED_TOKEN<$Res>;
  @override
  @useResult
  $Res call(
      {String fieldId,
      String fieldLabel,
      CustomFormFieldType fieldType,
      int totalResponses,
      int validResponses,
      double? averageValue,
      String? mostCommonValue,
      Map<String, int>? choiceDistribution,
      List<String>? allResponses});
}

/// @nodoc
class __$$REDACTED_TOKEN<$Res>
    extends _$FormFieldStatisticsCopyWithImpl<$Res, _$FormFieldStatisticsImpl>
    implements _$$FormFieldStatisticsImplCopyWith<$Res> {
  __$$REDACTED_TOKEN(_$FormFieldStatisticsImpl _value,
      $Res Function(_$FormFieldStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldId = null,
    Object? fieldLabel = null,
    Object? fieldType = null,
    Object? totalResponses = null,
    Object? validResponses = null,
    Object? averageValue = freezed,
    Object? mostCommonValue = freezed,
    Object? choiceDistribution = freezed,
    Object? allResponses = freezed,
  }) {
    return _then(_$FormFieldStatisticsImpl(
      fieldId: null == fieldId
          ? _value.fieldId
          : fieldId // ignore: cast_nullable_to_non_nullable
              as String,
      fieldLabel: null == fieldLabel
          ? _value.fieldLabel
          : fieldLabel // ignore: cast_nullable_to_non_nullable
              as String,
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as CustomFormFieldType,
      totalResponses: null == totalResponses
          ? _value.totalResponses
          : totalResponses // ignore: cast_nullable_to_non_nullable
              as int,
      validResponses: null == validResponses
          ? _value.validResponses
          : validResponses // ignore: cast_nullable_to_non_nullable
              as int,
      averageValue: freezed == averageValue
          ? _value.averageValue
          : averageValue // ignore: cast_nullable_to_non_nullable
              as double?,
      mostCommonValue: freezed == mostCommonValue
          ? _value.mostCommonValue
          : mostCommonValue // ignore: cast_nullable_to_non_nullable
              as String?,
      choiceDistribution: freezed == choiceDistribution
          ? _value._choiceDistribution
          : choiceDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      allResponses: freezed == allResponses
          ? _value._allResponses
          : allResponses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormFieldStatisticsImpl implements _FormFieldStatistics {
  const _$FormFieldStatisticsImpl(
      {required this.fieldId,
      required this.fieldLabel,
      required this.fieldType,
      required this.totalResponses,
      required this.validResponses,
      this.averageValue,
      this.mostCommonValue,
      final Map<String, int>? choiceDistribution,
      final List<String>? allResponses})
      : _choiceDistribution = choiceDistribution,
        _allResponses = allResponses;

  factory _$FormFieldStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormFieldStatisticsImplFromJson(json);

  @override
  final String fieldId;
  @override
  final String fieldLabel;
  @override
  final CustomFormFieldType fieldType;
  @override
  final int totalResponses;
  @override
  final int validResponses;
  @override
  final double? averageValue;
// for numeric fields
  @override
  final String? mostCommonValue;
  final Map<String, int>? _choiceDistribution;
  @override
  Map<String, int>? get choiceDistribution {
    final value = _choiceDistribution;
    if (value == null) return null;
    if (_choiceDistribution is EqualUnmodifiableMapView)
      return _choiceDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// for choice fields
  final List<String>? _allResponses;
// for choice fields
  @override
  List<String>? get allResponses {
    final value = _allResponses;
    if (value == null) return null;
    if (_allResponses is EqualUnmodifiableListView) return _allResponses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FormFieldStatistics(fieldId: $fieldId, fieldLabel: $fieldLabel, fieldType: $fieldType, totalResponses: $totalResponses, validResponses: $validResponses, averageValue: $averageValue, mostCommonValue: $mostCommonValue, choiceDistribution: $choiceDistribution, allResponses: $allResponses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormFieldStatisticsImpl &&
            (identical(other.fieldId, fieldId) || other.fieldId == fieldId) &&
            (identical(other.fieldLabel, fieldLabel) ||
                other.fieldLabel == fieldLabel) &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            (identical(other.totalResponses, totalResponses) ||
                other.totalResponses == totalResponses) &&
            (identical(other.validResponses, validResponses) ||
                other.validResponses == validResponses) &&
            (identical(other.averageValue, averageValue) ||
                other.averageValue == averageValue) &&
            (identical(other.mostCommonValue, mostCommonValue) ||
                other.mostCommonValue == mostCommonValue) &&
            const DeepCollectionEquality()
                .equals(other._choiceDistribution, _choiceDistribution) &&
            const DeepCollectionEquality()
                .equals(other._allResponses, _allResponses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fieldId,
      fieldLabel,
      fieldType,
      totalResponses,
      validResponses,
      averageValue,
      mostCommonValue,
      const DeepCollectionEquality().hash(_choiceDistribution),
      const DeepCollectionEquality().hash(_allResponses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormFieldStatisticsImplCopyWith<_$FormFieldStatisticsImpl> get copyWith =>
      __$$REDACTED_TOKEN<_$FormFieldStatisticsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String fieldId,
            String fieldLabel,
            CustomFormFieldType fieldType,
            int totalResponses,
            int validResponses,
            double? averageValue,
            String? mostCommonValue,
            Map<String, int>? choiceDistribution,
            List<String>? allResponses)
        $default,
  ) {
    return $default(
        fieldId,
        fieldLabel,
        fieldType,
        totalResponses,
        validResponses,
        averageValue,
        mostCommonValue,
        choiceDistribution,
        allResponses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String fieldId,
            String fieldLabel,
            CustomFormFieldType fieldType,
            int totalResponses,
            int validResponses,
            double? averageValue,
            String? mostCommonValue,
            Map<String, int>? choiceDistribution,
            List<String>? allResponses)?
        $default,
  ) {
    return $default?.call(
        fieldId,
        fieldLabel,
        fieldType,
        totalResponses,
        validResponses,
        averageValue,
        mostCommonValue,
        choiceDistribution,
        allResponses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String fieldId,
            String fieldLabel,
            CustomFormFieldType fieldType,
            int totalResponses,
            int validResponses,
            double? averageValue,
            String? mostCommonValue,
            Map<String, int>? choiceDistribution,
            List<String>? allResponses)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          fieldId,
          fieldLabel,
          fieldType,
          totalResponses,
          validResponses,
          averageValue,
          mostCommonValue,
          choiceDistribution,
          allResponses);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FormFieldStatisticsImplToJson(
      this,
    );
  }
}

abstract class _FormFieldStatistics implements FormFieldStatistics {
  const factory _FormFieldStatistics(
      {required final String fieldId,
      required final String fieldLabel,
      required final CustomFormFieldType fieldType,
      required final int totalResponses,
      required final int validResponses,
      final double? averageValue,
      final String? mostCommonValue,
      final Map<String, int>? choiceDistribution,
      final List<String>? allResponses}) = _$FormFieldStatisticsImpl;

  factory _FormFieldStatistics.fromJson(Map<String, dynamic> json) =
      _$FormFieldStatisticsImpl.fromJson;

  @override
  String get fieldId;
  @override
  String get fieldLabel;
  @override
  CustomFormFieldType get fieldType;
  @override
  int get totalResponses;
  @override
  int get validResponses;
  @override
  double? get averageValue;
  @override // for numeric fields
  String? get mostCommonValue;
  @override
  Map<String, int>? get choiceDistribution;
  @override // for choice fields
  List<String>? get allResponses;
  @override
  @JsonKey(ignore: true)
  _$$FormFieldStatisticsImplCopyWith<_$FormFieldStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
