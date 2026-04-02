// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_ticketing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) {
  return _LocationModel.fromJson(json);
}

/// @nodoc
mixin _$LocationModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get mapLink => throw _privateConstructorUsedError;
  String? get parkingInfo => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  bool get isMainVenue => throw _privateConstructorUsedError;

  /// Serializes this LocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationModelCopyWith<LocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationModelCopyWith<$Res> {
  factory $LocationModelCopyWith(
    LocationModel value,
    $Res Function(LocationModel) then,
  ) = _$LocationModelCopyWithImpl<$Res, LocationModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    String address,
    String? mapLink,
    String? parkingInfo,
    String? instructions,
    bool isMainVenue,
  });
}

/// @nodoc
class _$LocationModelCopyWithImpl<$Res, $Val extends LocationModel>
    implements $LocationModelCopyWith<$Res> {
  _$LocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? address = null,
    Object? mapLink = freezed,
    Object? parkingInfo = freezed,
    Object? instructions = freezed,
    Object? isMainVenue = null,
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
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            mapLink: freezed == mapLink
                ? _value.mapLink
                : mapLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            parkingInfo: freezed == parkingInfo
                ? _value.parkingInfo
                : parkingInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            isMainVenue: null == isMainVenue
                ? _value.isMainVenue
                : isMainVenue // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationModelImplCopyWith<$Res>
    implements $LocationModelCopyWith<$Res> {
  factory _$$LocationModelImplCopyWith(
    _$LocationModelImpl value,
    $Res Function(_$LocationModelImpl) then,
  ) = __$$LocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String name,
    String address,
    String? mapLink,
    String? parkingInfo,
    String? instructions,
    bool isMainVenue,
  });
}

/// @nodoc
class __$$LocationModelImplCopyWithImpl<$Res>
    extends _$LocationModelCopyWithImpl<$Res, _$LocationModelImpl>
    implements _$$LocationModelImplCopyWith<$Res> {
  __$$LocationModelImplCopyWithImpl(
    _$LocationModelImpl _value,
    $Res Function(_$LocationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? address = null,
    Object? mapLink = freezed,
    Object? parkingInfo = freezed,
    Object? instructions = freezed,
    Object? isMainVenue = null,
  }) {
    return _then(
      _$LocationModelImpl(
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
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        mapLink: freezed == mapLink
            ? _value.mapLink
            : mapLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        parkingInfo: freezed == parkingInfo
            ? _value.parkingInfo
            : parkingInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        isMainVenue: null == isMainVenue
            ? _value.isMainVenue
            : isMainVenue // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationModelImpl implements _LocationModel {
  const _$LocationModelImpl({
    required this.id,
    required this.eventId,
    required this.name,
    required this.address,
    this.mapLink,
    this.parkingInfo,
    this.instructions,
    this.isMainVenue = true,
  });

  factory _$LocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String name;
  @override
  final String address;
  @override
  final String? mapLink;
  @override
  final String? parkingInfo;
  @override
  final String? instructions;
  @override
  @JsonKey()
  final bool isMainVenue;

  @override
  String toString() {
    return 'LocationModel(id: $id, eventId: $eventId, name: $name, address: $address, mapLink: $mapLink, parkingInfo: $parkingInfo, instructions: $instructions, isMainVenue: $isMainVenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.mapLink, mapLink) || other.mapLink == mapLink) &&
            (identical(other.parkingInfo, parkingInfo) ||
                other.parkingInfo == parkingInfo) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.isMainVenue, isMainVenue) ||
                other.isMainVenue == isMainVenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    name,
    address,
    mapLink,
    parkingInfo,
    instructions,
    isMainVenue,
  );

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      __$$LocationModelImplCopyWithImpl<_$LocationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationModelImplToJson(this);
  }
}

abstract class _LocationModel implements LocationModel {
  const factory _LocationModel({
    required final String id,
    required final String eventId,
    required final String name,
    required final String address,
    final String? mapLink,
    final String? parkingInfo,
    final String? instructions,
    final bool isMainVenue,
  }) = _$LocationModelImpl;

  factory _LocationModel.fromJson(Map<String, dynamic> json) =
      _$LocationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get name;
  @override
  String get address;
  @override
  String? get mapLink;
  @override
  String? get parkingInfo;
  @override
  String? get instructions;
  @override
  bool get isMainVenue;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) {
  return _TicketModel.fromJson(json);
}

/// @nodoc
mixin _$TicketModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get title =>
      throw _privateConstructorUsedError; // Early Bird, VIP, etc.
  double get price => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  int get soldCount => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Detailed fields for creation & sale
  DateTime? get saleStartDate => throw _privateConstructorUsedError;
  DateTime? get saleEndDate => throw _privateConstructorUsedError;
  int get maxTicketsPerUser => throw _privateConstructorUsedError;
  TicketVisibility get visibility => throw _privateConstructorUsedError;
  bool get allowAnonymous => throw _privateConstructorUsedError;
  List<String>? get benefits => throw _privateConstructorUsedError;

  /// Serializes this TicketModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketModelCopyWith<TicketModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketModelCopyWith<$Res> {
  factory $TicketModelCopyWith(
    TicketModel value,
    $Res Function(TicketModel) then,
  ) = _$TicketModelCopyWithImpl<$Res, TicketModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    double price,
    int capacity,
    int soldCount,
    String? description,
    DateTime? saleStartDate,
    DateTime? saleEndDate,
    int maxTicketsPerUser,
    TicketVisibility visibility,
    bool allowAnonymous,
    List<String>? benefits,
  });
}

