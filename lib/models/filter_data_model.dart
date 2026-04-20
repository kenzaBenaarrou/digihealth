import 'package:json_annotation/json_annotation.dart';

part 'filter_data_model.g.dart';

/// Model for filter data containing regions, provinces, and UMMCs
/// This data is fetched after login and used for cascading filters
@JsonSerializable()
class FilterDataModel {
  final List<String> regions;
  final List<String> provinces;
  final List<String> ummcs;

  FilterDataModel({
    required this.regions,
    required this.provinces,
    required this.ummcs,
  });

  factory FilterDataModel.fromJson(Map<String, dynamic> json) =>
      _$FilterDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterDataModelToJson(this);

  /// Creates an empty filter data model
  factory FilterDataModel.empty() {
    return FilterDataModel(
      regions: [],
      provinces: [],
      ummcs: [],
    );
  }

  /// Check if the model has any data
  bool get isEmpty => regions.isEmpty && provinces.isEmpty && ummcs.isEmpty;

  /// Check if the model has data
  bool get isNotEmpty => !isEmpty;
}

/// Model for the current filter selection
class FilterSelection {
  final String? region;
  final String? province;
  final String? ummc;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? tranche;
  final bool isItinerance;

  FilterSelection({
    this.region,
    this.province,
    this.ummc,
    this.fromDate,
    this.toDate,
    this.tranche,
    this.isItinerance = false,
  });

  /// Creates an empty selection
  factory FilterSelection.empty() {
    return FilterSelection(
      region: null,
      province: null,
      ummc: null,
      fromDate: null,
      toDate: null,
      tranche: null,
      isItinerance: false,
    );
  }

  /// Copy with method to update individual fields
  FilterSelection copyWith({
    String? region,
    String? province,
    String? ummc,
    DateTime? fromDate,
    DateTime? toDate,
    int? tranche,
    bool? isItinerance,
    bool clearRegion = false,
    bool clearProvince = false,
    bool clearUmmc = false,
    bool clearFromDate = false,
    bool clearToDate = false,
    bool clearTranche = false,
  }) {
    return FilterSelection(
      region: clearRegion ? null : (region ?? this.region),
      province: clearProvince ? null : (province ?? this.province),
      ummc: clearUmmc ? null : (ummc ?? this.ummc),
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
      tranche: clearTranche ? null : (tranche ?? this.tranche),
      isItinerance: isItinerance ?? this.isItinerance,
    );
  }

  /// Check if any filter is selected
  bool get hasSelection =>
      region != null ||
      province != null ||
      ummc != null ||
      fromDate != null ||
      toDate != null ||
      tranche != null ||
      isItinerance;

  /// Get the active filter value (region > province > ummc priority)
  String? get activeFilter => region ?? province ?? ummc;

  /// Get the filter type
  String? get filterType {
    if (region != null) return 'region';
    if (province != null) return 'province';
    if (ummc != null) return 'ummc';
    return null;
  }

  @override
  String toString() {
    return 'FilterSelection(region: $region, province: $province, ummc: $ummc, fromDate: $fromDate, toDate: $toDate)';
  }
}
