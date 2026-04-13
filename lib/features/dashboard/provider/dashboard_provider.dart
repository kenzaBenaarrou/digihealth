import 'package:digihealth/core/error/failure.dart';
import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';
import 'package:digihealth/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

/// Dashboard state representing different loading states
class DashboardState {
  final DashboardResponse? data;
  final String? errorMessage;
  final DashboardStatus status;

  DashboardState({
    this.data,
    this.errorMessage,
    this.status = DashboardStatus.initial,
  });

  /// Creates a copy of this state with updated fields
  DashboardState copyWith({
    DashboardResponse? data,
    String? errorMessage,
    DashboardStatus? status,
  }) {
    return DashboardState(
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}

/// Enum representing the various states of dashboard data loading
enum DashboardStatus {
  initial,
  loading,
  success,
  error,
}

/// Dashboard provider using modern Riverpod annotation style
/// Manages dashboard data fetching and state
@riverpod
class Dashboard extends _$Dashboard {
  @override
  DashboardState build() {
    // Initialize with default state
    return DashboardState();
  }

  /// Fetches dashboard data from the repository
  /// Updates state based on success or failure
  Future<void> fetchDashboardData() async {
    try {
      // Set loading state
      state = state.copyWith(status: DashboardStatus.loading);

      // Fetch data from repository using ref.read
      final response =
          await ref.read(dashboardRepositoryProvider).getDashboardData();

      // Update state with successful data
      state = state.copyWith(
        status: DashboardStatus.success,
        data: response,
        errorMessage: null,
      );
    } on Failure catch (failure) {
      // Handle domain-specific failures with proper error messages
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: failure.message,
      );
    } catch (e) {
      // Handle any unexpected errors
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage:
            'An unexpected error occurred while loading dashboard data',
      );
    }
  }

  /// Refreshes dashboard data
  /// Can be used for pull-to-refresh functionality
  Future<void> refresh() async {
    await fetchDashboardData();
  }

  /// Clears any error state
  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: DashboardStatus.initial,
    );
  }
}

/// Provider to check if dashboard is currently loading
/// Useful for showing loading indicators in the UI
@riverpod
bool isDashboardLoading(IsDashboardLoadingRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.status == DashboardStatus.loading;
}

/// Provider to get dashboard error message if any
/// Returns null if no error
@riverpod
String? dashboardError(DashboardErrorRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.status == DashboardStatus.error
      ? dashboardState.errorMessage
      : null;
}

/// Provider to get dashboard data if available
/// Returns null if not loaded or error occurred
@riverpod
DashboardResponse? dashboardData(DashboardDataRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.status == DashboardStatus.success
      ? dashboardState.data
      : null;
}
