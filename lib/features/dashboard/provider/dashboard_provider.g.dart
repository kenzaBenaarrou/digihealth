// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isDashboardLoadingHash() =>
    r'c5c3fcabe26d41075d71f960a5a5f57271fd1743';

/// See also [isDashboardLoading].
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

/// See also [dashboardError].
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

/// See also [dashboardData].
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
String _$dashboardHash() => r'bf6af1142e198064515c7ff59989928802bff129';

/// See also [Dashboard].
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