/// @nodoc
class _$TicketModelCopyWithImpl<$Res, $Val extends TicketModel>
    implements $TicketModelCopyWith<$Res> {
  _$TicketModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? price = null,
    Object? capacity = null,
    Object? soldCount = null,
    Object? description = freezed,
    Object? saleStartDate = freezed,
    Object? saleEndDate = freezed,
    Object? maxTicketsPerUser = null,
    Object? visibility = null,
    Object? allowAnonymous = null,
    Object? benefits = freezed,
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            soldCount: null == soldCount
                ? _value.soldCount
                : soldCount // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            saleStartDate: freezed == saleStartDate
                ? _value.saleStartDate
                : saleStartDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            saleEndDate: freezed == saleEndDate
                ? _value.saleEndDate
                : saleEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            maxTicketsPerUser: null == maxTicketsPerUser
                ? _value.maxTicketsPerUser
                : maxTicketsPerUser // ignore: cast_nullable_to_non_nullable
                      as int,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as TicketVisibility,
            allowAnonymous: null == allowAnonymous
                ? _value.allowAnonymous
                : allowAnonymous // ignore: cast_nullable_to_non_nullable
                      as bool,
            benefits: freezed == benefits
                ? _value.benefits
                : benefits // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketModelImplCopyWith<$Res>
    implements $TicketModelCopyWith<$Res> {
  factory _$$TicketModelImplCopyWith(
    _$TicketModelImpl value,
    $Res Function(_$TicketModelImpl) then,
  ) = __$$TicketModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    double price,
    int capacity,
    int soldCount,
    String? description,
    DateTime? saleStartDate,
    DateTime? saleEndDate,
    int maxTicketsPerUser,
    TicketVisibility visibility,
    bool allowAnonymous,
    List<String>? benefits,
  });
}

