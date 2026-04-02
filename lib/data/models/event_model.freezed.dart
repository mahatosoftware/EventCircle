// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  EventCategory get category => throw _privateConstructorUsedError;
  ContributionType get contributionType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get hybridSettings =>
      throw _privateConstructorUsedError; // e.g. {"fixed": 500, "donation": true}
  String? get location => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  Map<String, double>? get tiers =>
      throw _privateConstructorUsedError; // {'Silver': 500, 'Gold': 1000}
  Map<String, Map<String, dynamic>>? get itemTargets =>
      throw _privateConstructorUsedError; // {'Food': {'target': 10000, 'collected': 0}}
  List<String>? get groups =>
      throw _privateConstructorUsedError; // For group-based tracking
  String? get recurringPeriod =>
      throw _privateConstructorUsedError; // 'monthly', etc.
  String? get note => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get templateSnapshot =>
      throw _privateConstructorUsedError;
  bool get isHybrid => throw _privateConstructorUsedError;
  List<ContributionType> get activeModels => throw _privateConstructorUsedError;
  List<String> get allowedPaymentMethods => throw _privateConstructorUsedError;
  String? get contributionTargetGroup =>
      throw _privateConstructorUsedError; // "All members", "Only heads", etc.
  // Guest Management
  int? get maxGuests => throw _privateConstructorUsedError;
  bool get isRsvpRequired => throw _privateConstructorUsedError;
  List<String> get guestCategories =>
      throw _privateConstructorUsedError; // e.g. ["Family", "VIP", "Member"]
  List<String> get guestMetadataFields =>
      throw _privateConstructorUsedError; // e.g. ["Food Pref", "Allergy"]
  // Expense Tracking
  bool get isExpenseApprovalRequired => throw _privateConstructorUsedError;
  List<String> get expenseCategories => throw _privateConstructorUsedError;

  /// Serializes this EventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
    EventModel value,
    $Res Function(EventModel) then,
  ) = _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String organizerId,
    double amount,
    DateTime createdAt,
    EventCategory category,
    ContributionType contributionType,
    Map<String, dynamic>? hybridSettings,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, double>? tiers,
    Map<String, Map<String, dynamic>>? itemTargets,
    List<String>? groups,
    String? recurringPeriod,
    String? note,
    String? templateId,
    Map<String, dynamic>? templateSnapshot,
    bool isHybrid,
    List<ContributionType> activeModels,
    List<String> allowedPaymentMethods,
    String? contributionTargetGroup,
    int? maxGuests,
    bool isRsvpRequired,
    List<String> guestCategories,
    List<String> guestMetadataFields,
    bool isExpenseApprovalRequired,
    List<String> expenseCategories,
  });
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? organizerId = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? category = null,
    Object? contributionType = null,
    Object? hybridSettings = freezed,
    Object? location = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? tiers = freezed,
    Object? itemTargets = freezed,
    Object? groups = freezed,
    Object? recurringPeriod = freezed,
    Object? note = freezed,
    Object? templateId = freezed,
    Object? templateSnapshot = freezed,
    Object? isHybrid = null,
    Object? activeModels = null,
    Object? allowedPaymentMethods = null,
    Object? contributionTargetGroup = freezed,
    Object? maxGuests = freezed,
    Object? isRsvpRequired = null,
    Object? guestCategories = null,
    Object? guestMetadataFields = null,
    Object? isExpenseApprovalRequired = null,
    Object? expenseCategories = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            organizerId: null == organizerId
                ? _value.organizerId
                : organizerId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as EventCategory,
            contributionType: null == contributionType
                ? _value.contributionType
                : contributionType // ignore: cast_nullable_to_non_nullable
                      as ContributionType,
            hybridSettings: freezed == hybridSettings
                ? _value.hybridSettings
                : hybridSettings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            tiers: freezed == tiers
                ? _value.tiers
                : tiers // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>?,
            itemTargets: freezed == itemTargets
                ? _value.itemTargets
                : itemTargets // ignore: cast_nullable_to_non_nullable
                      as Map<String, Map<String, dynamic>>?,
            groups: freezed == groups
                ? _value.groups
                : groups // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            recurringPeriod: freezed == recurringPeriod
                ? _value.recurringPeriod
                : recurringPeriod // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            templateId: freezed == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
                      as String?,
            templateSnapshot: freezed == templateSnapshot
                ? _value.templateSnapshot
                : templateSnapshot // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isHybrid: null == isHybrid
                ? _value.isHybrid
                : isHybrid // ignore: cast_nullable_to_non_nullable
                      as bool,
            activeModels: null == activeModels
                ? _value.activeModels
                : activeModels // ignore: cast_nullable_to_non_nullable
                      as List<ContributionType>,
            allowedPaymentMethods: null == allowedPaymentMethods
                ? _value.allowedPaymentMethods
                : allowedPaymentMethods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            contributionTargetGroup: freezed == contributionTargetGroup
                ? _value.contributionTargetGroup
                : contributionTargetGroup // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxGuests: freezed == maxGuests
                ? _value.maxGuests
                : maxGuests // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRsvpRequired: null == isRsvpRequired
                ? _value.isRsvpRequired
                : isRsvpRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            guestCategories: null == guestCategories
                ? _value.guestCategories
                : guestCategories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            guestMetadataFields: null == guestMetadataFields
                ? _value.guestMetadataFields
                : guestMetadataFields // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isExpenseApprovalRequired: null == isExpenseApprovalRequired
                ? _value.isExpenseApprovalRequired
                : isExpenseApprovalRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            expenseCategories: null == expenseCategories
                ? _value.expenseCategories
                : expenseCategories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
    _$EventModelImpl value,
    $Res Function(_$EventModelImpl) then,
  ) = __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String organizerId,
    double amount,
    DateTime createdAt,
    EventCategory category,
    ContributionType contributionType,
    Map<String, dynamic>? hybridSettings,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, double>? tiers,
    Map<String, Map<String, dynamic>>? itemTargets,
    List<String>? groups,
    String? recurringPeriod,
    String? note,
    String? templateId,
    Map<String, dynamic>? templateSnapshot,
    bool isHybrid,
    List<ContributionType> activeModels,
    List<String> allowedPaymentMethods,
    String? contributionTargetGroup,
    int? maxGuests,
    bool isRsvpRequired,
    List<String> guestCategories,
    List<String> guestMetadataFields,
    bool isExpenseApprovalRequired,
    List<String> expenseCategories,
  });
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
    _$EventModelImpl _value,
    $Res Function(_$EventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? organizerId = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? category = null,
    Object? contributionType = null,
    Object? hybridSettings = freezed,
    Object? location = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? tiers = freezed,
    Object? itemTargets = freezed,
    Object? groups = freezed,
    Object? recurringPeriod = freezed,
    Object? note = freezed,
    Object? templateId = freezed,
    Object? templateSnapshot = freezed,
    Object? isHybrid = null,
    Object? activeModels = null,
    Object? allowedPaymentMethods = null,
    Object? contributionTargetGroup = freezed,
    Object? maxGuests = freezed,
    Object? isRsvpRequired = null,
    Object? guestCategories = null,
    Object? guestMetadataFields = null,
    Object? isExpenseApprovalRequired = null,
    Object? expenseCategories = null,
  }) {
    return _then(
      _$EventModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        organizerId: null == organizerId
            ? _value.organizerId
            : organizerId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as EventCategory,
        contributionType: null == contributionType
            ? _value.contributionType
            : contributionType // ignore: cast_nullable_to_non_nullable
                  as ContributionType,
        hybridSettings: freezed == hybridSettings
            ? _value._hybridSettings
            : hybridSettings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        tiers: freezed == tiers
            ? _value._tiers
            : tiers // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>?,
        itemTargets: freezed == itemTargets
            ? _value._itemTargets
            : itemTargets // ignore: cast_nullable_to_non_nullable
                  as Map<String, Map<String, dynamic>>?,
        groups: freezed == groups
            ? _value._groups
            : groups // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        recurringPeriod: freezed == recurringPeriod
            ? _value.recurringPeriod
            : recurringPeriod // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        templateId: freezed == templateId
            ? _value.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String?,
        templateSnapshot: freezed == templateSnapshot
            ? _value._templateSnapshot
            : templateSnapshot // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isHybrid: null == isHybrid
            ? _value.isHybrid
            : isHybrid // ignore: cast_nullable_to_non_nullable
                  as bool,
        activeModels: null == activeModels
            ? _value._activeModels
            : activeModels // ignore: cast_nullable_to_non_nullable
                  as List<ContributionType>,
        allowedPaymentMethods: null == allowedPaymentMethods
            ? _value._allowedPaymentMethods
            : allowedPaymentMethods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        contributionTargetGroup: freezed == contributionTargetGroup
            ? _value.contributionTargetGroup
            : contributionTargetGroup // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxGuests: freezed == maxGuests
            ? _value.maxGuests
            : maxGuests // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRsvpRequired: null == isRsvpRequired
            ? _value.isRsvpRequired
            : isRsvpRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        guestCategories: null == guestCategories
            ? _value._guestCategories
            : guestCategories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        guestMetadataFields: null == guestMetadataFields
            ? _value._guestMetadataFields
            : guestMetadataFields // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isExpenseApprovalRequired: null == isExpenseApprovalRequired
            ? _value.isExpenseApprovalRequired
            : isExpenseApprovalRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        expenseCategories: null == expenseCategories
            ? _value._expenseCategories
            : expenseCategories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  const _$EventModelImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.organizerId,
    required this.amount,
    required this.createdAt,
    required this.category,
    required this.contributionType,
    final Map<String, dynamic>? hybridSettings,
    this.location,
    this.startDate,
    this.endDate,
    final Map<String, double>? tiers,
    final Map<String, Map<String, dynamic>>? itemTargets,
    final List<String>? groups,
    this.recurringPeriod,
    this.note,
    this.templateId,
    final Map<String, dynamic>? templateSnapshot,
    this.isHybrid = false,
    final List<ContributionType> activeModels = const [],
    final List<String> allowedPaymentMethods = const ['UPI', 'Cash'],
    this.contributionTargetGroup,
    this.maxGuests,
    this.isRsvpRequired = false,
    final List<String> guestCategories = const [],
    final List<String> guestMetadataFields = const [],
    this.isExpenseApprovalRequired = false,
    final List<String> expenseCategories = const [
      'Venue',
      'Food',
      'Decoration',
      'Miscellaneous',
    ],
  }) : _hybridSettings = hybridSettings,
       _tiers = tiers,
       _itemTargets = itemTargets,
       _groups = groups,
       _templateSnapshot = templateSnapshot,
       _activeModels = activeModels,
       _allowedPaymentMethods = allowedPaymentMethods,
       _guestCategories = guestCategories,
       _guestMetadataFields = guestMetadataFields,
       _expenseCategories = expenseCategories;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String organizerId;
  @override
  final double amount;
  @override
  final DateTime createdAt;
  @override
  final EventCategory category;
  @override
  final ContributionType contributionType;
  final Map<String, dynamic>? _hybridSettings;
  @override
  Map<String, dynamic>? get hybridSettings {
    final value = _hybridSettings;
    if (value == null) return null;
    if (_hybridSettings is EqualUnmodifiableMapView) return _hybridSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // e.g. {"fixed": 500, "donation": true}
  @override
  final String? location;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  final Map<String, double>? _tiers;
  @override
  Map<String, double>? get tiers {
    final value = _tiers;
    if (value == null) return null;
    if (_tiers is EqualUnmodifiableMapView) return _tiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // {'Silver': 500, 'Gold': 1000}
  final Map<String, Map<String, dynamic>>? _itemTargets;
  // {'Silver': 500, 'Gold': 1000}
  @override
  Map<String, Map<String, dynamic>>? get itemTargets {
    final value = _itemTargets;
    if (value == null) return null;
    if (_itemTargets is EqualUnmodifiableMapView) return _itemTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // {'Food': {'target': 10000, 'collected': 0}}
  final List<String>? _groups;
  // {'Food': {'target': 10000, 'collected': 0}}
  @override
  List<String>? get groups {
    final value = _groups;
    if (value == null) return null;
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // For group-based tracking
  @override
  final String? recurringPeriod;
  // 'monthly', etc.
  @override
  final String? note;
  @override
  final String? templateId;
  final Map<String, dynamic>? _templateSnapshot;
  @override
  Map<String, dynamic>? get templateSnapshot {
    final value = _templateSnapshot;
    if (value == null) return null;
    if (_templateSnapshot is EqualUnmodifiableMapView) return _templateSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isHybrid;
  final List<ContributionType> _activeModels;
  @override
  @JsonKey()
  List<ContributionType> get activeModels {
    if (_activeModels is EqualUnmodifiableListView) return _activeModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeModels);
  }

  final List<String> _allowedPaymentMethods;
  @override
  @JsonKey()
  List<String> get allowedPaymentMethods {
    if (_allowedPaymentMethods is EqualUnmodifiableListView)
      return _allowedPaymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedPaymentMethods);
  }

  @override
  final String? contributionTargetGroup;
  // "All members", "Only heads", etc.
  // Guest Management
  @override
  final int? maxGuests;
  @override
  @JsonKey()
  final bool isRsvpRequired;
  final List<String> _guestCategories;
  @override
  @JsonKey()
  List<String> get guestCategories {
    if (_guestCategories is EqualUnmodifiableListView) return _guestCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guestCategories);
  }

  // e.g. ["Family", "VIP", "Member"]
  final List<String> _guestMetadataFields;
  // e.g. ["Family", "VIP", "Member"]
  @override
  @JsonKey()
  List<String> get guestMetadataFields {
    if (_guestMetadataFields is EqualUnmodifiableListView)
      return _guestMetadataFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guestMetadataFields);
  }

  // e.g. ["Food Pref", "Allergy"]
  // Expense Tracking
  @override
  @JsonKey()
  final bool isExpenseApprovalRequired;
  final List<String> _expenseCategories;
  @override
  @JsonKey()
  List<String> get expenseCategories {
    if (_expenseCategories is EqualUnmodifiableListView)
      return _expenseCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseCategories);
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, description: $description, organizerId: $organizerId, amount: $amount, createdAt: $createdAt, category: $category, contributionType: $contributionType, hybridSettings: $hybridSettings, location: $location, startDate: $startDate, endDate: $endDate, tiers: $tiers, itemTargets: $itemTargets, groups: $groups, recurringPeriod: $recurringPeriod, note: $note, templateId: $templateId, templateSnapshot: $templateSnapshot, isHybrid: $isHybrid, activeModels: $activeModels, allowedPaymentMethods: $allowedPaymentMethods, contributionTargetGroup: $contributionTargetGroup, maxGuests: $maxGuests, isRsvpRequired: $isRsvpRequired, guestCategories: $guestCategories, guestMetadataFields: $guestMetadataFields, isExpenseApprovalRequired: $isExpenseApprovalRequired, expenseCategories: $expenseCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.contributionType, contributionType) ||
                other.contributionType == contributionType) &&
            const DeepCollectionEquality().equals(
              other._hybridSettings,
              _hybridSettings,
            ) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._tiers, _tiers) &&
            const DeepCollectionEquality().equals(
              other._itemTargets,
              _itemTargets,
            ) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            (identical(other.recurringPeriod, recurringPeriod) ||
                other.recurringPeriod == recurringPeriod) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            const DeepCollectionEquality().equals(
              other._templateSnapshot,
              _templateSnapshot,
            ) &&
            (identical(other.isHybrid, isHybrid) ||
                other.isHybrid == isHybrid) &&
            const DeepCollectionEquality().equals(
              other._activeModels,
              _activeModels,
            ) &&
            const DeepCollectionEquality().equals(
              other._allowedPaymentMethods,
              _allowedPaymentMethods,
            ) &&
            (identical(
                  other.contributionTargetGroup,
                  contributionTargetGroup,
                ) ||
                other.contributionTargetGroup == contributionTargetGroup) &&
            (identical(other.maxGuests, maxGuests) ||
                other.maxGuests == maxGuests) &&
            (identical(other.isRsvpRequired, isRsvpRequired) ||
                other.isRsvpRequired == isRsvpRequired) &&
            const DeepCollectionEquality().equals(
              other._guestCategories,
              _guestCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._guestMetadataFields,
              _guestMetadataFields,
            ) &&
            (identical(
                  other.isExpenseApprovalRequired,
                  isExpenseApprovalRequired,
                ) ||
                other.isExpenseApprovalRequired == isExpenseApprovalRequired) &&
            const DeepCollectionEquality().equals(
              other._expenseCategories,
              _expenseCategories,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    organizerId,
    amount,
    createdAt,
    category,
    contributionType,
    const DeepCollectionEquality().hash(_hybridSettings),
    location,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_tiers),
    const DeepCollectionEquality().hash(_itemTargets),
    const DeepCollectionEquality().hash(_groups),
    recurringPeriod,
    note,
    templateId,
    const DeepCollectionEquality().hash(_templateSnapshot),
    isHybrid,
    const DeepCollectionEquality().hash(_activeModels),
    const DeepCollectionEquality().hash(_allowedPaymentMethods),
    contributionTargetGroup,
    maxGuests,
    isRsvpRequired,
    const DeepCollectionEquality().hash(_guestCategories),
    const DeepCollectionEquality().hash(_guestMetadataFields),
    isExpenseApprovalRequired,
    const DeepCollectionEquality().hash(_expenseCategories),
  ]);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(this);
  }
}

