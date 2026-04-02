// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_announcement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomFieldDefinitionModel _$CustomFieldDefinitionModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomFieldDefinitionModel.fromJson(json);
}

/// @nodoc
mixin _$CustomFieldDefinitionModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CustomFieldType get type => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  List<String>? get options => throw _privateConstructorUsedError;

  /// Serializes this CustomFieldDefinitionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomFieldDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomFieldDefinitionModelCopyWith<CustomFieldDefinitionModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomFieldDefinitionModelCopyWith<$Res> {
  factory $CustomFieldDefinitionModelCopyWith(
    CustomFieldDefinitionModel value,
    $Res Function(CustomFieldDefinitionModel) then,
  ) =
      _$CustomFieldDefinitionModelCopyWithImpl<
        $Res,
        CustomFieldDefinitionModel
      >;
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    CustomFieldType type,
    bool isRequired,
    List<String>? options,
  });
}

/// @nodoc
class _$CustomFieldDefinitionModelCopyWithImpl<
  $Res,
  $Val extends CustomFieldDefinitionModel
>
    implements $CustomFieldDefinitionModelCopyWith<$Res> {
  _$CustomFieldDefinitionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomFieldDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? type = null,
    Object? isRequired = null,
    Object? options = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CustomFieldType,
            isRequired: null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomFieldDefinitionModelImplCopyWith<$Res>
    implements $CustomFieldDefinitionModelCopyWith<$Res> {
  factory _$$CustomFieldDefinitionModelImplCopyWith(
    _$CustomFieldDefinitionModelImpl value,
    $Res Function(_$CustomFieldDefinitionModelImpl) then,
  ) = __$$CustomFieldDefinitionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    CustomFieldType type,
    bool isRequired,
    List<String>? options,
  });
}

/// @nodoc
class __$$CustomFieldDefinitionModelImplCopyWithImpl<$Res>
    extends
        _$CustomFieldDefinitionModelCopyWithImpl<
          $Res,
          _$CustomFieldDefinitionModelImpl
        >
    implements _$$CustomFieldDefinitionModelImplCopyWith<$Res> {
  __$$CustomFieldDefinitionModelImplCopyWithImpl(
    _$CustomFieldDefinitionModelImpl _value,
    $Res Function(_$CustomFieldDefinitionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomFieldDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? type = null,
    Object? isRequired = null,
    Object? options = freezed,
  }) {
    return _then(
      _$CustomFieldDefinitionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CustomFieldType,
        isRequired: null == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomFieldDefinitionModelImpl implements _CustomFieldDefinitionModel {
  const _$CustomFieldDefinitionModelImpl({
    required this.id,
    required this.eventId,
    required this.name,
    required this.type,
    this.isRequired = false,
    final List<String>? options,
  }) : _options = options;

  factory _$CustomFieldDefinitionModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomFieldDefinitionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String name;
  @override
  final CustomFieldType type;
  @override
  @JsonKey()
  final bool isRequired;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CustomFieldDefinitionModel(id: $id, eventId: $eventId, name: $name, type: $type, isRequired: $isRequired, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomFieldDefinitionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    name,
    type,
    isRequired,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of CustomFieldDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomFieldDefinitionModelImplCopyWith<_$CustomFieldDefinitionModelImpl>
  get copyWith =>
      __$$CustomFieldDefinitionModelImplCopyWithImpl<
        _$CustomFieldDefinitionModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomFieldDefinitionModelImplToJson(this);
  }
}

abstract class _CustomFieldDefinitionModel
    implements CustomFieldDefinitionModel {
  const factory _CustomFieldDefinitionModel({
    required final String id,
    required final String eventId,
    required final String name,
    required final CustomFieldType type,
    final bool isRequired,
    final List<String>? options,
  }) = _$CustomFieldDefinitionModelImpl;

  factory _CustomFieldDefinitionModel.fromJson(Map<String, dynamic> json) =
      _$CustomFieldDefinitionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get name;
  @override
  CustomFieldType get type;
  @override
  bool get isRequired;
  @override
  List<String>? get options;

  /// Create a copy of CustomFieldDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomFieldDefinitionModelImplCopyWith<_$CustomFieldDefinitionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) {
  return _AnnouncementModel.fromJson(json);
}

/// @nodoc
mixin _$AnnouncementModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  AnnouncementCategory get category => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get postedBy => throw _privateConstructorUsedError;
  bool get sendNotification => throw _privateConstructorUsedError;

  /// Serializes this AnnouncementModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnnouncementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnnouncementModelCopyWith<AnnouncementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnnouncementModelCopyWith<$Res> {
  factory $AnnouncementModelCopyWith(
    AnnouncementModel value,
    $Res Function(AnnouncementModel) then,
  ) = _$AnnouncementModelCopyWithImpl<$Res, AnnouncementModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    String message,
    AnnouncementCategory category,
    DateTime createdAt,
    String postedBy,
    bool sendNotification,
  });
}

