// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  ExpenseStatus get status => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  String? get receiptUrl => throw _privateConstructorUsedError;
  String? get budgetItemId =>
      throw _privateConstructorUsedError; // Reference to the budget planning item
  // Reimbursement Fields
  PaidByType get paidByType => throw _privateConstructorUsedError;
  String? get paidByUserId =>
      throw _privateConstructorUsedError; // ID of the volunteer/member who paid
  bool get isReimbursable => throw _privateConstructorUsedError;
  ReimbursementStatus get reimbursementStatus =>
      throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  String? get paymentMode =>
      throw _privateConstructorUsedError; // UPI, Bank Transfer, Cash
  String? get transactionRef => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
    ExpenseModel value,
    $Res Function(ExpenseModel) then,
  ) = _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    double amount,
    String category,
    DateTime createdAt,
    ExpenseStatus status,
    String? createdBy,
    String? approvedBy,
    DateTime? approvedAt,
    String? receiptUrl,
    String? budgetItemId,
    PaidByType paidByType,
    String? paidByUserId,
    bool isReimbursable,
    ReimbursementStatus reimbursementStatus,
    DateTime? paidAt,
    String? paymentMode,
    String? transactionRef,
    String? rejectionReason,
  });
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? amount = null,
    Object? category = null,
    Object? createdAt = null,
    Object? status = null,
    Object? createdBy = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? receiptUrl = freezed,
    Object? budgetItemId = freezed,
    Object? paidByType = null,
    Object? paidByUserId = freezed,
    Object? isReimbursable = null,
    Object? reimbursementStatus = null,
    Object? paidAt = freezed,
    Object? paymentMode = freezed,
    Object? transactionRef = freezed,
    Object? rejectionReason = freezed,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ExpenseStatus,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            approvedBy: freezed == approvedBy
                ? _value.approvedBy
                : approvedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            approvedAt: freezed == approvedAt
                ? _value.approvedAt
                : approvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            receiptUrl: freezed == receiptUrl
                ? _value.receiptUrl
                : receiptUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            budgetItemId: freezed == budgetItemId
                ? _value.budgetItemId
                : budgetItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paidByType: null == paidByType
                ? _value.paidByType
                : paidByType // ignore: cast_nullable_to_non_nullable
                      as PaidByType,
            paidByUserId: freezed == paidByUserId
                ? _value.paidByUserId
                : paidByUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isReimbursable: null == isReimbursable
                ? _value.isReimbursable
                : isReimbursable // ignore: cast_nullable_to_non_nullable
                      as bool,
            reimbursementStatus: null == reimbursementStatus
                ? _value.reimbursementStatus
                : reimbursementStatus // ignore: cast_nullable_to_non_nullable
                      as ReimbursementStatus,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paymentMode: freezed == paymentMode
                ? _value.paymentMode
                : paymentMode // ignore: cast_nullable_to_non_nullable
                      as String?,
            transactionRef: freezed == transactionRef
                ? _value.transactionRef
                : transactionRef // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
    _$ExpenseModelImpl value,
    $Res Function(_$ExpenseModelImpl) then,
  ) = __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String title,
    double amount,
    String category,
    DateTime createdAt,
    ExpenseStatus status,
    String? createdBy,
    String? approvedBy,
    DateTime? approvedAt,
    String? receiptUrl,
    String? budgetItemId,
    PaidByType paidByType,
    String? paidByUserId,
    bool isReimbursable,
    ReimbursementStatus reimbursementStatus,
    DateTime? paidAt,
    String? paymentMode,
    String? transactionRef,
    String? rejectionReason,
  });
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
    _$ExpenseModelImpl _value,
    $Res Function(_$ExpenseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? title = null,
    Object? amount = null,
    Object? category = null,
    Object? createdAt = null,
    Object? status = null,
    Object? createdBy = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? receiptUrl = freezed,
    Object? budgetItemId = freezed,
    Object? paidByType = null,
    Object? paidByUserId = freezed,
    Object? isReimbursable = null,
    Object? reimbursementStatus = null,
    Object? paidAt = freezed,
    Object? paymentMode = freezed,
    Object? transactionRef = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _$ExpenseModelImpl(
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
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ExpenseStatus,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        approvedBy: freezed == approvedBy
            ? _value.approvedBy
            : approvedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        approvedAt: freezed == approvedAt
            ? _value.approvedAt
            : approvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        receiptUrl: freezed == receiptUrl
            ? _value.receiptUrl
            : receiptUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        budgetItemId: freezed == budgetItemId
            ? _value.budgetItemId
            : budgetItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paidByType: null == paidByType
            ? _value.paidByType
            : paidByType // ignore: cast_nullable_to_non_nullable
                  as PaidByType,
        paidByUserId: freezed == paidByUserId
            ? _value.paidByUserId
            : paidByUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isReimbursable: null == isReimbursable
            ? _value.isReimbursable
            : isReimbursable // ignore: cast_nullable_to_non_nullable
                  as bool,
        reimbursementStatus: null == reimbursementStatus
            ? _value.reimbursementStatus
            : reimbursementStatus // ignore: cast_nullable_to_non_nullable
                  as ReimbursementStatus,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paymentMode: freezed == paymentMode
            ? _value.paymentMode
            : paymentMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        transactionRef: freezed == transactionRef
            ? _value.transactionRef
            : transactionRef // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseModelImpl implements _ExpenseModel {
  const _$ExpenseModelImpl({
    required this.id,
    required this.eventId,
    required this.title,
    required this.amount,
    required this.category,
    required this.createdAt,
    this.status = ExpenseStatus.pending,
    this.createdBy,
    this.approvedBy,
    this.approvedAt,
    this.receiptUrl,
    this.budgetItemId,
    this.paidByType = PaidByType.organizer,
    this.paidByUserId,
    this.isReimbursable = false,
    this.reimbursementStatus = ReimbursementStatus.none,
    this.paidAt,
    this.paymentMode,
    this.transactionRef,
    this.rejectionReason,
  });

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String title;
  @override
  final double amount;
  @override
  final String category;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final ExpenseStatus status;
  @override
  final String? createdBy;
  @override
  final String? approvedBy;
  @override
  final DateTime? approvedAt;
  @override
  final String? receiptUrl;
  @override
  final String? budgetItemId;
  // Reference to the budget planning item
  // Reimbursement Fields
  @override
  @JsonKey()
  final PaidByType paidByType;
  @override
  final String? paidByUserId;
  // ID of the volunteer/member who paid
  @override
  @JsonKey()
  final bool isReimbursable;
  @override
  @JsonKey()
  final ReimbursementStatus reimbursementStatus;
  @override
  final DateTime? paidAt;
  @override
  final String? paymentMode;
  // UPI, Bank Transfer, Cash
  @override
  final String? transactionRef;
  @override
  final String? rejectionReason;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, eventId: $eventId, title: $title, amount: $amount, category: $category, createdAt: $createdAt, status: $status, createdBy: $createdBy, approvedBy: $approvedBy, approvedAt: $approvedAt, receiptUrl: $receiptUrl, budgetItemId: $budgetItemId, paidByType: $paidByType, paidByUserId: $paidByUserId, isReimbursable: $isReimbursable, reimbursementStatus: $reimbursementStatus, paidAt: $paidAt, paymentMode: $paymentMode, transactionRef: $transactionRef, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.budgetItemId, budgetItemId) ||
                other.budgetItemId == budgetItemId) &&
            (identical(other.paidByType, paidByType) ||
                other.paidByType == paidByType) &&
            (identical(other.paidByUserId, paidByUserId) ||
                other.paidByUserId == paidByUserId) &&
            (identical(other.isReimbursable, isReimbursable) ||
                other.isReimbursable == isReimbursable) &&
            (identical(other.reimbursementStatus, reimbursementStatus) ||
                other.reimbursementStatus == reimbursementStatus) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode) &&
            (identical(other.transactionRef, transactionRef) ||
                other.transactionRef == transactionRef) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    eventId,
    title,
    amount,
    category,
    createdAt,
    status,
    createdBy,
    approvedBy,
    approvedAt,
    receiptUrl,
    budgetItemId,
    paidByType,
    paidByUserId,
    isReimbursable,
    reimbursementStatus,
    paidAt,
    paymentMode,
    transactionRef,
    rejectionReason,
  ]);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(this);
  }
}