/// @nodoc
class __$$TicketModelImplCopyWithImpl<$Res>
    extends _$TicketModelCopyWithImpl<$Res, _$TicketModelImpl>
    implements _$$TicketModelImplCopyWith<$Res> {
  __$$TicketModelImplCopyWithImpl(
    _$TicketModelImpl _value,
    $Res Function(_$TicketModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? price = null,
    Object? capacity = null,
    Object? soldCount = null,
    Object? description = freezed,
    Object? saleStartDate = freezed,
    Object? saleEndDate = freezed,
    Object? maxTicketsPerUser = null,
    Object? visibility = null,
    Object? allowAnonymous = null,
    Object? benefits = freezed,
  }) {
    return _then(
      _$TicketModelImpl(
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
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        soldCount: null == soldCount
            ? _value.soldCount
            : soldCount // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        saleStartDate: freezed == saleStartDate
            ? _value.saleStartDate
            : saleStartDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        saleEndDate: freezed == saleEndDate
            ? _value.saleEndDate
            : saleEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        maxTicketsPerUser: null == maxTicketsPerUser
            ? _value.maxTicketsPerUser
            : maxTicketsPerUser // ignore: cast_nullable_to_non_nullable
                  as int,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as TicketVisibility,
        allowAnonymous: null == allowAnonymous
            ? _value.allowAnonymous
            : allowAnonymous // ignore: cast_nullable_to_non_nullable
                  as bool,
        benefits: freezed == benefits
            ? _value._benefits
            : benefits // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketModelImpl implements _TicketModel {
  const _$TicketModelImpl({
    required this.id,
    required this.eventId,
    required this.title,
    required this.price,
    required this.capacity,
    this.soldCount = 0,
    this.description,
    this.saleStartDate,
    this.saleEndDate,
    this.maxTicketsPerUser = 1,
    this.visibility = TicketVisibility.public,
    this.allowAnonymous = false,
    final List<String>? benefits,
  }) : _benefits = benefits;

  factory _$TicketModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String title;
  // Early Bird, VIP, etc.
  @override
  final double price;
  @override
  final int capacity;
  @override
  @JsonKey()
  final int soldCount;
  @override
  final String? description;
  // Detailed fields for creation & sale
  @override
  final DateTime? saleStartDate;
  @override
  final DateTime? saleEndDate;
  @override
  @JsonKey()
  final int maxTicketsPerUser;
  @override
  @JsonKey()
  final TicketVisibility visibility;
  @override
  @JsonKey()
  final bool allowAnonymous;
  final List<String>? _benefits;
  @override
  List<String>? get benefits {
    final value = _benefits;
    if (value == null) return null;
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TicketModel(id: $id, eventId: $eventId, title: $title, price: $price, capacity: $capacity, soldCount: $soldCount, description: $description, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, maxTicketsPerUser: $maxTicketsPerUser, visibility: $visibility, allowAnonymous: $allowAnonymous, benefits: $benefits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.saleStartDate, saleStartDate) ||
                other.saleStartDate == saleStartDate) &&
            (identical(other.saleEndDate, saleEndDate) ||
                other.saleEndDate == saleEndDate) &&
            (identical(other.maxTicketsPerUser, maxTicketsPerUser) ||
                other.maxTicketsPerUser == maxTicketsPerUser) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.allowAnonymous, allowAnonymous) ||
                other.allowAnonymous == allowAnonymous) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    title,
    price,
    capacity,
    soldCount,
    description,
    saleStartDate,
    saleEndDate,
    maxTicketsPerUser,
    visibility,
    allowAnonymous,
    const DeepCollectionEquality().hash(_benefits),
  );

  /// Create a copy of TicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketModelImplCopyWith<_$TicketModelImpl> get copyWith =>
      __$$TicketModelImplCopyWithImpl<_$TicketModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketModelImplToJson(this);
  }
}

abstract class _TicketModel implements TicketModel {
  const factory _TicketModel({
    required final String id,
    required final String eventId,
    required final String title,
    required final double price,
    required final int capacity,
    final int soldCount,
    final String? description,
    final DateTime? saleStartDate,
    final DateTime? saleEndDate,
    final int maxTicketsPerUser,
    final TicketVisibility visibility,
    final bool allowAnonymous,
    final List<String>? benefits,
  }) = _$TicketModelImpl;

