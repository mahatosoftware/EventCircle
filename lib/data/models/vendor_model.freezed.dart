// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) {
  return _VendorModel.fromJson(json);
}

/// @nodoc
mixin _$VendorModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get title =>
      throw _privateConstructorUsedError; // e.g. "Catering Service"
  String get role =>
      throw _privateConstructorUsedError; // e.g. "Food and Beverages"
  VendorStatus get status => throw _privateConstructorUsedError;
  String? get name =>
      throw _privateConstructorUsedError; // Actual vendor name after selection
  String? get contact => throw _privateConstructorUsedError;
  String? get selectionCriteria => throw _privateConstructorUsedError;
  String? get suggestions =>
      throw _privateConstructorUsedError; // AI/Blueprint suggestions
  double? get quotedPrice => throw _privateConstructorUsedError;
  double? get finalPrice => throw _privateConstructorUsedError;

  /// Serializes this VendorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorModelCopyWith<VendorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorModelCopyWith<$Res> {
  factory $VendorModelCopyWith(
    VendorModel value,
    $Res Function(VendorModel) then,
  ) = _$VendorModelCopyWithImpl<$Res, VendorModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    String role,
    VendorStatus status,
    String? name,
    String? contact,
    String? selectionCriteria,
    String? suggestions,
    double? quotedPrice,
    double? finalPrice,
  });
}

/// @nodoc
class _$VendorModelCopyWithImpl<$Res, $Val extends VendorModel>
    implements $VendorModelCopyWith<$Res> {
  _$VendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? role = null,
    Object? status = null,
    Object? name = freezed,
    Object? contact = freezed,
    Object? selectionCriteria = freezed,
    Object? suggestions = freezed,
    Object? quotedPrice = freezed,
    Object? finalPrice = freezed,
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
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as VendorStatus,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            contact: freezed == contact
                ? _value.contact
                : contact // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectionCriteria: freezed == selectionCriteria
                ? _value.selectionCriteria
                : selectionCriteria // ignore: cast_nullable_to_non_nullable
                      as String?,
            suggestions: freezed == suggestions
                ? _value.suggestions
                : suggestions // ignore: cast_nullable_to_non_nullable
                      as String?,
            quotedPrice: freezed == quotedPrice
                ? _value.quotedPrice
                : quotedPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            finalPrice: freezed == finalPrice
                ? _value.finalPrice
                : finalPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VendorModelImplCopyWith<$Res>
    implements $VendorModelCopyWith<$Res> {
  factory _$$VendorModelImplCopyWith(
    _$VendorModelImpl value,
    $Res Function(_$VendorModelImpl) then,
  ) = __$$VendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    String role,
    VendorStatus status,
    String? name,
    String? contact,
    String? selectionCriteria,
    String? suggestions,
    double? quotedPrice,
    double? finalPrice,
  });
}

/// @nodoc
class __$$VendorModelImplCopyWithImpl<$Res>
    extends _$VendorModelCopyWithImpl<$Res, _$VendorModelImpl>
    implements _$$VendorModelImplCopyWith<$Res> {
  __$$VendorModelImplCopyWithImpl(
    _$VendorModelImpl _value,
    $Res Function(_$VendorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? role = null,
    Object? status = null,
    Object? name = freezed,
    Object? contact = freezed,
    Object? selectionCriteria = freezed,
    Object? suggestions = freezed,
    Object? quotedPrice = freezed,
    Object? finalPrice = freezed,
  }) {
    return _then(
      _$VendorModelImpl(
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
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as VendorStatus,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        contact: freezed == contact
            ? _value.contact
            : contact // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectionCriteria: freezed == selectionCriteria
            ? _value.selectionCriteria
            : selectionCriteria // ignore: cast_nullable_to_non_nullable
                  as String?,
        suggestions: freezed == suggestions
            ? _value.suggestions
            : suggestions // ignore: cast_nullable_to_non_nullable
                  as String?,
        quotedPrice: freezed == quotedPrice
            ? _value.quotedPrice
            : quotedPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        finalPrice: freezed == finalPrice
            ? _value.finalPrice
            : finalPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorModelImpl implements _VendorModel {
  const _$VendorModelImpl({
    required this.id,
    required this.eventId,
    required this.title,
    required this.role,
    this.status = VendorStatus.searching,
    this.name,
    this.contact,
    this.selectionCriteria,
    this.suggestions,
    this.quotedPrice,
    this.finalPrice,
  });

  factory _$VendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String title;
  // e.g. "Catering Service"
  @override
  final String role;
  // e.g. "Food and Beverages"
  @override
  @JsonKey()
  final VendorStatus status;
  @override
  final String? name;
  // Actual vendor name after selection
  @override
  final String? contact;
  @override
  final String? selectionCriteria;
  @override
  final String? suggestions;
  // AI/Blueprint suggestions
  @override
  final double? quotedPrice;
  @override
  final double? finalPrice;

  @override
  String toString() {
    return 'VendorModel(id: $id, eventId: $eventId, title: $title, role: $role, status: $status, name: $name, contact: $contact, selectionCriteria: $selectionCriteria, suggestions: $suggestions, quotedPrice: $quotedPrice, finalPrice: $finalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.selectionCriteria, selectionCriteria) ||
                other.selectionCriteria == selectionCriteria) &&
            (identical(other.suggestions, suggestions) ||
                other.suggestions == suggestions) &&
            (identical(other.quotedPrice, quotedPrice) ||
                other.quotedPrice == quotedPrice) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    title,
    role,
    status,
    name,
    contact,
    selectionCriteria,
    suggestions,
    quotedPrice,
    finalPrice,
  );

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      __$$VendorModelImplCopyWithImpl<_$VendorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorModelImplToJson(this);
  }
}

abstract class _VendorModel implements VendorModel {
  const factory _VendorModel({
    required final String id,
    required final String eventId,
    required final String title,
    required final String role,
    final VendorStatus status,
    final String? name,
    final String? contact,
    final String? selectionCriteria,
    final String? suggestions,
    final double? quotedPrice,
    final double? finalPrice,
  }) = _$VendorModelImpl;

  factory _VendorModel.fromJson(Map<String, dynamic> json) =
      _$VendorModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get title; // e.g. "Catering Service"
  @override
  String get role; // e.g. "Food and Beverages"
  @override
  VendorStatus get status;
  @override
  String? get name; // Actual vendor name after selection
  @override
  String? get contact;
  @override
  String? get selectionCriteria;
  @override
  String? get suggestions; // AI/Blueprint suggestions
  @override
  double? get quotedPrice;
  @override
  double? get finalPrice;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
