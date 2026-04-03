// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TemplateModel _$TemplateModelFromJson(Map<String, dynamic> json) {
  return _TemplateModel.fromJson(json);
}

/// @nodoc
mixin _$TemplateModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  EventCategory get category => throw _privateConstructorUsedError;
  ContributionType get contributionType => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get config =>
      throw _privateConstructorUsedError; // Holds contribution, guest, and expense configs as needed
  List<TaskModel> get taskBlueprints => throw _privateConstructorUsedError;
  List<TimelineItemModel> get timelineBlueprints =>
      throw _privateConstructorUsedError;
  List<VendorModel> get vendorBlueprints => throw _privateConstructorUsedError;
  List<InventoryItemModel> get inventoryBlueprints =>
      throw _privateConstructorUsedError;
  List<RoleDefinitionModel> get roleBlueprints =>
      throw _privateConstructorUsedError;
  List<LocationModel> get venueBlueprints => throw _privateConstructorUsedError;
  List<TicketModel> get ticketBlueprints => throw _privateConstructorUsedError;
  List<CustomFieldDefinitionModel> get customFieldBlueprints =>
      throw _privateConstructorUsedError;
  List<AnnouncementModel> get announcementBlueprints =>
      throw _privateConstructorUsedError;
  List<BudgetItemModel> get budgetBlueprints =>
      throw _privateConstructorUsedError;
  List<TemplateModule> get enabledModules => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  String? get templateCode => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateModelCopyWith<TemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateModelCopyWith<$Res> {
  factory $TemplateModelCopyWith(
    TemplateModel value,
    $Res Function(TemplateModel) then,
  ) = _$TemplateModelCopyWithImpl<$Res, TemplateModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    EventCategory category,
    ContributionType contributionType,
    String createdBy,
    List<String> tags,
    Map<String, dynamic>? config,
    List<TaskModel> taskBlueprints,
    List<TimelineItemModel> timelineBlueprints,
    List<VendorModel> vendorBlueprints,
    List<InventoryItemModel> inventoryBlueprints,
    List<RoleDefinitionModel> roleBlueprints,
    List<LocationModel> venueBlueprints,
    List<TicketModel> ticketBlueprints,
    List<CustomFieldDefinitionModel> customFieldBlueprints,
    List<AnnouncementModel> announcementBlueprints,
    List<BudgetItemModel> budgetBlueprints,
    List<TemplateModule> enabledModules,
    int usageCount,
    double rating,
    bool isPublic,
    int version,
    String? templateCode,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$TemplateModelCopyWithImpl<$Res, $Val extends TemplateModel>
    implements $TemplateModelCopyWith<$Res> {
  _$TemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? contributionType = null,
    Object? createdBy = null,
    Object? tags = null,
    Object? config = freezed,
    Object? taskBlueprints = null,
    Object? timelineBlueprints = null,
    Object? vendorBlueprints = null,
    Object? inventoryBlueprints = null,
    Object? roleBlueprints = null,
    Object? venueBlueprints = null,
    Object? ticketBlueprints = null,
    Object? customFieldBlueprints = null,
    Object? announcementBlueprints = null,
    Object? budgetBlueprints = null,
    Object? enabledModules = null,
    Object? usageCount = null,
    Object? rating = null,
    Object? isPublic = null,
    Object? version = null,
    Object? templateCode = freezed,
    Object? createdAt = freezed,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as EventCategory,
            contributionType: null == contributionType
                ? _value.contributionType
                : contributionType // ignore: cast_nullable_to_non_nullable
                      as ContributionType,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            config: freezed == config
                ? _value.config
                : config // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            taskBlueprints: null == taskBlueprints
                ? _value.taskBlueprints
                : taskBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<TaskModel>,
            timelineBlueprints: null == timelineBlueprints
                ? _value.timelineBlueprints
                : timelineBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<TimelineItemModel>,
            vendorBlueprints: null == vendorBlueprints
                ? _value.vendorBlueprints
                : vendorBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<VendorModel>,
            inventoryBlueprints: null == inventoryBlueprints
                ? _value.inventoryBlueprints
                : inventoryBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<InventoryItemModel>,
            roleBlueprints: null == roleBlueprints
                ? _value.roleBlueprints
                : roleBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<RoleDefinitionModel>,
            venueBlueprints: null == venueBlueprints
                ? _value.venueBlueprints
                : venueBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<LocationModel>,
            ticketBlueprints: null == ticketBlueprints
                ? _value.ticketBlueprints
                : ticketBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<TicketModel>,
            customFieldBlueprints: null == customFieldBlueprints
                ? _value.customFieldBlueprints
                : customFieldBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<CustomFieldDefinitionModel>,
            announcementBlueprints: null == announcementBlueprints
                ? _value.announcementBlueprints
                : announcementBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<AnnouncementModel>,
            budgetBlueprints: null == budgetBlueprints
                ? _value.budgetBlueprints
                : budgetBlueprints // ignore: cast_nullable_to_non_nullable
                      as List<BudgetItemModel>,
            enabledModules: null == enabledModules
                ? _value.enabledModules
                : enabledModules // ignore: cast_nullable_to_non_nullable
                      as List<TemplateModule>,
            usageCount: null == usageCount
                ? _value.usageCount
                : usageCount // ignore: cast_nullable_to_non_nullable
                      as int,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            templateCode: freezed == templateCode
                ? _value.templateCode
                : templateCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TemplateModelImplCopyWith<$Res>
    implements $TemplateModelCopyWith<$Res> {
  factory _$$TemplateModelImplCopyWith(
    _$TemplateModelImpl value,
    $Res Function(_$TemplateModelImpl) then,
  ) = __$$TemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    EventCategory category,
    ContributionType contributionType,
    String createdBy,
    List<String> tags,
    Map<String, dynamic>? config,
    List<TaskModel> taskBlueprints,
    List<TimelineItemModel> timelineBlueprints,
    List<VendorModel> vendorBlueprints,
    List<InventoryItemModel> inventoryBlueprints,
    List<RoleDefinitionModel> roleBlueprints,
    List<LocationModel> venueBlueprints,
    List<TicketModel> ticketBlueprints,
    List<CustomFieldDefinitionModel> customFieldBlueprints,
    List<AnnouncementModel> announcementBlueprints,
    List<BudgetItemModel> budgetBlueprints,
    List<TemplateModule> enabledModules,
    int usageCount,
    double rating,
    bool isPublic,
    int version,
    String? templateCode,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$TemplateModelImplCopyWithImpl<$Res>
    extends _$TemplateModelCopyWithImpl<$Res, _$TemplateModelImpl>
    implements _$$TemplateModelImplCopyWith<$Res> {
  __$$TemplateModelImplCopyWithImpl(
    _$TemplateModelImpl _value,
    $Res Function(_$TemplateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? contributionType = null,
    Object? createdBy = null,
    Object? tags = null,
    Object? config = freezed,
    Object? taskBlueprints = null,
    Object? timelineBlueprints = null,
    Object? vendorBlueprints = null,
    Object? inventoryBlueprints = null,
    Object? roleBlueprints = null,
    Object? venueBlueprints = null,
    Object? ticketBlueprints = null,
    Object? customFieldBlueprints = null,
    Object? announcementBlueprints = null,
    Object? budgetBlueprints = null,
    Object? enabledModules = null,
    Object? usageCount = null,
    Object? rating = null,
    Object? isPublic = null,
    Object? version = null,
    Object? templateCode = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TemplateModelImpl(
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
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as EventCategory,
        contributionType: null == contributionType
            ? _value.contributionType
            : contributionType // ignore: cast_nullable_to_non_nullable
                  as ContributionType,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        config: freezed == config
            ? _value._config
            : config // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        taskBlueprints: null == taskBlueprints
            ? _value._taskBlueprints
            : taskBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<TaskModel>,
        timelineBlueprints: null == timelineBlueprints
            ? _value._timelineBlueprints
            : timelineBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<TimelineItemModel>,
        vendorBlueprints: null == vendorBlueprints
            ? _value._vendorBlueprints
            : vendorBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<VendorModel>,
        inventoryBlueprints: null == inventoryBlueprints
            ? _value._inventoryBlueprints
            : inventoryBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<InventoryItemModel>,
        roleBlueprints: null == roleBlueprints
            ? _value._roleBlueprints
            : roleBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<RoleDefinitionModel>,
        venueBlueprints: null == venueBlueprints
            ? _value._venueBlueprints
            : venueBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<LocationModel>,
        ticketBlueprints: null == ticketBlueprints
            ? _value._ticketBlueprints
            : ticketBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<TicketModel>,
        customFieldBlueprints: null == customFieldBlueprints
            ? _value._customFieldBlueprints
            : customFieldBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<CustomFieldDefinitionModel>,
        announcementBlueprints: null == announcementBlueprints
            ? _value._announcementBlueprints
            : announcementBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<AnnouncementModel>,
        budgetBlueprints: null == budgetBlueprints
            ? _value._budgetBlueprints
            : budgetBlueprints // ignore: cast_nullable_to_non_nullable
                  as List<BudgetItemModel>,
        enabledModules: null == enabledModules
            ? _value._enabledModules
            : enabledModules // ignore: cast_nullable_to_non_nullable
                  as List<TemplateModule>,
        usageCount: null == usageCount
            ? _value.usageCount
            : usageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        templateCode: freezed == templateCode
            ? _value.templateCode
            : templateCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateModelImpl implements _TemplateModel {
  const _$TemplateModelImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.contributionType,
    required this.createdBy,
    final List<String> tags = const [],
    final Map<String, dynamic>? config,
    final List<TaskModel> taskBlueprints = const [],
    final List<TimelineItemModel> timelineBlueprints = const [],
    final List<VendorModel> vendorBlueprints = const [],
    final List<InventoryItemModel> inventoryBlueprints = const [],
    final List<RoleDefinitionModel> roleBlueprints = const [],
    final List<LocationModel> venueBlueprints = const [],
    final List<TicketModel> ticketBlueprints = const [],
    final List<CustomFieldDefinitionModel> customFieldBlueprints = const [],
    final List<AnnouncementModel> announcementBlueprints = const [],
    final List<BudgetItemModel> budgetBlueprints = const [],
    final List<TemplateModule> enabledModules = const [],
    this.usageCount = 0,
    this.rating = 0.0,
    this.isPublic = true,
    this.version = 1,
    this.templateCode,
    this.createdAt,
  }) : _tags = tags,
       _config = config,
       _taskBlueprints = taskBlueprints,
       _timelineBlueprints = timelineBlueprints,
       _vendorBlueprints = vendorBlueprints,
       _inventoryBlueprints = inventoryBlueprints,
       _roleBlueprints = roleBlueprints,
       _venueBlueprints = venueBlueprints,
       _ticketBlueprints = ticketBlueprints,
       _customFieldBlueprints = customFieldBlueprints,
       _announcementBlueprints = announcementBlueprints,
       _budgetBlueprints = budgetBlueprints,
       _enabledModules = enabledModules;

  factory _$TemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final EventCategory category;
  @override
  final ContributionType contributionType;
  @override
  final String createdBy;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final Map<String, dynamic>? _config;
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Holds contribution, guest, and expense configs as needed
  final List<TaskModel> _taskBlueprints;
  // Holds contribution, guest, and expense configs as needed
  @override
  @JsonKey()
  List<TaskModel> get taskBlueprints {
    if (_taskBlueprints is EqualUnmodifiableListView) return _taskBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskBlueprints);
  }

  final List<TimelineItemModel> _timelineBlueprints;
  @override
  @JsonKey()
  List<TimelineItemModel> get timelineBlueprints {
    if (_timelineBlueprints is EqualUnmodifiableListView)
      return _timelineBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timelineBlueprints);
  }

  final List<VendorModel> _vendorBlueprints;
  @override
  @JsonKey()
  List<VendorModel> get vendorBlueprints {
    if (_vendorBlueprints is EqualUnmodifiableListView)
      return _vendorBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vendorBlueprints);
  }

  final List<InventoryItemModel> _inventoryBlueprints;
  @override
  @JsonKey()
  List<InventoryItemModel> get inventoryBlueprints {
    if (_inventoryBlueprints is EqualUnmodifiableListView)
      return _inventoryBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inventoryBlueprints);
  }

  final List<RoleDefinitionModel> _roleBlueprints;
  @override
  @JsonKey()
  List<RoleDefinitionModel> get roleBlueprints {
    if (_roleBlueprints is EqualUnmodifiableListView) return _roleBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roleBlueprints);
  }

  final List<LocationModel> _venueBlueprints;
  @override
  @JsonKey()
  List<LocationModel> get venueBlueprints {
    if (_venueBlueprints is EqualUnmodifiableListView) return _venueBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueBlueprints);
  }

  final List<TicketModel> _ticketBlueprints;
  @override
  @JsonKey()
  List<TicketModel> get ticketBlueprints {
    if (_ticketBlueprints is EqualUnmodifiableListView)
      return _ticketBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ticketBlueprints);
  }

  final List<CustomFieldDefinitionModel> _customFieldBlueprints;
  @override
  @JsonKey()
  List<CustomFieldDefinitionModel> get customFieldBlueprints {
    if (_customFieldBlueprints is EqualUnmodifiableListView)
      return _customFieldBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFieldBlueprints);
  }

  final List<AnnouncementModel> _announcementBlueprints;
  @override
  @JsonKey()
  List<AnnouncementModel> get announcementBlueprints {
    if (_announcementBlueprints is EqualUnmodifiableListView)
      return _announcementBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_announcementBlueprints);
  }

  final List<BudgetItemModel> _budgetBlueprints;
  @override
  @JsonKey()
  List<BudgetItemModel> get budgetBlueprints {
    if (_budgetBlueprints is EqualUnmodifiableListView)
      return _budgetBlueprints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgetBlueprints);
  }

  final List<TemplateModule> _enabledModules;
  @override
  @JsonKey()
  List<TemplateModule> get enabledModules {
    if (_enabledModules is EqualUnmodifiableListView) return _enabledModules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_enabledModules);
  }

  @override
  @JsonKey()
  final int usageCount;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final int version;
  @override
  final String? templateCode;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TemplateModel(id: $id, title: $title, description: $description, category: $category, contributionType: $contributionType, createdBy: $createdBy, tags: $tags, config: $config, taskBlueprints: $taskBlueprints, timelineBlueprints: $timelineBlueprints, vendorBlueprints: $vendorBlueprints, inventoryBlueprints: $inventoryBlueprints, roleBlueprints: $roleBlueprints, venueBlueprints: $venueBlueprints, ticketBlueprints: $ticketBlueprints, customFieldBlueprints: $customFieldBlueprints, announcementBlueprints: $announcementBlueprints, budgetBlueprints: $budgetBlueprints, enabledModules: $enabledModules, usageCount: $usageCount, rating: $rating, isPublic: $isPublic, version: $version, templateCode: $templateCode, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.contributionType, contributionType) ||
                other.contributionType == contributionType) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            const DeepCollectionEquality().equals(
              other._taskBlueprints,
              _taskBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._timelineBlueprints,
              _timelineBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._vendorBlueprints,
              _vendorBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._inventoryBlueprints,
              _inventoryBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._roleBlueprints,
              _roleBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._venueBlueprints,
              _venueBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._ticketBlueprints,
              _ticketBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._customFieldBlueprints,
              _customFieldBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._announcementBlueprints,
              _announcementBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._budgetBlueprints,
              _budgetBlueprints,
            ) &&
            const DeepCollectionEquality().equals(
              other._enabledModules,
              _enabledModules,
            ) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.templateCode, templateCode) ||
                other.templateCode == templateCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    category,
    contributionType,
    createdBy,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_config),
    const DeepCollectionEquality().hash(_taskBlueprints),
    const DeepCollectionEquality().hash(_timelineBlueprints),
    const DeepCollectionEquality().hash(_vendorBlueprints),
    const DeepCollectionEquality().hash(_inventoryBlueprints),
    const DeepCollectionEquality().hash(_roleBlueprints),
    const DeepCollectionEquality().hash(_venueBlueprints),
    const DeepCollectionEquality().hash(_ticketBlueprints),
    const DeepCollectionEquality().hash(_customFieldBlueprints),
    const DeepCollectionEquality().hash(_announcementBlueprints),
    const DeepCollectionEquality().hash(_budgetBlueprints),
    const DeepCollectionEquality().hash(_enabledModules),
    usageCount,
    rating,
    isPublic,
    version,
    templateCode,
    createdAt,
  ]);

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateModelImplCopyWith<_$TemplateModelImpl> get copyWith =>
      __$$TemplateModelImplCopyWithImpl<_$TemplateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateModelImplToJson(this);
  }
}

