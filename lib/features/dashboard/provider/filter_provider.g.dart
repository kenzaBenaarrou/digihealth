// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filterHash() => r'c52b63046ee234ec1819c0da2d868800d572e977';

/// Filter provider to manage filter data and selection
/// keepAlive is set to true to persist filter data across the app lifecycle
///
/// Copied from [Filter].
@ProviderFor(Filter)
final filterProvider = NotifierProvider<Filter, FilterState>.internal(
  Filter.new,
  name: r'filterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Filter = Notifier<FilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
