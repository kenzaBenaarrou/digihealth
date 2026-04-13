// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isDashboardLoadingHash() =>
    r'c5c3fcabe26d41075d71f960a5a5f57271fd1743';

/// Provider to check if dashboard is currently loading
/// Useful for showing loading indicators in the UI
///
/// Copied from [isDashboardLoading].
@ProviderFor(isDashboardLoading)
final isDashboardLoadingProvider = AutoDisposeProvider<bool>.internal(
  isDashboardLoading,
  name: r'isDashboardLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isDashboardLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDashboardLoadingRef = AutoDisposeProviderRef<bool>;
String _$dashboardErrorHash() => r'19aba80b947f3bc994410ebf24d863549e572293';

/// Provider to get dashboard error message if any
/// Returns null if no error
///
/// Copied from [dashboardError].
@ProviderFor(dashboardError)
final dashboardErrorProvider = AutoDisposeProvider<String?>.internal(
  dashboardError,
  name: r'dashboardErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardErrorRef = AutoDisposeProviderRef<String?>;
String _$dashboardDataHash() => r'1437b32d65cab3bacd1c300c58bb6c9b98e0e28e';

/// Provider to get dashboard data if available
/// Returns null if not loaded or error occurred
///
/// Copied from [dashboardData].
@ProviderFor(dashboardData)
final dashboardDataProvider = AutoDisposeProvider<DashboardResponse?>.internal(
  dashboardData,
  name: r'dashboardDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardDataRef = AutoDisposeProviderRef<DashboardResponse?>;
String _$dashboardHash() => r'a0e1d1a2b70a922c6eeca34909ef7200c3a26aa1';

/// Dashboard provider using modern Riverpod annotation style
/// Manages dashboard data fetching and state
///
/// Copied from [Dashboard].
@ProviderFor(Dashboard)
final dashboardProvider =
    AutoDisposeNotifierProvider<Dashboard, DashboardState>.internal(
  Dashboard.new,
  name: r'dashboardProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dashboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Dashboard = AutoDisposeNotifier<DashboardState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