abstract class _TemplateModel implements TemplateModel {
  const factory _TemplateModel({
    required final String id,
    required final String title,
    required final String description,
    required final EventCategory category,
    required final ContributionType contributionType,
    required final String createdBy,
    final List<String> tags,
    final Map<String, dynamic>? config,
    final List<TaskModel> taskBlueprints,
    final List<TimelineItemModel> timelineBlueprints,
    final List<VendorModel> vendorBlueprints,
    final List<InventoryItemModel> inventoryBlueprints,
    final List<RoleDefinitionModel> roleBlueprints,
    final List<LocationModel> venueBlueprints,
    final List<TicketModel> ticketBlueprints,
    final List<CustomFieldDefinitionModel> customFieldBlueprints,
    final List<AnnouncementModel> announcementBlueprints,
    final List<BudgetItemModel> budgetBlueprints,
    final List<TemplateModule> enabledModules,
    final int usageCount,
    final double rating,
    final bool isPublic,
    final int version,
    final String? templateCode,
    final DateTime? createdAt,
  }) = _$TemplateModelImpl;

  factory _TemplateModel.fromJson(Map<String, dynamic> json) =
      _$TemplateModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  EventCategory get category;
  @override
  ContributionType get contributionType;
  @override
  String get createdBy;
  @override
  List<String> get tags;
  @override
  Map<String, dynamic>? get config; // Holds contribution, guest, and expense configs as needed
  @override
  List<TaskModel> get taskBlueprints;
  @override
  List<TimelineItemModel> get timelineBlueprints;
  @override
  List<VendorModel> get vendorBlueprints;
  @override
  List<InventoryItemModel> get inventoryBlueprints;
  @override
  List<RoleDefinitionModel> get roleBlueprints;
  @override
  List<LocationModel> get venueBlueprints;
  @override
  List<TicketModel> get ticketBlueprints;
  @override
  List<CustomFieldDefinitionModel> get customFieldBlueprints;
  @override
  List<AnnouncementModel> get announcementBlueprints;
  @override
  List<BudgetItemModel> get budgetBlueprints;
  @override
  List<TemplateModule> get enabledModules;
  @override
  int get usageCount;
  @override
  double get rating;
  @override
  bool get isPublic;
  @override
  int get version;
  @override
  String? get templateCode;
  @override
  DateTime? get createdAt;

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateModelImplCopyWith<_$TemplateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
