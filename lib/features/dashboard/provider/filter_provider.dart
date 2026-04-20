import 'package:digihealth/features/dashboard/data/datasource/filter_remote_datasource.dart';
import 'package:digihealth/models/filter_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

/// State for filter data and selection
class FilterState {
  final FilterDataModel? availableFilters;
  final FilterSelection currentSelection;
  final bool isLoading;
  final bool isLoadingProvinces;
  final bool isLoadingUmmcs;
  final String? errorMessage;
  final List<String> availableProvinces;
  final List<String> availableUmmcs;

  FilterState({
    this.availableFilters,
    FilterSelection? currentSelection,
    this.isLoading = false,
    this.isLoadingProvinces = false,
    this.isLoadingUmmcs = false,
    this.errorMessage,
    this.availableProvinces = const [],
    this.availableUmmcs = const [],
  }) : currentSelection = currentSelection ?? FilterSelection.empty();

  FilterState copyWith({
    FilterDataModel? availableFilters,
    FilterSelection? currentSelection,
    bool? isLoading,
    bool? isLoadingProvinces,
    bool? isLoadingUmmcs,
    String? errorMessage,
    List<String>? availableProvinces,
    List<String>? availableUmmcs,
  }) {
    return FilterState(
      availableFilters: availableFilters ?? this.availableFilters,
      currentSelection: currentSelection ?? this.currentSelection,
      isLoading: isLoading ?? this.isLoading,
      isLoadingProvinces: isLoadingProvinces ?? this.isLoadingProvinces,
      isLoadingUmmcs: isLoadingUmmcs ?? this.isLoadingUmmcs,
      errorMessage: errorMessage ?? this.errorMessage,
      availableProvinces: availableProvinces ?? this.availableProvinces,
      availableUmmcs: availableUmmcs ?? this.availableUmmcs,
    );
  }
}

/// Filter provider to manage filter data and selection
/// keepAlive is set to true to persist filter data across the app lifecycle
@Riverpod(keepAlive: true)
class Filter extends _$Filter {
  @override
  FilterState build() {
    return FilterState();
  }

  /// Fetch available filters from API
  /// Called automatically after login
  Future<void> fetchFilterData() async {
    try {
      print('🔄 Starting filter data fetch...');
      state = state.copyWith(isLoading: true);

      final filterData =
          await ref.read(filterRemoteDataSourceProvider).getFilterData();

      print('✅ Filter data received:');
      print('   - Regions: ${filterData.regions.length}');
      print('   - Provinces: ${filterData.provinces.length}');
      print('   - UMMCs: ${filterData.ummcs.length}');

      state = state.copyWith(
        availableFilters: filterData,
        isLoading: false,
        errorMessage: null,
      );

      print('✅ Filter data stored in state successfully');
    } catch (e) {
      print('❌ Error fetching filter data: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow; // Re-throw to let the caller know the fetch failed
    }
  }

  /// Set available filters (alternative method if data comes from elsewhere)
  void setAvailableFilters(FilterDataModel filters) {
    state = state.copyWith(availableFilters: filters);
  }

  /// Fetch provinces for selected region (cascading)
  Future<void> fetchProvincesForRegion(String region) async {
    try {
      print('🔄 Fetching provinces for region: $region');
      state = state.copyWith(
        isLoadingProvinces: true,
        availableProvinces: [], // Clear previous provinces
        availableUmmcs: [], // Clear UMMCs too
      );

      final provinces = await ref
          .read(filterRemoteDataSourceProvider)
          .getProvincesForRegion(region);

      print('✅ Provinces received: ${provinces.length}');

      state = state.copyWith(
        isLoadingProvinces: false,
        availableProvinces: provinces,
        currentSelection: state.currentSelection.copyWith(
          region: region,
          clearProvince: true,
          clearUmmc: true,
        ),
      );
    } catch (e) {
      print('❌ Error fetching provinces: $e');
      state = state.copyWith(
        isLoadingProvinces: false,
        availableProvinces: [],
      );
    }
  }

  /// Fetch UMMCs for selected region and province (cascading)
  Future<void> fetchUmmcsForProvince(String region, String province) async {
    try {
      print('🔄 Fetching UMMCs for region: $region, province: $province');
      state = state.copyWith(
        isLoadingUmmcs: true,
        availableUmmcs: [], // Clear previous UMMCs
      );

      final ummcs = await ref
          .read(filterRemoteDataSourceProvider)
          .getUmmcsForProvince(region, province);

      print('✅ UMMCs received: ${ummcs.length}');

      state = state.copyWith(
        isLoadingUmmcs: false,
        availableUmmcs: ummcs,
        currentSelection: state.currentSelection.copyWith(
          province: province,
          clearUmmc: true,
        ),
      );
    } catch (e) {
      print('❌ Error fetching UMMCs: $e');
      state = state.copyWith(
        isLoadingUmmcs: false,
        availableUmmcs: [],
      );
    }
  }

  /// Update region selection (no longer auto-clears, but triggers province fetch)
  void selectRegion(String? region) {
    if (region == null) {
      // Clear all when region is cleared
      state = state.copyWith(
        currentSelection: FilterSelection.empty(),
        availableProvinces: [],
        availableUmmcs: [],
      );
    }
    // Don't update selection here - it's updated in fetchProvincesForRegion
  }

  /// Update province selection (triggers UMMC fetch)
  void selectProvince(String? province) {
    if (province == null) {
      // Clear province and UMMCs
      state = state.copyWith(
        currentSelection: state.currentSelection.copyWith(
          clearProvince: true,
          clearUmmc: true,
        ),
        availableUmmcs: [],
      );
    }
    // Don't update selection here - it's updated in fetchUmmcsForProvince
  }

  /// Update UMMC selection
  void selectUmmc(String? ummc) {
    state = state.copyWith(
      currentSelection: state.currentSelection.copyWith(
        ummc: ummc,
        clearUmmc: ummc == null,
      ),
    );
  }

  /// Update date range selection
  void selectDateRange(DateTime? fromDate, DateTime? toDate) {
    state = state.copyWith(
      currentSelection: state.currentSelection.copyWith(
        fromDate: fromDate,
        toDate: toDate,
        clearFromDate: fromDate == null,
        clearToDate: toDate == null,
      ),
    );
  }

  /// Update tranche selection
  void selectTranche(int? tranche) {
    state = state.copyWith(
      currentSelection: state.currentSelection.copyWith(
        tranche: tranche,
        clearTranche: tranche == null,
      ),
    );
  }

  /// Update itinerance selection
  void selectItinerance(bool isItinerance) {
    state = state.copyWith(
      currentSelection: state.currentSelection.copyWith(
        isItinerance: isItinerance,
      ),
    );
  }

  /// Clear all filter selections and cascaded data
  void clearFilters() {
    state = state.copyWith(
      currentSelection: FilterSelection.empty(),
      availableProvinces: [],
      availableUmmcs: [],
    );
  }

  /// Apply filters (returns the selected filter value)
  String? applyFilters() {
    return state.currentSelection.activeFilter;
  }
}
