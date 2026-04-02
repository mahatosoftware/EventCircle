// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_dashboard_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PublicDashboardData {
  EventModel get event => throw _privateConstructorUsedError;
  List<MemberModel> get members => throw _privateConstructorUsedError;
  List<PaymentModel> get payments => throw _privateConstructorUsedError;
  List<ExpenseModel> get expenses => throw _privateConstructorUsedError;
  double get totalCollected => throw _privateConstructorUsedError;
  double get totalExpenses => throw _privateConstructorUsedError;
  Map<String, PaymentModel> get memberPaymentMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of PublicDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicDashboardDataCopyWith<PublicDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicDashboardDataCopyWith<$Res> {
  factory $PublicDashboardDataCopyWith(
    PublicDashboardData value,
    $Res Function(PublicDashboardData) then,
  ) = _$PublicDashboardDataCopyWithImpl<$Res, PublicDashboardData>;
  @useResult
  $Res call({
    EventModel event,
    List<MemberModel> members,
    List<PaymentModel> payments,
    List<ExpenseModel> expenses,
    double totalCollected,
    double totalExpenses,
    Map<String, PaymentModel> memberPaymentMap,
  });

  $EventModelCopyWith<$Res> get event;
}

/// @nodoc
class _$PublicDashboardDataCopyWithImpl<$Res, $Val extends PublicDashboardData>
    implements $PublicDashboardDataCopyWith<$Res> {
  _$PublicDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? members = null,
    Object? payments = null,
    Object? expenses = null,
    Object? totalCollected = null,
    Object? totalExpenses = null,
    Object? memberPaymentMap = null,
  }) {
    return _then(
      _value.copyWith(
            event: null == event
                ? _value.event
                : event // ignore: cast_nullable_to_non_nullable
                      as EventModel,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<MemberModel>,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<PaymentModel>,
            expenses: null == expenses
                ? _value.expenses
                : expenses // ignore: cast_nullable_to_non_nullable
                      as List<ExpenseModel>,
            totalCollected: null == totalCollected
                ? _value.totalCollected
                : totalCollected // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            memberPaymentMap: null == memberPaymentMap
                ? _value.memberPaymentMap
                : memberPaymentMap // ignore: cast_nullable_to_non_nullable
                      as Map<String, PaymentModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of PublicDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventModelCopyWith<$Res> get event {
    return $EventModelCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PublicDashboardDataImplCopyWith<$Res>
    implements $PublicDashboardDataCopyWith<$Res> {
  factory _$$PublicDashboardDataImplCopyWith(
    _$PublicDashboardDataImpl value,
    $Res Function(_$PublicDashboardDataImpl) then,
  ) = __$$PublicDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    EventModel event,
    List<MemberModel> members,
    List<PaymentModel> payments,
    List<ExpenseModel> expenses,
    double totalCollected,
    double totalExpenses,
    Map<String, PaymentModel> memberPaymentMap,
  });

  @override
  $EventModelCopyWith<$Res> get event;
}

/// @nodoc
class __$$PublicDashboardDataImplCopyWithImpl<$Res>
    extends _$PublicDashboardDataCopyWithImpl<$Res, _$PublicDashboardDataImpl>
    implements _$$PublicDashboardDataImplCopyWith<$Res> {
  __$$PublicDashboardDataImplCopyWithImpl(
    _$PublicDashboardDataImpl _value,
    $Res Function(_$PublicDashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? members = null,
    Object? payments = null,
    Object? expenses = null,
    Object? totalCollected = null,
    Object? totalExpenses = null,
    Object? memberPaymentMap = null,
  }) {
    return _then(
      _$PublicDashboardDataImpl(
        event: null == event
            ? _value.event
            : event // ignore: cast_nullable_to_non_nullable
                  as EventModel,
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberModel>,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<PaymentModel>,
        expenses: null == expenses
            ? _value._expenses
            : expenses // ignore: cast_nullable_to_non_nullable
                  as List<ExpenseModel>,
        totalCollected: null == totalCollected
            ? _value.totalCollected
            : totalCollected // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        memberPaymentMap: null == memberPaymentMap
            ? _value._memberPaymentMap
            : memberPaymentMap // ignore: cast_nullable_to_non_nullable
                  as Map<String, PaymentModel>,
      ),
    );
  }
}

/// @nodoc

class _$PublicDashboardDataImpl implements _PublicDashboardData {
  const _$PublicDashboardDataImpl({
    required this.event,
    required final List<MemberModel> members,
    required final List<PaymentModel> payments,
    required final List<ExpenseModel> expenses,
    required this.totalCollected,
    required this.totalExpenses,
    required final Map<String, PaymentModel> memberPaymentMap,
  }) : _members = members,
       _payments = payments,
       _expenses = expenses,
       _memberPaymentMap = memberPaymentMap;

  @override
  final EventModel event;
  final List<MemberModel> _members;
  @override
  List<MemberModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<PaymentModel> _payments;
  @override
  List<PaymentModel> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  final List<ExpenseModel> _expenses;
  @override
  List<ExpenseModel> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

  @override
  final double totalCollected;
  @override
  final double totalExpenses;
  final Map<String, PaymentModel> _memberPaymentMap;
  @override
  Map<String, PaymentModel> get memberPaymentMap {
    if (_memberPaymentMap is EqualUnmodifiableMapView) return _memberPaymentMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberPaymentMap);
  }

  @override
  String toString() {
    return 'PublicDashboardData(event: $event, members: $members, payments: $payments, expenses: $expenses, totalCollected: $totalCollected, totalExpenses: $totalExpenses, memberPaymentMap: $memberPaymentMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicDashboardDataImpl &&
            (identical(other.event, event) || other.event == event) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            (identical(other.totalCollected, totalCollected) ||
                other.totalCollected == totalCollected) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            const DeepCollectionEquality().equals(
              other._memberPaymentMap,
              _memberPaymentMap,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    event,
    const DeepCollectionEquality().hash(_members),
    const DeepCollectionEquality().hash(_payments),
    const DeepCollectionEquality().hash(_expenses),
    totalCollected,
    totalExpenses,
    const DeepCollectionEquality().hash(_memberPaymentMap),
  );

  /// Create a copy of PublicDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicDashboardDataImplCopyWith<_$PublicDashboardDataImpl> get copyWith =>
      __$$PublicDashboardDataImplCopyWithImpl<_$PublicDashboardDataImpl>(
        this,
        _$identity,
      );
}

abstract class _PublicDashboardData implements PublicDashboardData {
  const factory _PublicDashboardData({
    required final EventModel event,
    required final List<MemberModel> members,
    required final List<PaymentModel> payments,
    required final List<ExpenseModel> expenses,
    required final double totalCollected,
    required final double totalExpenses,
    required final Map<String, PaymentModel> memberPaymentMap,
  }) = _$PublicDashboardDataImpl;

  @override
  EventModel get event;
  @override
  List<MemberModel> get members;
  @override
  List<PaymentModel> get payments;
  @override
  List<ExpenseModel> get expenses;
  @override
  double get totalCollected;
  @override
  double get totalExpenses;
  @override
  Map<String, PaymentModel> get memberPaymentMap;

  /// Create a copy of PublicDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicDashboardDataImplCopyWith<_$PublicDashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