  factory _TicketModel.fromJson(Map<String, dynamic> json) =
      _$TicketModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get title; // Early Bird, VIP, etc.
  @override
  double get price;
  @override
  int get capacity;
  @override
  int get soldCount;
  @override
  String? get description; // Detailed fields for creation & sale
  @override
  DateTime? get saleStartDate;
  @override
  DateTime? get saleEndDate;
  @override
  int get maxTicketsPerUser;
  @override
  TicketVisibility get visibility;
  @override
  bool get allowAnonymous;
  @override
  List<String>? get benefits;

  /// Create a copy of TicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketModelImplCopyWith<_$TicketModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IssuedTicketModel _$IssuedTicketModelFromJson(Map<String, dynamic> json) {
  return _IssuedTicketModel.fromJson(json);
}

/// @nodoc
mixin _$IssuedTicketModel {
  String get id => throw _privateConstructorUsedError;
  String get ticketTypeId => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get attendeeName => throw _privateConstructorUsedError;
  String get attendeeEmail => throw _privateConstructorUsedError;
  String get attendeePhone => throw _privateConstructorUsedError;
  String get qrData => throw _privateConstructorUsedError;
  TicketStatus get status => throw _privateConstructorUsedError;
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customFieldData =>
      throw _privateConstructorUsedError;
  DateTime? get issuedAt => throw _privateConstructorUsedError;

  /// Serializes this IssuedTicketModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IssuedTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssuedTicketModelCopyWith<IssuedTicketModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssuedTicketModelCopyWith<$Res> {
  factory $IssuedTicketModelCopyWith(
    IssuedTicketModel value,
    $Res Function(IssuedTicketModel) then,
  ) = _$IssuedTicketModelCopyWithImpl<$Res, IssuedTicketModel>;
  @useResult
  $Res call({
    String id,
    String ticketTypeId,
    String eventId,
    String attendeeName,
    String attendeeEmail,
    String attendeePhone,
    String qrData,
    TicketStatus status,
    DateTime? checkInTime,
    Map<String, dynamic>? customFieldData,
    DateTime? issuedAt,
  });
}

/// @nodoc
class _$IssuedTicketModelCopyWithImpl<$Res, $Val extends IssuedTicketModel>
    implements $IssuedTicketModelCopyWith<$Res> {
  _$IssuedTicketModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IssuedTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketTypeId = null,
    Object? eventId = null,
    Object? attendeeName = null,
    Object? attendeeEmail = null,
    Object? attendeePhone = null,
    Object? qrData = null,
    Object? status = null,
    Object? checkInTime = freezed,
    Object? customFieldData = freezed,
    Object? issuedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ticketTypeId: null == ticketTypeId
                ? _value.ticketTypeId
                : ticketTypeId // ignore: cast_nullable_to_non_nullable
                      as String,
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            attendeeName: null == attendeeName
                ? _value.attendeeName
                : attendeeName // ignore: cast_nullable_to_non_nullable
                      as String,
            attendeeEmail: null == attendeeEmail
                ? _value.attendeeEmail
                : attendeeEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            attendeePhone: null == attendeePhone
                ? _value.attendeePhone
                : attendeePhone // ignore: cast_nullable_to_non_nullable
                      as String,
            qrData: null == qrData
                ? _value.qrData
                : qrData // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TicketStatus,
            checkInTime: freezed == checkInTime
                ? _value.checkInTime
                : checkInTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            customFieldData: freezed == customFieldData
                ? _value.customFieldData
                : customFieldData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            issuedAt: freezed == issuedAt
                ? _value.issuedAt
                : issuedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IssuedTicketModelImplCopyWith<$Res>
    implements $IssuedTicketModelCopyWith<$Res> {
  factory _$$IssuedTicketModelImplCopyWith(
    _$IssuedTicketModelImpl value,
    $Res Function(_$IssuedTicketModelImpl) then,
  ) = __$$IssuedTicketModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ticketTypeId,
    String eventId,
    String attendeeName,
    String attendeeEmail,
    String attendeePhone,
    String qrData,
    TicketStatus status,
    DateTime? checkInTime,
    Map<String, dynamic>? customFieldData,
    DateTime? issuedAt,
  });
}

