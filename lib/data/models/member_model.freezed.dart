// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) {
  return _MemberModel.fromJson(json);
}

/// @nodoc
mixin _$MemberModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get identifier =>
      throw _privateConstructorUsedError; // e.g., flat number
  MemberStatus get status => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  String? get guestCategory =>
      throw _privateConstructorUsedError; // Family, VIP, Member
  RsvpStatus get rsvpStatus => throw _privateConstructorUsedError;
  int get plusOnes => throw _privateConstructorUsedError;
  double? get assignedAmount =>
      throw _privateConstructorUsedError; // For variable contribution
  String? get groupId =>
      throw _privateConstructorUsedError; // For group-based contribution
  String? get selectedTier =>
      throw _privateConstructorUsedError; // For tier-based contribution
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this MemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberModelCopyWith<MemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberModelCopyWith<$Res> {
  factory $MemberModelCopyWith(
    MemberModel value,
    $Res Function(MemberModel) then,
  ) = _$MemberModelCopyWithImpl<$Res, MemberModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    String phone,
    String identifier,
    MemberStatus status,
    DateTime joinedAt,
    String? guestCategory,
    RsvpStatus rsvpStatus,
    int plusOnes,
    double? assignedAmount,
    String? groupId,
    String? selectedTier,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$MemberModelCopyWithImpl<$Res, $Val extends MemberModel>
    implements $MemberModelCopyWith<$Res> {
  _$MemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? phone = null,
    Object? identifier = null,
    Object? status = null,
    Object? joinedAt = null,
    Object? guestCategory = freezed,
    Object? rsvpStatus = null,
    Object? plusOnes = null,
    Object? assignedAmount = freezed,
    Object? groupId = freezed,
    Object? selectedTier = freezed,
    Object? metadata = freezed,
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
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            identifier: null == identifier
                ? _value.identifier
                : identifier // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MemberStatus,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            guestCategory: freezed == guestCategory
                ? _value.guestCategory
                : guestCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            rsvpStatus: null == rsvpStatus
                ? _value.rsvpStatus
                : rsvpStatus // ignore: cast_nullable_to_non_nullable
                      as RsvpStatus,
            plusOnes: null == plusOnes
                ? _value.plusOnes
                : plusOnes // ignore: cast_nullable_to_non_nullable
                      as int,
            assignedAmount: freezed == assignedAmount
                ? _value.assignedAmount
                : assignedAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedTier: freezed == selectedTier
                ? _value.selectedTier
                : selectedTier // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberModelImplCopyWith<$Res>
    implements $MemberModelCopyWith<$Res> {
  factory _$$MemberModelImplCopyWith(
    _$MemberModelImpl value,
    $Res Function(_$MemberModelImpl) then,
  ) = __$$MemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    String phone,
    String identifier,
    MemberStatus status,
    DateTime joinedAt,
    String? guestCategory,
    RsvpStatus rsvpStatus,
    int plusOnes,
    double? assignedAmount,
    String? groupId,
    String? selectedTier,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$MemberModelImplCopyWithImpl<$Res>
    extends _$MemberModelCopyWithImpl<$Res, _$MemberModelImpl>
    implements _$$MemberModelImplCopyWith<$Res> {
  __$$MemberModelImplCopyWithImpl(
    _$MemberModelImpl _value,
    $Res Function(_$MemberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? phone = null,
    Object? identifier = null,
    Object? status = null,
    Object? joinedAt = null,
    Object? guestCategory = freezed,
    Object? rsvpStatus = null,
    Object? plusOnes = null,
    Object? assignedAmount = freezed,
    Object? groupId = freezed,
    Object? selectedTier = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$MemberModelImpl(
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
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        identifier: null == identifier
            ? _value.identifier
            : identifier // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MemberStatus,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        guestCategory: freezed == guestCategory
            ? _value.guestCategory
            : guestCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        rsvpStatus: null == rsvpStatus
            ? _value.rsvpStatus
            : rsvpStatus // ignore: cast_nullable_to_non_nullable
                  as RsvpStatus,
        plusOnes: null == plusOnes
            ? _value.plusOnes
            : plusOnes // ignore: cast_nullable_to_non_nullable
                  as int,
        assignedAmount: freezed == assignedAmount
            ? _value.assignedAmount
            : assignedAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedTier: freezed == selectedTier
            ? _value.selectedTier
            : selectedTier // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberModelImpl implements _MemberModel {
  const _$MemberModelImpl({
    required this.id,
    required this.eventId,
    required this.name,
    required this.phone,
    required this.identifier,
    required this.status,
    required this.joinedAt,
    this.guestCategory,
    this.rsvpStatus = RsvpStatus.none,
    this.plusOnes = 0,
    this.assignedAmount,
    this.groupId,
    this.selectedTier,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$MemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String identifier;
  // e.g., flat number
  @override
  final MemberStatus status;
  @override
  final DateTime joinedAt;
  @override
  final String? guestCategory;
  // Family, VIP, Member
  @override
  @JsonKey()
  final RsvpStatus rsvpStatus;
  @override
  @JsonKey()
  final int plusOnes;
  @override
  final double? assignedAmount;
  // For variable contribution
  @override
  final String? groupId;
  // For group-based contribution
  @override
  final String? selectedTier;
  // For tier-based contribution
  final Map<String, dynamic>? _metadata;
  // For tier-based contribution
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MemberModel(id: $id, eventId: $eventId, name: $name, phone: $phone, identifier: $identifier, status: $status, joinedAt: $joinedAt, guestCategory: $guestCategory, rsvpStatus: $rsvpStatus, plusOnes: $plusOnes, assignedAmount: $assignedAmount, groupId: $groupId, selectedTier: $selectedTier, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.guestCategory, guestCategory) ||
                other.guestCategory == guestCategory) &&
            (identical(other.rsvpStatus, rsvpStatus) ||
                other.rsvpStatus == rsvpStatus) &&
            (identical(other.plusOnes, plusOnes) ||
                other.plusOnes == plusOnes) &&
            (identical(other.assignedAmount, assignedAmount) ||
                other.assignedAmount == assignedAmount) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.selectedTier, selectedTier) ||
                other.selectedTier == selectedTier) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    name,
    phone,
    identifier,
    status,
    joinedAt,
    guestCategory,
    rsvpStatus,
    plusOnes,
    assignedAmount,
    groupId,
    selectedTier,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberModelImplCopyWith<_$MemberModelImpl> get copyWith =>
      __$$MemberModelImplCopyWithImpl<_$MemberModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberModelImplToJson(this);
  }
}

abstract class _MemberModel implements MemberModel {
  const factory _MemberModel({
    required final String id,
    required final String eventId,
    required final String name,
    required final String phone,
    required final String identifier,
    required final MemberStatus status,
    required final DateTime joinedAt,
    final String? guestCategory,
    final RsvpStatus rsvpStatus,
    final int plusOnes,
    final double? assignedAmount,
    final String? groupId,
    final String? selectedTier,
    final Map<String, dynamic>? metadata,
  }) = _$MemberModelImpl;

  factory _MemberModel.fromJson(Map<String, dynamic> json) =
      _$MemberModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get identifier; // e.g., flat number
  @override
  MemberStatus get status;
  @override
  DateTime get joinedAt;
  @override
  String? get guestCategory; // Family, VIP, Member
  @override
  RsvpStatus get rsvpStatus;
  @override
  int get plusOnes;
  @override
  double? get assignedAmount; // For variable contribution
  @override
  String? get groupId; // For group-based contribution
  @override
  String? get selectedTier; // For tier-based contribution
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberModelImplCopyWith<_$MemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