/// @nodoc
class _$AnnouncementModelCopyWithImpl<$Res, $Val extends AnnouncementModel>
    implements $AnnouncementModelCopyWith<$Res> {
  _$AnnouncementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnnouncementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? message = null,
    Object? category = null,
    Object? createdAt = null,
    Object? postedBy = null,
    Object? sendNotification = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as AnnouncementCategory,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            postedBy: null == postedBy
                ? _value.postedBy
                : postedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            sendNotification: null == sendNotification
                ? _value.sendNotification
                : sendNotification // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnnouncementModelImplCopyWith<$Res>
    implements $AnnouncementModelCopyWith<$Res> {
  factory _$$AnnouncementModelImplCopyWith(
    _$AnnouncementModelImpl value,
    $Res Function(_$AnnouncementModelImpl) then,
  ) = __$$AnnouncementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    String message,
    AnnouncementCategory category,
    DateTime createdAt,
    String postedBy,
    bool sendNotification,
  });
}

/// @nodoc
class __$$AnnouncementModelImplCopyWithImpl<$Res>
    extends _$AnnouncementModelCopyWithImpl<$Res, _$AnnouncementModelImpl>
    implements _$$AnnouncementModelImplCopyWith<$Res> {
  __$$AnnouncementModelImplCopyWithImpl(
    _$AnnouncementModelImpl _value,
    $Res Function(_$AnnouncementModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnnouncementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? message = null,
    Object? category = null,
    Object? createdAt = null,
    Object? postedBy = null,
    Object? sendNotification = null,
  }) {
    return _then(
      _$AnnouncementModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as AnnouncementCategory,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        postedBy: null == postedBy
            ? _value.postedBy
            : postedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        sendNotification: null == sendNotification
            ? _value.sendNotification
            : sendNotification // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnnouncementModelImpl implements _AnnouncementModel {
  const _$AnnouncementModelImpl({
    required this.id,
    required this.eventId,
    required this.title,
    required this.message,
    required this.category,
    required this.createdAt,
    required this.postedBy,
    this.sendNotification = true,
  });

  factory _$AnnouncementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnnouncementModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String title;
  @override
  final String message;
  @override
  final AnnouncementCategory category;
  @override
  final DateTime createdAt;
  @override
  final String postedBy;
  @override
  @JsonKey()
  final bool sendNotification;

  @override
  String toString() {
    return 'AnnouncementModel(id: $id, eventId: $eventId, title: $title, message: $message, category: $category, createdAt: $createdAt, postedBy: $postedBy, sendNotification: $sendNotification)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnnouncementModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.postedBy, postedBy) ||
                other.postedBy == postedBy) &&
            (identical(other.sendNotification, sendNotification) ||
                other.sendNotification == sendNotification));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    title,
    message,
    category,
    createdAt,
    postedBy,
    sendNotification,
  );

  /// Create a copy of AnnouncementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnnouncementModelImplCopyWith<_$AnnouncementModelImpl> get copyWith =>
      __$$AnnouncementModelImplCopyWithImpl<_$AnnouncementModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnnouncementModelImplToJson(this);
  }
}

abstract class _AnnouncementModel implements AnnouncementModel {
  const factory _AnnouncementModel({
    required final String id,
    required final String eventId,
    required final String title,
    required final String message,
    required final AnnouncementCategory category,
    required final DateTime createdAt,
    required final String postedBy,
    final bool sendNotification,
  }) = _$AnnouncementModelImpl;

  factory _AnnouncementModel.fromJson(Map<String, dynamic> json) =
      _$AnnouncementModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get title;
  @override
  String get message;
  @override
  AnnouncementCategory get category;
  @override
  DateTime get createdAt;
  @override
  String get postedBy;
  @override
  bool get sendNotification;

  /// Create a copy of AnnouncementModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnnouncementModelImplCopyWith<_$AnnouncementModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
