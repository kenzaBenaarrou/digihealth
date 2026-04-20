import 'package:digihealth/core/error/failure.dart';
import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';
import 'package:digihealth/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

class DashboardState {
  final DashboardResponse? data;
  final String? errorMessage;
  final DashboardStatus status;

  DashboardState({
    this.data,
    this.errorMessage,
    this.status = DashboardStatus.initial,
  });

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

enum DashboardStatus {
  initial,
  loading,
  success,
  error,
}

@riverpod
class Dashboard extends _$Dashboard {
  @override
  DashboardState build() {
    return DashboardState();
  }

  Future<void> fetchDashboardData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItenerance,
  }) async {
    try {
      state = state.copyWith(status: DashboardStatus.loading);

      final response =
          await ref.read(dashboardRepositoryProvider).getDashboardData(
                region: region,
                province: province,
                ummc: ummc,
                from: from,
                to: to,
                tranche: tranche,
                isItenerance: isItenerance,
              );

      state = state.copyWith(
        status: DashboardStatus.success,
        data: response,
        errorMessage: null,
      );
    } on Failure catch (failure) {
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: failure.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage:
            'An unexpected error occurred while loading dashboard data',
      );
    }
  }

  Future<void> refresh({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItenerance,
  }) async {
    await fetchDashboardData(
      region: region,
      province: province,
      ummc: ummc,
      from: from,
      to: to,
      tranche: tranche,
      isItenerance: isItenerance,
    );
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: DashboardStatus.initial,
    );
  }
}

@riverpod
bool isDashboardLoading(IsDashboardLoadingRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.status == DashboardStatus.loading;
}

@riverpod
String? dashboardError(DashboardErrorRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.status == DashboardStatus.error
      ? dashboardState.errorMessage
      : null;
}

@riverpod
DashboardResponse? dashboardData(DashboardDataRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.status == DashboardStatus.success
      ? dashboardState.data
      : null;
}
