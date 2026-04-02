// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BudgetItemModel _$BudgetItemModelFromJson(Map<String, dynamic> json) {
  return _BudgetItemModel.fromJson(json);
}

/// @nodoc
mixin _$BudgetItemModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // Venue, Food, Decoration, Miscellaneous
  String get title => throw _privateConstructorUsedError;
  double get estimatedCost => throw _privateConstructorUsedError;
  bool get isMandatory => throw _privateConstructorUsedError;
  double get actualCost =>
      throw _privateConstructorUsedError; // Updated when an expense is linked
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this BudgetItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetItemModelCopyWith<BudgetItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetItemModelCopyWith<$Res> {
  factory $BudgetItemModelCopyWith(
    BudgetItemModel value,
    $Res Function(BudgetItemModel) then,
  ) = _$BudgetItemModelCopyWithImpl<$Res, BudgetItemModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String category,
    String title,
    double estimatedCost,
    bool isMandatory,
    double actualCost,
    String? note,
  });
}

/// @nodoc
class _$BudgetItemModelCopyWithImpl<$Res, $Val extends BudgetItemModel>
    implements $BudgetItemModelCopyWith<$Res> {
  _$BudgetItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? category = null,
    Object? title = null,
    Object? estimatedCost = null,
    Object? isMandatory = null,
    Object? actualCost = null,
    Object? note = freezed,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedCost: null == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double,
            isMandatory: null == isMandatory
                ? _value.isMandatory
                : isMandatory // ignore: cast_nullable_to_non_nullable
                      as bool,
            actualCost: null == actualCost
                ? _value.actualCost
                : actualCost // ignore: cast_nullable_to_non_nullable
                      as double,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BudgetItemModelImplCopyWith<$Res>
    implements $BudgetItemModelCopyWith<$Res> {
  factory _$$BudgetItemModelImplCopyWith(
    _$BudgetItemModelImpl value,
    $Res Function(_$BudgetItemModelImpl) then,
  ) = __$$BudgetItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String category,
    String title,
    double estimatedCost,
    bool isMandatory,
    double actualCost,
    String? note,
  });
}

/// @nodoc
class __$$BudgetItemModelImplCopyWithImpl<$Res>
    extends _$BudgetItemModelCopyWithImpl<$Res, _$BudgetItemModelImpl>
    implements _$$BudgetItemModelImplCopyWith<$Res> {
  __$$BudgetItemModelImplCopyWithImpl(
    _$BudgetItemModelImpl _value,
    $Res Function(_$BudgetItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BudgetItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? category = null,
    Object? title = null,
    Object? estimatedCost = null,
    Object? isMandatory = null,
    Object? actualCost = null,
    Object? note = freezed,
  }) {
    return _then(
      _$BudgetItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedCost: null == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double,
        isMandatory: null == isMandatory
            ? _value.isMandatory
            : isMandatory // ignore: cast_nullable_to_non_nullable
                  as bool,
        actualCost: null == actualCost
            ? _value.actualCost
            : actualCost // ignore: cast_nullable_to_non_nullable
                  as double,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetItemModelImpl implements _BudgetItemModel {
  const _$BudgetItemModelImpl({
    required this.id,
    required this.eventId,
    required this.category,
    required this.title,
    required this.estimatedCost,
    this.isMandatory = true,
    this.actualCost = 0.0,
    this.note,
  });

  factory _$BudgetItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String category;
  // Venue, Food, Decoration, Miscellaneous
  @override
  final String title;
  @override
  final double estimatedCost;
  @override
  @JsonKey()
  final bool isMandatory;
  @override
  @JsonKey()
  final double actualCost;
  // Updated when an expense is linked
  @override
  final String? note;

  @override
  String toString() {
    return 'BudgetItemModel(id: $id, eventId: $eventId, category: $category, title: $title, estimatedCost: $estimatedCost, isMandatory: $isMandatory, actualCost: $actualCost, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.isMandatory, isMandatory) ||
                other.isMandatory == isMandatory) &&
            (identical(other.actualCost, actualCost) ||
                other.actualCost == actualCost) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    category,
    title,
    estimatedCost,
    isMandatory,
    actualCost,
    note,
  );

  /// Create a copy of BudgetItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetItemModelImplCopyWith<_$BudgetItemModelImpl> get copyWith =>
      __$$BudgetItemModelImplCopyWithImpl<_$BudgetItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetItemModelImplToJson(this);
  }
}

abstract class _BudgetItemModel implements BudgetItemModel {
  const factory _BudgetItemModel({
    required final String id,
    required final String eventId,
    required final String category,
    required final String title,
    required final double estimatedCost,
    final bool isMandatory,
    final double actualCost,
    final String? note,
  }) = _$BudgetItemModelImpl;

  factory _BudgetItemModel.fromJson(Map<String, dynamic> json) =
      _$BudgetItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get category; // Venue, Food, Decoration, Miscellaneous
  @override
  String get title;
  @override
  double get estimatedCost;
  @override
  bool get isMandatory;
  @override
  double get actualCost; // Updated when an expense is linked
  @override
  String? get note;

  /// Create a copy of BudgetItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetItemModelImplCopyWith<_$BudgetItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
