// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventRoleModel _$EventRoleModelFromJson(Map<String, dynamic> json) {
  return _EventRoleModel.fromJson(json);
}

/// @nodoc
mixin _$EventRoleModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, ModuleAccessLevel> get moduleAccess =>
      throw _privateConstructorUsedError;
  List<String> get userIds => throw _privateConstructorUsedError;
  Map<String, String> get userResponsibilities =>
      throw _privateConstructorUsedError;
  bool get isSystem => throw _privateConstructorUsedError;
  String? get systemKey => throw _privateConstructorUsedError;

  /// Serializes this EventRoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventRoleModelCopyWith<EventRoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventRoleModelCopyWith<$Res> {
  factory $EventRoleModelCopyWith(
    EventRoleModel value,
    $Res Function(EventRoleModel) then,
  ) = _$EventRoleModelCopyWithImpl<$Res, EventRoleModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    String description,
    Map<String, ModuleAccessLevel> moduleAccess,
    List<String> userIds,
    Map<String, String> userResponsibilities,
    bool isSystem,
    String? systemKey,
  });
}

/// @nodoc
class _$EventRoleModelCopyWithImpl<$Res, $Val extends EventRoleModel>
    implements $EventRoleModelCopyWith<$Res> {
  _$EventRoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? description = null,
    Object? moduleAccess = null,
    Object? userIds = null,
    Object? userResponsibilities = null,
    Object? isSystem = null,
    Object? systemKey = freezed,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            moduleAccess: null == moduleAccess
                ? _value.moduleAccess
                : moduleAccess // ignore: cast_nullable_to_non_nullable
                      as Map<String, ModuleAccessLevel>,
            userIds: null == userIds
                ? _value.userIds
                : userIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            userResponsibilities: null == userResponsibilities
                ? _value.userResponsibilities
                : userResponsibilities // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            isSystem: null == isSystem
                ? _value.isSystem
                : isSystem // ignore: cast_nullable_to_non_nullable
                      as bool,
            systemKey: freezed == systemKey
                ? _value.systemKey
                : systemKey // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventRoleModelImplCopyWith<$Res>
    implements $EventRoleModelCopyWith<$Res> {
  factory _$$EventRoleModelImplCopyWith(
    _$EventRoleModelImpl value,
    $Res Function(_$EventRoleModelImpl) then,
  ) = __$$EventRoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    String description,
    Map<String, ModuleAccessLevel> moduleAccess,
    List<String> userIds,
    Map<String, String> userResponsibilities,
    bool isSystem,
    String? systemKey,
  });
}

/// @nodoc
class __$$EventRoleModelImplCopyWithImpl<$Res>
    extends _$EventRoleModelCopyWithImpl<$Res, _$EventRoleModelImpl>
    implements _$$EventRoleModelImplCopyWith<$Res> {
  __$$EventRoleModelImplCopyWithImpl(
    _$EventRoleModelImpl _value,
    $Res Function(_$EventRoleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? description = null,
    Object? moduleAccess = null,
    Object? userIds = null,
    Object? userResponsibilities = null,
    Object? isSystem = null,
    Object? systemKey = freezed,
  }) {
    return _then(
      _$EventRoleModelImpl(
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
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        moduleAccess: null == moduleAccess
            ? _value._moduleAccess
            : moduleAccess // ignore: cast_nullable_to_non_nullable
                  as Map<String, ModuleAccessLevel>,
        userIds: null == userIds
            ? _value._userIds
            : userIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        userResponsibilities: null == userResponsibilities
            ? _value._userResponsibilities
            : userResponsibilities // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        isSystem: null == isSystem
            ? _value.isSystem
            : isSystem // ignore: cast_nullable_to_non_nullable
                  as bool,
        systemKey: freezed == systemKey
            ? _value.systemKey
            : systemKey // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventRoleModelImpl implements _EventRoleModel {
  const _$EventRoleModelImpl({
    required this.id,
    required this.eventId,
    required this.name,
    this.description = '',
    final Map<String, ModuleAccessLevel> moduleAccess = const {},
    final List<String> userIds = const [],
    final Map<String, String> userResponsibilities = const {},
    this.isSystem = false,
    this.systemKey,
  }) : _moduleAccess = moduleAccess,
       _userIds = userIds,
       _userResponsibilities = userResponsibilities;

  factory _$EventRoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventRoleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  final Map<String, ModuleAccessLevel> _moduleAccess;
  @override
  @JsonKey()
  Map<String, ModuleAccessLevel> get moduleAccess {
    if (_moduleAccess is EqualUnmodifiableMapView) return _moduleAccess;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moduleAccess);
  }

  final List<String> _userIds;
  @override
  @JsonKey()
  List<String> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  final Map<String, String> _userResponsibilities;
  @override
  @JsonKey()
  Map<String, String> get userResponsibilities {
    if (_userResponsibilities is EqualUnmodifiableMapView)
      return _userResponsibilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userResponsibilities);
  }

  @override
  @JsonKey()
  final bool isSystem;
  @override
  final String? systemKey;

  @override
  String toString() {
    return 'EventRoleModel(id: $id, eventId: $eventId, name: $name, description: $description, moduleAccess: $moduleAccess, userIds: $userIds, userResponsibilities: $userResponsibilities, isSystem: $isSystem, systemKey: $systemKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventRoleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._moduleAccess,
              _moduleAccess,
            ) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            const DeepCollectionEquality().equals(
              other._userResponsibilities,
              _userResponsibilities,
            ) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.systemKey, systemKey) ||
                other.systemKey == systemKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    name,
    description,
    const DeepCollectionEquality().hash(_moduleAccess),
    const DeepCollectionEquality().hash(_userIds),
    const DeepCollectionEquality().hash(_userResponsibilities),
    isSystem,
    systemKey,
  );

  /// Create a copy of EventRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventRoleModelImplCopyWith<_$EventRoleModelImpl> get copyWith =>
      __$$EventRoleModelImplCopyWithImpl<_$EventRoleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventRoleModelImplToJson(this);
  }
}

abstract class _EventRoleModel implements EventRoleModel {
  const factory _EventRoleModel({
    required final String id,
    required final String eventId,
    required final String name,
    final String description,
    final Map<String, ModuleAccessLevel> moduleAccess,
    final List<String> userIds,
    final Map<String, String> userResponsibilities,
    final bool isSystem,
    final String? systemKey,
  }) = _$EventRoleModelImpl;

  factory _EventRoleModel.fromJson(Map<String, dynamic> json) =
      _$EventRoleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get name;
  @override
  String get description;
  @override
  Map<String, ModuleAccessLevel> get moduleAccess;
  @override
  List<String> get userIds;
  @override
  Map<String, String> get userResponsibilities;
  @override
  bool get isSystem;
  @override
  String? get systemKey;

  /// Create a copy of EventRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventRoleModelImplCopyWith<_$EventRoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