abstract class _EventModel implements EventModel {
  const factory _EventModel({
    required final String id,
    required final String title,
    required final String description,
    required final String organizerId,
    required final double amount,
    required final DateTime createdAt,
    required final EventCategory category,
    required final ContributionType contributionType,
    final Map<String, dynamic>? hybridSettings,
    final String? location,
    final DateTime? startDate,
    final DateTime? endDate,
    final Map<String, double>? tiers,
    final Map<String, Map<String, dynamic>>? itemTargets,
    final List<String>? groups,
    final String? recurringPeriod,
    final String? note,
    final String? templateId,
    final Map<String, dynamic>? templateSnapshot,
    final bool isHybrid,
    final List<ContributionType> activeModels,
    final List<String> allowedPaymentMethods,
    final String? contributionTargetGroup,
    final int? maxGuests,
    final bool isRsvpRequired,
    final List<String> guestCategories,
    final List<String> guestMetadataFields,
    final bool isExpenseApprovalRequired,
    final List<String> expenseCategories,
  }) = _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get organizerId;
  @override
  double get amount;
  @override
  DateTime get createdAt;
  @override
  EventCategory get category;
  @override
  ContributionType get contributionType;
  @override
  Map<String, dynamic>? get hybridSettings; // e.g. {"fixed": 500, "donation": true}
  @override
  String? get location;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  Map<String, double>? get tiers; // {'Silver': 500, 'Gold': 1000}
  @override
  Map<String, Map<String, dynamic>>? get itemTargets; // {'Food': {'target': 10000, 'collected': 0}}
  @override
  List<String>? get groups; // For group-based tracking
  @override
  String? get recurringPeriod; // 'monthly', etc.
  @override
  String? get note;
  @override
  String? get templateId;
  @override
  Map<String, dynamic>? get templateSnapshot;
  @override
  bool get isHybrid;
  @override
  List<ContributionType> get activeModels;
  @override
  List<String> get allowedPaymentMethods;
  @override
  String? get contributionTargetGroup; // "All members", "Only heads", etc.
  // Guest Management
  @override
  int? get maxGuests;
  @override
  bool get isRsvpRequired;
  @override
  List<String> get guestCategories; // e.g. ["Family", "VIP", "Member"]
  @override
  List<String> get guestMetadataFields; // e.g. ["Food Pref", "Allergy"]
  // Expense Tracking
  @override
  bool get isExpenseApprovalRequired;
  @override
  List<String> get expenseCategories;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
