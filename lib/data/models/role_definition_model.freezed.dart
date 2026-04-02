// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_definition_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoleDefinitionModel _$RoleDefinitionModelFromJson(Map<String, dynamic> json) {
  return _RoleDefinitionModel.fromJson(json);
}

/// @nodoc
mixin _$RoleDefinitionModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, ModuleAccessLevel> get moduleAccess =>
      throw _privateConstructorUsedError;

  /// Serializes this RoleDefinitionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleDefinitionModelCopyWith<RoleDefinitionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleDefinitionModelCopyWith<$Res> {
  factory $RoleDefinitionModelCopyWith(
    RoleDefinitionModel value,
    $Res Function(RoleDefinitionModel) then,
  ) = _$RoleDefinitionModelCopyWithImpl<$Res, RoleDefinitionModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    Map<String, ModuleAccessLevel> moduleAccess,
  });
}

/// @nodoc
class _$RoleDefinitionModelCopyWithImpl<$Res, $Val extends RoleDefinitionModel>
    implements $RoleDefinitionModelCopyWith<$Res> {
  _$RoleDefinitionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? moduleAccess = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoleDefinitionModelImplCopyWith<$Res>
    implements $RoleDefinitionModelCopyWith<$Res> {
  factory _$$RoleDefinitionModelImplCopyWith(
    _$RoleDefinitionModelImpl value,
    $Res Function(_$RoleDefinitionModelImpl) then,
  ) = __$$RoleDefinitionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    Map<String, ModuleAccessLevel> moduleAccess,
  });
}

/// @nodoc
class __$$RoleDefinitionModelImplCopyWithImpl<$Res>
    extends _$RoleDefinitionModelCopyWithImpl<$Res, _$RoleDefinitionModelImpl>
    implements _$$RoleDefinitionModelImplCopyWith<$Res> {
  __$$RoleDefinitionModelImplCopyWithImpl(
    _$RoleDefinitionModelImpl _value,
    $Res Function(_$RoleDefinitionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoleDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? moduleAccess = null,
  }) {
    return _then(
      _$RoleDefinitionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoleDefinitionModelImpl implements _RoleDefinitionModel {
  const _$RoleDefinitionModelImpl({
    required this.id,
    required this.name,
    this.description = '',
    final Map<String, ModuleAccessLevel> moduleAccess = const {},
  }) : _moduleAccess = moduleAccess;

  factory _$RoleDefinitionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleDefinitionModelImplFromJson(json);

  @override
  final String id;
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

  @override
  String toString() {
    return 'RoleDefinitionModel(id: $id, name: $name, description: $description, moduleAccess: $moduleAccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleDefinitionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._moduleAccess,
              _moduleAccess,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(_moduleAccess),
  );

  /// Create a copy of RoleDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleDefinitionModelImplCopyWith<_$RoleDefinitionModelImpl> get copyWith =>
      __$$RoleDefinitionModelImplCopyWithImpl<_$RoleDefinitionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleDefinitionModelImplToJson(this);
  }
}

abstract class _RoleDefinitionModel implements RoleDefinitionModel {
  const factory _RoleDefinitionModel({
    required final String id,
    required final String name,
    final String description,
    final Map<String, ModuleAccessLevel> moduleAccess,
  }) = _$RoleDefinitionModelImpl;

  factory _RoleDefinitionModel.fromJson(Map<String, dynamic> json) =
      _$RoleDefinitionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  Map<String, ModuleAccessLevel> get moduleAccess;

  /// Create a copy of RoleDefinitionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleDefinitionModelImplCopyWith<_$RoleDefinitionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