/// @nodoc
class __$$IssuedTicketModelImplCopyWithImpl<$Res>
    extends _$IssuedTicketModelCopyWithImpl<$Res, _$IssuedTicketModelImpl>
    implements _$$IssuedTicketModelImplCopyWith<$Res> {
  __$$IssuedTicketModelImplCopyWithImpl(
    _$IssuedTicketModelImpl _value,
    $Res Function(_$IssuedTicketModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IssuedTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketTypeId = null,
    Object? eventId = null,
    Object? attendeeName = null,
    Object? attendeeEmail = null,
    Object? attendeePhone = null,
    Object? qrData = null,
    Object? status = null,
    Object? checkInTime = freezed,
    Object? customFieldData = freezed,
    Object? issuedAt = freezed,
  }) {
    return _then(
      _$IssuedTicketModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ticketTypeId: null == ticketTypeId
            ? _value.ticketTypeId
            : ticketTypeId // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        attendeeName: null == attendeeName
            ? _value.attendeeName
            : attendeeName // ignore: cast_nullable_to_non_nullable
                  as String,
        attendeeEmail: null == attendeeEmail
            ? _value.attendeeEmail
            : attendeeEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        attendeePhone: null == attendeePhone
            ? _value.attendeePhone
            : attendeePhone // ignore: cast_nullable_to_non_nullable
                  as String,
        qrData: null == qrData
            ? _value.qrData
            : qrData // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TicketStatus,
        checkInTime: freezed == checkInTime
            ? _value.checkInTime
            : checkInTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        customFieldData: freezed == customFieldData
            ? _value._customFieldData
            : customFieldData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        issuedAt: freezed == issuedAt
            ? _value.issuedAt
            : issuedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IssuedTicketModelImpl implements _IssuedTicketModel {
  const _$IssuedTicketModelImpl({
    required this.id,
    required this.ticketTypeId,
    required this.eventId,
    required this.attendeeName,
    required this.attendeeEmail,
    required this.attendeePhone,
    required this.qrData,
    this.status = TicketStatus.valid,
    this.checkInTime,
    final Map<String, dynamic>? customFieldData,
    this.issuedAt,
  }) : _customFieldData = customFieldData;

  factory _$IssuedTicketModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssuedTicketModelImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketTypeId;
  @override
  final String eventId;
  @override
  final String attendeeName;
  @override
  final String attendeeEmail;
  @override
  final String attendeePhone;
  @override
  final String qrData;
  @override
  @JsonKey()
  final TicketStatus status;
  @override
  final DateTime? checkInTime;
  final Map<String, dynamic>? _customFieldData;
  @override
  Map<String, dynamic>? get customFieldData {
    final value = _customFieldData;
    if (value == null) return null;
    if (_customFieldData is EqualUnmodifiableMapView) return _customFieldData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? issuedAt;

  @override
  String toString() {
    return 'IssuedTicketModel(id: $id, ticketTypeId: $ticketTypeId, eventId: $eventId, attendeeName: $attendeeName, attendeeEmail: $attendeeEmail, attendeePhone: $attendeePhone, qrData: $qrData, status: $status, checkInTime: $checkInTime, customFieldData: $customFieldData, issuedAt: $issuedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssuedTicketModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketTypeId, ticketTypeId) ||
                other.ticketTypeId == ticketTypeId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.attendeeName, attendeeName) ||
                other.attendeeName == attendeeName) &&
            (identical(other.attendeeEmail, attendeeEmail) ||
                other.attendeeEmail == attendeeEmail) &&
            (identical(other.attendeePhone, attendeePhone) ||
                other.attendeePhone == attendeePhone) &&
            (identical(other.qrData, qrData) || other.qrData == qrData) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            const DeepCollectionEquality().equals(
              other._customFieldData,
              _customFieldData,
            ) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ticketTypeId,
    eventId,
    attendeeName,
    attendeeEmail,
    attendeePhone,
    qrData,
    status,
    checkInTime,
    const DeepCollectionEquality().hash(_customFieldData),
    issuedAt,
  );

  /// Create a copy of IssuedTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssuedTicketModelImplCopyWith<_$IssuedTicketModelImpl> get copyWith =>
      __$$IssuedTicketModelImplCopyWithImpl<_$IssuedTicketModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IssuedTicketModelImplToJson(this);
  }
}

abstract class _IssuedTicketModel implements IssuedTicketModel {
  const factory _IssuedTicketModel({
    required final String id,
    required final String ticketTypeId,
    required final String eventId,
    required final String attendeeName,
    required final String attendeeEmail,
    required final String attendeePhone,
    required final String qrData,
    final TicketStatus status,
    final DateTime? checkInTime,
    final Map<String, dynamic>? customFieldData,
    final DateTime? issuedAt,
  }) = _$IssuedTicketModelImpl;

  factory _IssuedTicketModel.fromJson(Map<String, dynamic> json) =
      _$IssuedTicketModelImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketTypeId;
  @override
  String get eventId;
  @override
  String get attendeeName;
  @override
  String get attendeeEmail;
  @override
  String get attendeePhone;
  @override
  String get qrData;
  @override
  TicketStatus get status;
  @override
  DateTime? get checkInTime;
  @override
  Map<String, dynamic>? get customFieldData;
  @override
  DateTime? get issuedAt;

  /// Create a copy of IssuedTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssuedTicketModelImplCopyWith<_$IssuedTicketModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketDesignModel _$TicketDesignModelFromJson(Map<String, dynamic> json) {
  return _TicketDesignModel.fromJson(json);
}

/// @nodoc
mixin _$TicketDesignModel {
  String get eventId => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get bannerUrl => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  String? get customMessage => throw _privateConstructorUsedError;
  bool get showAttendeeName => throw _privateConstructorUsedError;
  bool get showSeatNumber => throw _privateConstructorUsedError;

  /// Serializes this TicketDesignModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketDesignModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketDesignModelCopyWith<TicketDesignModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketDesignModelCopyWith<$Res> {
  factory $TicketDesignModelCopyWith(
    TicketDesignModel value,
    $Res Function(TicketDesignModel) then,
  ) = _$TicketDesignModelCopyWithImpl<$Res, TicketDesignModel>;
  @useResult
  $Res call({
    String eventId,
    String? logoUrl,
    String? bannerUrl,
    String theme,
    String? customMessage,
    bool showAttendeeName,
    bool showSeatNumber,
  });
}

/// @nodoc
class _$TicketDesignModelCopyWithImpl<$Res, $Val extends TicketDesignModel>
    implements $TicketDesignModelCopyWith<$Res> {
  _$TicketDesignModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketDesignModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? logoUrl = freezed,
    Object? bannerUrl = freezed,
    Object? theme = null,
    Object? customMessage = freezed,
    Object? showAttendeeName = null,
    Object? showSeatNumber = null,
  }) {
    return _then(
      _value.copyWith(
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            bannerUrl: freezed == bannerUrl
                ? _value.bannerUrl
                : bannerUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            theme: null == theme
                ? _value.theme
                : theme // ignore: cast_nullable_to_non_nullable
                      as String,
            customMessage: freezed == customMessage
                ? _value.customMessage
                : customMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            showAttendeeName: null == showAttendeeName
                ? _value.showAttendeeName
                : showAttendeeName // ignore: cast_nullable_to_non_nullable
                      as bool,
            showSeatNumber: null == showSeatNumber
                ? _value.showSeatNumber
                : showSeatNumber // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketDesignModelImplCopyWith<$Res>
    implements $TicketDesignModelCopyWith<$Res> {
  factory _$$TicketDesignModelImplCopyWith(
    _$TicketDesignModelImpl value,
    $Res Function(_$TicketDesignModelImpl) then,
  ) = __$$TicketDesignModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String eventId,
    String? logoUrl,
    String? bannerUrl,
    String theme,
    String? customMessage,
    bool showAttendeeName,
    bool showSeatNumber,
  });
}

/// @nodoc
class __$$TicketDesignModelImplCopyWithImpl<$Res>
    extends _$TicketDesignModelCopyWithImpl<$Res, _$TicketDesignModelImpl>
    implements _$$TicketDesignModelImplCopyWith<$Res> {
  __$$TicketDesignModelImplCopyWithImpl(
    _$TicketDesignModelImpl _value,
    $Res Function(_$TicketDesignModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TicketDesignModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? logoUrl = freezed,
    Object? bannerUrl = freezed,
    Object? theme = null,
    Object? customMessage = freezed,
    Object? showAttendeeName = null,
    Object? showSeatNumber = null,
  }) {
    return _then(
      _$TicketDesignModelImpl(
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        bannerUrl: freezed == bannerUrl
            ? _value.bannerUrl
            : bannerUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        theme: null == theme
            ? _value.theme
            : theme // ignore: cast_nullable_to_non_nullable
                  as String,
        customMessage: freezed == customMessage
            ? _value.customMessage
            : customMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        showAttendeeName: null == showAttendeeName
            ? _value.showAttendeeName
            : showAttendeeName // ignore: cast_nullable_to_non_nullable
                  as bool,
        showSeatNumber: null == showSeatNumber
            ? _value.showSeatNumber
            : showSeatNumber // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketDesignModelImpl implements _TicketDesignModel {
  const _$TicketDesignModelImpl({
    required this.eventId,
    this.logoUrl,
    this.bannerUrl,
    this.theme = 'Minimal',
    this.customMessage,
    this.showAttendeeName = true,
    this.showSeatNumber = false,
  });

  factory _$TicketDesignModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketDesignModelImplFromJson(json);

  @override
  final String eventId;
  @override
  final String? logoUrl;
  @override
  final String? bannerUrl;
  @override
  @JsonKey()
  final String theme;
  @override
  final String? customMessage;
  @override
  @JsonKey()
  final bool showAttendeeName;
  @override
  @JsonKey()
  final bool showSeatNumber;

  @override
  String toString() {
    return 'TicketDesignModel(eventId: $eventId, logoUrl: $logoUrl, bannerUrl: $bannerUrl, theme: $theme, customMessage: $customMessage, showAttendeeName: $showAttendeeName, showSeatNumber: $showSeatNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketDesignModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.customMessage, customMessage) ||
                other.customMessage == customMessage) &&
            (identical(other.showAttendeeName, showAttendeeName) ||
                other.showAttendeeName == showAttendeeName) &&
            (identical(other.showSeatNumber, showSeatNumber) ||
                other.showSeatNumber == showSeatNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    eventId,
    logoUrl,
    bannerUrl,
    theme,
    customMessage,
    showAttendeeName,
    showSeatNumber,
  );

  /// Create a copy of TicketDesignModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketDesignModelImplCopyWith<_$TicketDesignModelImpl> get copyWith =>
      __$$TicketDesignModelImplCopyWithImpl<_$TicketDesignModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketDesignModelImplToJson(this);
  }
}

abstract class _TicketDesignModel implements TicketDesignModel {
  const factory _TicketDesignModel({
    required final String eventId,
    final String? logoUrl,
    final String? bannerUrl,
    final String theme,
    final String? customMessage,
    final bool showAttendeeName,
    final bool showSeatNumber,
  }) = _$TicketDesignModelImpl;

  factory _TicketDesignModel.fromJson(Map<String, dynamic> json) =
      _$TicketDesignModelImpl.fromJson;

  @override
  String get eventId;
  @override
  String? get logoUrl;
  @override
  String? get bannerUrl;
  @override
  String get theme;
  @override
  String? get customMessage;
  @override
  bool get showAttendeeName;
  @override
  bool get showSeatNumber;

  /// Create a copy of TicketDesignModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketDesignModelImplCopyWith<_$TicketDesignModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
