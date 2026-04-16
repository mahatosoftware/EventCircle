// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventInvitationModel _$EventInvitationModelFromJson(Map<String, dynamic> json) {
  return _EventInvitationModel.fromJson(json);
}

/// @nodoc
mixin _$EventInvitationModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  bool get isUsed => throw _privateConstructorUsedError;
  String? get usedBy => throw _privateConstructorUsedError;
  DateTime? get usedAt => throw _privateConstructorUsedError;
  bool get isPreApproved => throw _privateConstructorUsedError;

  /// Serializes this EventInvitationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventInvitationModelCopyWith<EventInvitationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventInvitationModelCopyWith<$Res> {
  factory $EventInvitationModelCopyWith(
    EventInvitationModel value,
    $Res Function(EventInvitationModel) then,
  ) = _$EventInvitationModelCopyWithImpl<$Res, EventInvitationModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String token,
    String createdBy,
    DateTime createdAt,
    DateTime? expiresAt,
    bool isUsed,
    String? usedBy,
    DateTime? usedAt,
    bool isPreApproved,
  });
}

/// @nodoc
class _$EventInvitationModelCopyWithImpl<
  $Res,
  $Val extends EventInvitationModel
>
    implements $EventInvitationModelCopyWith<$Res> {
  _$EventInvitationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? token = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? isUsed = null,
    Object? usedBy = freezed,
    Object? usedAt = freezed,
    Object? isPreApproved = null,
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
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isUsed: null == isUsed
                ? _value.isUsed
                : isUsed // ignore: cast_nullable_to_non_nullable
                      as bool,
            usedBy: freezed == usedBy
                ? _value.usedBy
                : usedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            usedAt: freezed == usedAt
                ? _value.usedAt
                : usedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPreApproved: null == isPreApproved
                ? _value.isPreApproved
                : isPreApproved // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventInvitationModelImplCopyWith<$Res>
    implements $EventInvitationModelCopyWith<$Res> {
  factory _$$EventInvitationModelImplCopyWith(
    _$EventInvitationModelImpl value,
    $Res Function(_$EventInvitationModelImpl) then,
  ) = __$$EventInvitationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String token,
    String createdBy,
    DateTime createdAt,
    DateTime? expiresAt,
    bool isUsed,
    String? usedBy,
    DateTime? usedAt,
    bool isPreApproved,
  });
}

/// @nodoc
class __$$EventInvitationModelImplCopyWithImpl<$Res>
    extends _$EventInvitationModelCopyWithImpl<$Res, _$EventInvitationModelImpl>
    implements _$$EventInvitationModelImplCopyWith<$Res> {
  __$$EventInvitationModelImplCopyWithImpl(
    _$EventInvitationModelImpl _value,
    $Res Function(_$EventInvitationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? token = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? isUsed = null,
    Object? usedBy = freezed,
    Object? usedAt = freezed,
    Object? isPreApproved = null,
  }) {
    return _then(
      _$EventInvitationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isUsed: null == isUsed
            ? _value.isUsed
            : isUsed // ignore: cast_nullable_to_non_nullable
                  as bool,
        usedBy: freezed == usedBy
            ? _value.usedBy
            : usedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        usedAt: freezed == usedAt
            ? _value.usedAt
            : usedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPreApproved: null == isPreApproved
            ? _value.isPreApproved
            : isPreApproved // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventInvitationModelImpl implements _EventInvitationModel {
  const _$EventInvitationModelImpl({
    required this.id,
    required this.eventId,
    required this.token,
    required this.createdBy,
    required this.createdAt,
    this.expiresAt,
    this.isUsed = false,
    this.usedBy,
    this.usedAt,
    this.isPreApproved = true,
  });

  factory _$EventInvitationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventInvitationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String token;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final bool isUsed;
  @override
  final String? usedBy;
  @override
  final DateTime? usedAt;
  @override
  @JsonKey()
  final bool isPreApproved;

  @override
  String toString() {
    return 'EventInvitationModel(id: $id, eventId: $eventId, token: $token, createdBy: $createdBy, createdAt: $createdAt, expiresAt: $expiresAt, isUsed: $isUsed, usedBy: $usedBy, usedAt: $usedAt, isPreApproved: $isPreApproved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventInvitationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isUsed, isUsed) || other.isUsed == isUsed) &&
            (identical(other.usedBy, usedBy) || other.usedBy == usedBy) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.isPreApproved, isPreApproved) ||
                other.isPreApproved == isPreApproved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    token,
    createdBy,
    createdAt,
    expiresAt,
    isUsed,
    usedBy,
    usedAt,
    isPreApproved,
  );

  /// Create a copy of EventInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventInvitationModelImplCopyWith<_$EventInvitationModelImpl>
  get copyWith =>
      __$$EventInvitationModelImplCopyWithImpl<_$EventInvitationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventInvitationModelImplToJson(this);
  }
}

abstract class _EventInvitationModel implements EventInvitationModel {
  const factory _EventInvitationModel({
    required final String id,
    required final String eventId,
    required final String token,
    required final String createdBy,
    required final DateTime createdAt,
    final DateTime? expiresAt,
    final bool isUsed,
    final String? usedBy,
    final DateTime? usedAt,
    final bool isPreApproved,
  }) = _$EventInvitationModelImpl;

  factory _EventInvitationModel.fromJson(Map<String, dynamic> json) =
      _$EventInvitationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get token;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;
  @override
  bool get isUsed;
  @override
  String? get usedBy;
  @override
  DateTime? get usedAt;
  @override
  bool get isPreApproved;

  /// Create a copy of EventInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventInvitationModelImplCopyWith<_$EventInvitationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
