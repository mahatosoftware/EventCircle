// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardData {
  EventModel get event => throw _privateConstructorUsedError;
  List<MemberModel> get members => throw _privateConstructorUsedError;
  List<PaymentModel> get payments => throw _privateConstructorUsedError;
  List<ExpenseModel> get expenses => throw _privateConstructorUsedError;
  double get totalCollected => throw _privateConstructorUsedError;
  double get totalExpenses => throw _privateConstructorUsedError;
  double get totalPendingReimbursement => throw _privateConstructorUsedError;
  double get totalPaidReimbursement => throw _privateConstructorUsedError;
  Map<String, MemberModel> get memberMap => throw _privateConstructorUsedError;
  List<PaymentModel> get recentActivities => throw _privateConstructorUsedError;
  Map<String, ModuleAccessLevel> get moduleAccess =>
      throw _privateConstructorUsedError;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
    DashboardData value,
    $Res Function(DashboardData) then,
  ) = _$DashboardDataCopyWithImpl<$Res, DashboardData>;
  @useResult
  $Res call({
    EventModel event,
    List<MemberModel> members,
    List<PaymentModel> payments,
    List<ExpenseModel> expenses,
    double totalCollected,
    double totalExpenses,
    double totalPendingReimbursement,
    double totalPaidReimbursement,
    Map<String, MemberModel> memberMap,
    List<PaymentModel> recentActivities,
    Map<String, ModuleAccessLevel> moduleAccess,
  });

  $EventModelCopyWith<$Res> get event;
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res, $Val extends DashboardData>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardData
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
    Object? totalPendingReimbursement = null,
    Object? totalPaidReimbursement = null,
    Object? memberMap = null,
    Object? recentActivities = null,
    Object? moduleAccess = null,
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
            totalPendingReimbursement: null == totalPendingReimbursement
                ? _value.totalPendingReimbursement
                : totalPendingReimbursement // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPaidReimbursement: null == totalPaidReimbursement
                ? _value.totalPaidReimbursement
                : totalPaidReimbursement // ignore: cast_nullable_to_non_nullable
                      as double,
            memberMap: null == memberMap
                ? _value.memberMap
                : memberMap // ignore: cast_nullable_to_non_nullable
                      as Map<String, MemberModel>,
            recentActivities: null == recentActivities
                ? _value.recentActivities
                : recentActivities // ignore: cast_nullable_to_non_nullable
                      as List<PaymentModel>,
            moduleAccess: null == moduleAccess
                ? _value.moduleAccess
                : moduleAccess // ignore: cast_nullable_to_non_nullable
                      as Map<String, ModuleAccessLevel>,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardData
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
abstract class _$$DashboardDataImplCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$$DashboardDataImplCopyWith(
    _$DashboardDataImpl value,
    $Res Function(_$DashboardDataImpl) then,
  ) = __$$DashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    EventModel event,
    List<MemberModel> members,
    List<PaymentModel> payments,
    List<ExpenseModel> expenses,
    double totalCollected,
    double totalExpenses,
    double totalPendingReimbursement,
    double totalPaidReimbursement,
    Map<String, MemberModel> memberMap,
    List<PaymentModel> recentActivities,
    Map<String, ModuleAccessLevel> moduleAccess,
  });

  @override
  $EventModelCopyWith<$Res> get event;
}

/// @nodoc
class __$$DashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardDataCopyWithImpl<$Res, _$DashboardDataImpl>
    implements _$$DashboardDataImplCopyWith<$Res> {
  __$$DashboardDataImplCopyWithImpl(
    _$DashboardDataImpl _value,
    $Res Function(_$DashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardData
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
    Object? totalPendingReimbursement = null,
    Object? totalPaidReimbursement = null,
    Object? memberMap = null,
    Object? recentActivities = null,
    Object? moduleAccess = null,
  }) {
    return _then(
      _$DashboardDataImpl(
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
        totalPendingReimbursement: null == totalPendingReimbursement
            ? _value.totalPendingReimbursement
            : totalPendingReimbursement // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPaidReimbursement: null == totalPaidReimbursement
            ? _value.totalPaidReimbursement
            : totalPaidReimbursement // ignore: cast_nullable_to_non_nullable
                  as double,
        memberMap: null == memberMap
            ? _value._memberMap
            : memberMap // ignore: cast_nullable_to_non_nullable
                  as Map<String, MemberModel>,
        recentActivities: null == recentActivities
            ? _value._recentActivities
            : recentActivities // ignore: cast_nullable_to_non_nullable
                  as List<PaymentModel>,
        moduleAccess: null == moduleAccess
            ? _value._moduleAccess
            : moduleAccess // ignore: cast_nullable_to_non_nullable
                  as Map<String, ModuleAccessLevel>,
      ),
    );
  }
}

