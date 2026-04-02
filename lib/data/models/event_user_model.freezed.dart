// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventUserModel _$EventUserModelFromJson(Map<String, dynamic> json) {
  return _EventUserModel.fromJson(json);
}

/// @nodoc
mixin _$EventUserModel {
  String get id => throw _privateConstructorUsedError; // userId
  String get eventId => throw _privateConstructorUsedError;
  EventUserStatus get status => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;
  DateTime? get removedAt => throw _privateConstructorUsedError;
  String? get addedBy => throw _privateConstructorUsedError;

  /// Serializes this EventUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventUserModelCopyWith<EventUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventUserModelCopyWith<$Res> {
  factory $EventUserModelCopyWith(
    EventUserModel value,
    $Res Function(EventUserModel) then,
  ) = _$EventUserModelCopyWithImpl<$Res, EventUserModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    EventUserStatus status,
    DateTime addedAt,
    DateTime? removedAt,
    String? addedBy,
  });
}

/// @nodoc
class _$EventUserModelCopyWithImpl<$Res, $Val extends EventUserModel>
    implements $EventUserModelCopyWith<$Res> {
  _$EventUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? status = null,
    Object? addedAt = null,
    Object? removedAt = freezed,
    Object? addedBy = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EventUserStatus,
            addedAt: null == addedAt
                ? _value.addedAt
                : addedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            removedAt: freezed == removedAt
                ? _value.removedAt
                : removedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            addedBy: freezed == addedBy
                ? _value.addedBy
                : addedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventUserModelImplCopyWith<$Res>
    implements $EventUserModelCopyWith<$Res> {
  factory _$$EventUserModelImplCopyWith(
    _$EventUserModelImpl value,
    $Res Function(_$EventUserModelImpl) then,
  ) = __$$EventUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    EventUserStatus status,
    DateTime addedAt,
    DateTime? removedAt,
    String? addedBy,
  });
}

/// @nodoc
class __$$EventUserModelImplCopyWithImpl<$Res>
    extends _$EventUserModelCopyWithImpl<$Res, _$EventUserModelImpl>
    implements _$$EventUserModelImplCopyWith<$Res> {
  __$$EventUserModelImplCopyWithImpl(
    _$EventUserModelImpl _value,
    $Res Function(_$EventUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? status = null,
    Object? addedAt = null,
    Object? removedAt = freezed,
    Object? addedBy = freezed,
  }) {
    return _then(
      _$EventUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EventUserStatus,
        addedAt: null == addedAt
            ? _value.addedAt
            : addedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        removedAt: freezed == removedAt
            ? _value.removedAt
            : removedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        addedBy: freezed == addedBy
            ? _value.addedBy
            : addedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventUserModelImpl implements _EventUserModel {
  const _$EventUserModelImpl({
    required this.id,
    required this.eventId,
    required this.status,
    required this.addedAt,
    this.removedAt,
    this.addedBy,
  });

  factory _$EventUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventUserModelImplFromJson(json);

  @override
  final String id;
  // userId
  @override
  final String eventId;
  @override
  final EventUserStatus status;
  @override
  final DateTime addedAt;
  @override
  final DateTime? removedAt;
  @override
  final String? addedBy;

  @override
  String toString() {
    return 'EventUserModel(id: $id, eventId: $eventId, status: $status, addedAt: $addedAt, removedAt: $removedAt, addedBy: $addedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.removedAt, removedAt) ||
                other.removedAt == removedAt) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    status,
    addedAt,
    removedAt,
    addedBy,
  );

  /// Create a copy of EventUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventUserModelImplCopyWith<_$EventUserModelImpl> get copyWith =>
      __$$EventUserModelImplCopyWithImpl<_$EventUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventUserModelImplToJson(this);
  }
}

abstract class _EventUserModel implements EventUserModel {
  const factory _EventUserModel({
    required final String id,
    required final String eventId,
    required final EventUserStatus status,
    required final DateTime addedAt,
    final DateTime? removedAt,
    final String? addedBy,
  }) = _$EventUserModelImpl;

  factory _EventUserModel.fromJson(Map<String, dynamic> json) =
      _$EventUserModelImpl.fromJson;

  @override
  String get id; // userId
  @override
  String get eventId;
  @override
  EventUserStatus get status;
  @override
  DateTime get addedAt;
  @override
  DateTime? get removedAt;
  @override
  String? get addedBy;

  /// Create a copy of EventUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventUserModelImplCopyWith<_$EventUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
