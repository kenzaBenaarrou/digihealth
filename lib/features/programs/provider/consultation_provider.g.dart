// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isConsultationLoadingHash() =>
    r'c5370a29fe0d55419c34640bfbac47f436239a47';

/// Convenience providers for accessing specific parts of consultation data
///
/// Copied from [isConsultationLoading].
@ProviderFor(isConsultationLoading)
final isConsultationLoadingProvider = AutoDisposeProvider<bool>.internal(
  isConsultationLoading,
  name: r'isConsultationLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isConsultationLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsConsultationLoadingRef = AutoDisposeProviderRef<bool>;
String _$consultationErrorHash() => r'da6ea349ea5e0bc5db16f54f22dcaa43ebf4ad71';

/// See also [consultationError].
@ProviderFor(consultationError)
final consultationErrorProvider = AutoDisposeProvider<String?>.internal(
  consultationError,
  name: r'consultationErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consultationErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsultationErrorRef = AutoDisposeProviderRef<String?>;
String _$consultationDataHash() => r'5ebc007afd788cf5f9535d1078e7cd890a81f16c';

/// See also [consultationData].
@ProviderFor(consultationData)
final consultationDataProvider =
    AutoDisposeProvider<ConsultationResponse?>.internal(
  consultationData,
  name: r'consultationDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consultationDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsultationDataRef = AutoDisposeProviderRef<ConsultationResponse?>;
String _$consultationHash() => r'e2a47da6c08a4d1657868f1de5b90c1f7dc1ac89';

/// Provider for consultation statistics
///
/// Copied from [Consultation].
@ProviderFor(Consultation)
final consultationProvider =
    AutoDisposeNotifierProvider<Consultation, ConsultationState>.internal(
  Consultation.new,
  name: r'consultationProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$consultationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Consultation = AutoDisposeNotifier<ConsultationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