/// @nodoc

class _$DashboardDataImpl implements _DashboardData {
  const _$DashboardDataImpl({
    required this.event,
    required final List<MemberModel> members,
    required final List<PaymentModel> payments,
    required final List<ExpenseModel> expenses,
    required this.totalCollected,
    required this.totalExpenses,
    required this.totalPendingReimbursement,
    required this.totalPaidReimbursement,
    required final Map<String, MemberModel> memberMap,
    required final List<PaymentModel> recentActivities,
    required final Map<String, ModuleAccessLevel> moduleAccess,
  }) : _members = members,
       _payments = payments,
       _expenses = expenses,
       _memberMap = memberMap,
       _recentActivities = recentActivities,
       _moduleAccess = moduleAccess;

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
  @override
  final double totalPendingReimbursement;
  @override
  final double totalPaidReimbursement;
  final Map<String, MemberModel> _memberMap;
  @override
  Map<String, MemberModel> get memberMap {
    if (_memberMap is EqualUnmodifiableMapView) return _memberMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberMap);
  }

  final List<PaymentModel> _recentActivities;
  @override
  List<PaymentModel> get recentActivities {
    if (_recentActivities is EqualUnmodifiableListView)
      return _recentActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivities);
  }

  final Map<String, ModuleAccessLevel> _moduleAccess;
  @override
  Map<String, ModuleAccessLevel> get moduleAccess {
    if (_moduleAccess is EqualUnmodifiableMapView) return _moduleAccess;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_moduleAccess);
  }

  @override
  String toString() {
    return 'DashboardData(event: $event, members: $members, payments: $payments, expenses: $expenses, totalCollected: $totalCollected, totalExpenses: $totalExpenses, totalPendingReimbursement: $totalPendingReimbursement, totalPaidReimbursement: $totalPaidReimbursement, memberMap: $memberMap, recentActivities: $recentActivities, moduleAccess: $moduleAccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataImpl &&
            (identical(other.event, event) || other.event == event) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            (identical(other.totalCollected, totalCollected) ||
                other.totalCollected == totalCollected) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(
                  other.totalPendingReimbursement,
                  totalPendingReimbursement,
                ) ||
                other.totalPendingReimbursement == totalPendingReimbursement) &&
            (identical(other.totalPaidReimbursement, totalPaidReimbursement) ||
                other.totalPaidReimbursement == totalPaidReimbursement) &&
            const DeepCollectionEquality().equals(
              other._memberMap,
              _memberMap,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentActivities,
              _recentActivities,
            ) &&
            const DeepCollectionEquality().equals(
              other._moduleAccess,
              _moduleAccess,
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
    totalPendingReimbursement,
    totalPaidReimbursement,
    const DeepCollectionEquality().hash(_memberMap),
    const DeepCollectionEquality().hash(_recentActivities),
    const DeepCollectionEquality().hash(_moduleAccess),
  );

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      __$$DashboardDataImplCopyWithImpl<_$DashboardDataImpl>(this, _$identity);
}

abstract class _DashboardData implements DashboardData {
  const factory _DashboardData({
    required final EventModel event,
    required final List<MemberModel> members,
    required final List<PaymentModel> payments,
    required final List<ExpenseModel> expenses,
    required final double totalCollected,
    required final double totalExpenses,
    required final double totalPendingReimbursement,
    required final double totalPaidReimbursement,
    required final Map<String, MemberModel> memberMap,
    required final List<PaymentModel> recentActivities,
    required final Map<String, ModuleAccessLevel> moduleAccess,
  }) = _$DashboardDataImpl;

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
  double get totalPendingReimbursement;
  @override
  double get totalPaidReimbursement;
  @override
  Map<String, MemberModel> get memberMap;
  @override
  List<PaymentModel> get recentActivities;
  @override
  Map<String, ModuleAccessLevel> get moduleAccess;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
