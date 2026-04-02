// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) {
  return _AuditLogModel.fromJson(json);
}

/// @nodoc
mixin _$AuditLogModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // User who performed the action
  String get action =>
      throw _privateConstructorUsedError; // 'create', 'update', 'delete'
  String get entityType =>
      throw _privateConstructorUsedError; // 'payment', 'member', 'event', etc.
  String get entityId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get previousData => throw _privateConstructorUsedError;
  Map<String, dynamic>? get newData => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this AuditLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditLogModelCopyWith<AuditLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogModelCopyWith<$Res> {
  factory $AuditLogModelCopyWith(
    AuditLogModel value,
    $Res Function(AuditLogModel) then,
  ) = _$AuditLogModelCopyWithImpl<$Res, AuditLogModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    String action,
    String entityType,
    String entityId,
    DateTime timestamp,
    Map<String, dynamic>? previousData,
    Map<String, dynamic>? newData,
    String? reason,
  });
}

/// @nodoc
class _$AuditLogModelCopyWithImpl<$Res, $Val extends AuditLogModel>
    implements $AuditLogModelCopyWith<$Res> {
  _$AuditLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? timestamp = null,
    Object? previousData = freezed,
    Object? newData = freezed,
    Object? reason = freezed,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            previousData: freezed == previousData
                ? _value.previousData
                : previousData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            newData: freezed == newData
                ? _value.newData
                : newData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuditLogModelImplCopyWith<$Res>
    implements $AuditLogModelCopyWith<$Res> {
  factory _$$AuditLogModelImplCopyWith(
    _$AuditLogModelImpl value,
    $Res Function(_$AuditLogModelImpl) then,
  ) = __$$AuditLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    String action,
    String entityType,
    String entityId,
    DateTime timestamp,
    Map<String, dynamic>? previousData,
    Map<String, dynamic>? newData,
    String? reason,
  });
}

/// @nodoc
class __$$AuditLogModelImplCopyWithImpl<$Res>
    extends _$AuditLogModelCopyWithImpl<$Res, _$AuditLogModelImpl>
    implements _$$AuditLogModelImplCopyWith<$Res> {
  __$$AuditLogModelImplCopyWithImpl(
    _$AuditLogModelImpl _value,
    $Res Function(_$AuditLogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? timestamp = null,
    Object? previousData = freezed,
    Object? newData = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      _$AuditLogModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        previousData: freezed == previousData
            ? _value._previousData
            : previousData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        newData: freezed == newData
            ? _value._newData
            : newData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogModelImpl implements _AuditLogModel {
  const _$AuditLogModelImpl({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.timestamp,
    final Map<String, dynamic>? previousData,
    final Map<String, dynamic>? newData,
    this.reason,
  }) : _previousData = previousData,
       _newData = newData;

  factory _$AuditLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  // User who performed the action
  @override
  final String action;
  // 'create', 'update', 'delete'
  @override
  final String entityType;
  // 'payment', 'member', 'event', etc.
  @override
  final String entityId;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _previousData;
  @override
  Map<String, dynamic>? get previousData {
    final value = _previousData;
    if (value == null) return null;
    if (_previousData is EqualUnmodifiableMapView) return _previousData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _newData;
  @override
  Map<String, dynamic>? get newData {
    final value = _newData;
    if (value == null) return null;
    if (_newData is EqualUnmodifiableMapView) return _newData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? reason;

  @override
  String toString() {
    return 'AuditLogModel(id: $id, eventId: $eventId, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, timestamp: $timestamp, previousData: $previousData, newData: $newData, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(
              other._previousData,
              _previousData,
            ) &&
            const DeepCollectionEquality().equals(other._newData, _newData) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    userId,
    action,
    entityType,
    entityId,
    timestamp,
    const DeepCollectionEquality().hash(_previousData),
    const DeepCollectionEquality().hash(_newData),
    reason,
  );

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogModelImplCopyWith<_$AuditLogModelImpl> get copyWith =>
      __$$AuditLogModelImplCopyWithImpl<_$AuditLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogModelImplToJson(this);
  }
}

abstract class _AuditLogModel implements AuditLogModel {
  const factory _AuditLogModel({
    required final String id,
    required final String eventId,
    required final String userId,
    required final String action,
    required final String entityType,
    required final String entityId,
    required final DateTime timestamp,
    final Map<String, dynamic>? previousData,
    final Map<String, dynamic>? newData,
    final String? reason,
  }) = _$AuditLogModelImpl;

  factory _AuditLogModel.fromJson(Map<String, dynamic> json) =
      _$AuditLogModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId; // User who performed the action
  @override
  String get action; // 'create', 'update', 'delete'
  @override
  String get entityType; // 'payment', 'member', 'event', etc.
  @override
  String get entityId;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get previousData;
  @override
  Map<String, dynamic>? get newData;
  @override
  String? get reason;

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditLogModelImplCopyWith<_$AuditLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
