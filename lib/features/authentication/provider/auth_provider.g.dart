// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'd3e4d138bc46ec74b4bf0593f54238a6450ff5f0';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
String _$keepSessionActiveHash() => r'ba0ab478242be66c6b55790e48ed6c8b49eb45d8';

/// See also [KeepSessionActive].
@ProviderFor(KeepSessionActive)
final keepSessionActiveProvider =
    AutoDisposeNotifierProvider<KeepSessionActive, bool>.internal(
  KeepSessionActive.new,
  name: r'keepSessionActiveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keepSessionActiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeepSessionActive = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