abstract class _ExpenseModel implements ExpenseModel {
  const factory _ExpenseModel({
    required final String id,
    required final String eventId,
    required final String title,
    required final double amount,
    required final String category,
    required final DateTime createdAt,
    final ExpenseStatus status,
    final String? createdBy,
    final String? approvedBy,
    final DateTime? approvedAt,
    final String? receiptUrl,
    final String? budgetItemId,
    final PaidByType paidByType,
    final String? paidByUserId,
    final bool isReimbursable,
    final ReimbursementStatus reimbursementStatus,
    final DateTime? paidAt,
    final String? paymentMode,
    final String? transactionRef,
    final String? rejectionReason,
  }) = _$ExpenseModelImpl;

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get title;
  @override
  double get amount;
  @override
  String get category;
  @override
  DateTime get createdAt;
  @override
  ExpenseStatus get status;
  @override
  String? get createdBy;
  @override
  String? get approvedBy;
  @override
  DateTime? get approvedAt;
  @override
  String? get receiptUrl;
  @override
  String? get budgetItemId; // Reference to the budget planning item
  // Reimbursement Fields
  @override
  PaidByType get paidByType;
  @override
  String? get paidByUserId; // ID of the volunteer/member who paid
  @override
  bool get isReimbursable;
  @override
  ReimbursementStatus get reimbursementStatus;
  @override
  DateTime? get paidAt;
  @override
  String? get paymentMode; // UPI, Bank Transfer, Cash
  @override
  String? get transactionRef;
  @override
  String? get rejectionReason;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
