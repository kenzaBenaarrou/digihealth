// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$programsHash() => r'b8f4a16d923fab53d48a4e378c19c4055bc198e5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Programs extends BuildlessAutoDisposeNotifier<ProgramsState> {
  late final String? category;
  late final String? status;
  late final String? region;
  late final String? province;
  late final String? ummc;

  ProgramsState build({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
  });
}

/// Provider for programs with category and status filters
///
/// Copied from [Programs].
@ProviderFor(Programs)
const programsProvider = ProgramsFamily();

/// Provider for programs with category and status filters
///
/// Copied from [Programs].
class ProgramsFamily extends Family<ProgramsState> {
  /// Provider for programs with category and status filters
  ///
  /// Copied from [Programs].
  const ProgramsFamily();

  /// Provider for programs with category and status filters
  ///
  /// Copied from [Programs].
  ProgramsProvider call({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
  }) {
    return ProgramsProvider(
      category: category,
      status: status,
      region: region,
      province: province,
      ummc: ummc,
    );
  }

  @override
  ProgramsProvider getProviderOverride(
    covariant ProgramsProvider provider,
  ) {
    return call(
      category: provider.category,
      status: provider.status,
      region: provider.region,
      province: provider.province,
      ummc: provider.ummc,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'programsProvider';
}

/// Provider for programs with category and status filters
///
/// Copied from [Programs].
class ProgramsProvider
    extends AutoDisposeNotifierProviderImpl<Programs, ProgramsState> {
  /// Provider for programs with category and status filters
  ///
  /// Copied from [Programs].
  ProgramsProvider({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
  }) : this._internal(
          () => Programs()
            ..category = category
            ..status = status
            ..region = region
            ..province = province
            ..ummc = ummc,
          from: programsProvider,
          name: r'programsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$programsHash,
          dependencies: ProgramsFamily._dependencies,
          allTransitiveDependencies: ProgramsFamily._allTransitiveDependencies,
          category: category,
          status: status,
          region: region,
          province: province,
          ummc: ummc,
        );

  ProgramsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
    required this.status,
    required this.region,
    required this.province,
    required this.ummc,
  }) : super.internal();

  final String? category;
  final String? status;
  final String? region;
  final String? province;
  final String? ummc;

  @override
  ProgramsState runNotifierBuild(
    covariant Programs notifier,
  ) {
    return notifier.build(
      category: category,
      status: status,
      region: region,
      province: province,
      ummc: ummc,
    );
  }

  @override
  Override overrideWith(Programs Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProgramsProvider._internal(
        () => create()
          ..category = category
          ..status = status
          ..region = region
          ..province = province
          ..ummc = ummc,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
        status: status,
        region: region,
        province: province,
        ummc: ummc,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Programs, ProgramsState> createElement() {
    return _ProgramsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgramsProvider &&
        other.category == category &&
        other.status == status &&
        other.region == region &&
        other.province == province &&
        other.ummc == ummc;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);
    hash = _SystemHash.combine(hash, province.hashCode);
    hash = _SystemHash.combine(hash, ummc.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgramsRef on AutoDisposeNotifierProviderRef<ProgramsState> {
  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `region` of this provider.
  String? get region;

  /// The parameter `province` of this provider.
  String? get province;

  /// The parameter `ummc` of this provider.
  String? get ummc;
}

class _ProgramsProviderElement
    extends AutoDisposeNotifierProviderElement<Programs, ProgramsState>
    with ProgramsRef {
  _ProgramsProviderElement(super.provider);

  @override
  String? get category => (origin as ProgramsProvider).category;
  @override
  String? get status => (origin as ProgramsProvider).status;
  @override
  String? get region => (origin as ProgramsProvider).region;
  @override
  String? get province => (origin as ProgramsProvider).province;
  @override
  String? get ummc => (origin as ProgramsProvider).ummc;
}

String _$programDetailHash() => r'1797e8ac7ffdd14507839d8ef0d697429b6c8349';

abstract class _$ProgramDetail
    extends BuildlessAutoDisposeAsyncNotifier<ProgramModel> {
  late final String programId;

  FutureOr<ProgramModel> build(
    String programId,
  );
}

/// Provider for a single program detail
///
/// Copied from [ProgramDetail].
@ProviderFor(ProgramDetail)
const programDetailProvider = ProgramDetailFamily();

/// Provider for a single program detail
///
/// Copied from [ProgramDetail].
class ProgramDetailFamily extends Family<AsyncValue<ProgramModel>> {
  /// Provider for a single program detail
  ///
  /// Copied from [ProgramDetail].
  const ProgramDetailFamily();

  /// Provider for a single program detail
  ///
  /// Copied from [ProgramDetail].
  ProgramDetailProvider call(
    String programId,
  ) {
    return ProgramDetailProvider(
      programId,
    );
  }

  @override
  ProgramDetailProvider getProviderOverride(
    covariant ProgramDetailProvider provider,
  ) {
    return call(
      provider.programId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'programDetailProvider';
}

/// Provider for a single program detail
///
/// Copied from [ProgramDetail].
class ProgramDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ProgramDetail, ProgramModel> {
  /// Provider for a single program detail
  ///
  /// Copied from [ProgramDetail].
  ProgramDetailProvider(
    String programId,
  ) : this._internal(
          () => ProgramDetail()..programId = programId,
          from: programDetailProvider,
          name: r'programDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$programDetailHash,
          dependencies: ProgramDetailFamily._dependencies,
          allTransitiveDependencies:
              ProgramDetailFamily._allTransitiveDependencies,
          programId: programId,
        );

  ProgramDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programId,
  }) : super.internal();

  final String programId;

  @override
  FutureOr<ProgramModel> runNotifierBuild(
    covariant ProgramDetail notifier,
  ) {
    return notifier.build(
      programId,
    );
  }

  @override
  Override overrideWith(ProgramDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProgramDetailProvider._internal(
        () => create()..programId = programId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programId: programId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProgramDetail, ProgramModel>
      createElement() {
    return _ProgramDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgramDetailProvider && other.programId == programId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgramDetailRef on AutoDisposeAsyncNotifierProviderRef<ProgramModel> {
  /// The parameter `programId` of this provider.
  String get programId;
}

class _ProgramDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProgramDetail, ProgramModel>
    with ProgramDetailRef {
  _ProgramDetailProviderElement(super.provider);

  @override
  String get programId => (origin as ProgramDetailProvider).programId;
}

String _$consultationProgramsHash() =>
    r'08c7bcbbad5b80653a9c282cb9782078f8156cc8';

abstract class _$ConsultationPrograms
    extends BuildlessAutoDisposeNotifier<ProgramsState> {
  late final String? status;

  ProgramsState build({
    String? status,
  });
}

/// Convenience providers for specific program categories
///
/// Copied from [ConsultationPrograms].
@ProviderFor(ConsultationPrograms)
const consultationProgramsProvider = ConsultationProgramsFamily();

/// Convenience providers for specific program categories
///
/// Copied from [ConsultationPrograms].
class ConsultationProgramsFamily extends Family<ProgramsState> {
  /// Convenience providers for specific program categories
  ///
  /// Copied from [ConsultationPrograms].
  const ConsultationProgramsFamily();

  /// Convenience providers for specific program categories
  ///
  /// Copied from [ConsultationPrograms].
  ConsultationProgramsProvider call({
    String? status,
  }) {
    return ConsultationProgramsProvider(
      status: status,
    );
  }

  @override
  ConsultationProgramsProvider getProviderOverride(
    covariant ConsultationProgramsProvider provider,
  ) {
    return call(
      status: provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'consultationProgramsProvider';
}

/// Convenience providers for specific program categories
///
/// Copied from [ConsultationPrograms].
class ConsultationProgramsProvider extends AutoDisposeNotifierProviderImpl<
    ConsultationPrograms, ProgramsState> {
  /// Convenience providers for specific program categories
  ///
  /// Copied from [ConsultationPrograms].
  ConsultationProgramsProvider({
    String? status,
  }) : this._internal(
          () => ConsultationPrograms()..status = status,
          from: consultationProgramsProvider,
          name: r'consultationProgramsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$consultationProgramsHash,
          dependencies: ConsultationProgramsFamily._dependencies,
          allTransitiveDependencies:
              ConsultationProgramsFamily._allTransitiveDependencies,
          status: status,
        );

  ConsultationProgramsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  ProgramsState runNotifierBuild(
    covariant ConsultationPrograms notifier,
  ) {
    return notifier.build(
      status: status,
    );
  }

  @override
  Override overrideWith(ConsultationPrograms Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConsultationProgramsProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ConsultationPrograms, ProgramsState>
      createElement() {
    return _ConsultationProgramsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsultationProgramsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConsultationProgramsRef on AutoDisposeNotifierProviderRef<ProgramsState> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _ConsultationProgramsProviderElement
    extends AutoDisposeNotifierProviderElement<ConsultationPrograms,
        ProgramsState> with ConsultationProgramsRef {
  _ConsultationProgramsProviderElement(super.provider);

  @override
  String? get status => (origin as ConsultationProgramsProvider).status;
}

String _$teleexpertiseProgramsHash() =>
    r'7dedab22a73177db095aea550957eb20a43ca435';

abstract class _$TeleexpertisePrograms
    extends BuildlessAutoDisposeNotifier<ProgramsState> {
  late final String? status;

  ProgramsState build({
    String? status,
  });
}

/// See also [TeleexpertisePrograms].
@ProviderFor(TeleexpertisePrograms)
const teleexpertiseProgramsProvider = TeleexpertiseProgramsFamily();

/// See also [TeleexpertisePrograms].
class TeleexpertiseProgramsFamily extends Family<ProgramsState> {
  /// See also [TeleexpertisePrograms].
  const TeleexpertiseProgramsFamily();

  /// See also [TeleexpertisePrograms].
  TeleexpertiseProgramsProvider call({
    String? status,
  }) {
    return TeleexpertiseProgramsProvider(
      status: status,
    );
  }

  @override
  TeleexpertiseProgramsProvider getProviderOverride(
    covariant TeleexpertiseProgramsProvider provider,
  ) {
    return call(
      status: provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'teleexpertiseProgramsProvider';
}

/// See also [TeleexpertisePrograms].
class TeleexpertiseProgramsProvider extends AutoDisposeNotifierProviderImpl<
    TeleexpertisePrograms, ProgramsState> {
  /// See also [TeleexpertisePrograms].
  TeleexpertiseProgramsProvider({
    String? status,
  }) : this._internal(
          () => TeleexpertisePrograms()..status = status,
          from: teleexpertiseProgramsProvider,
          name: r'teleexpertiseProgramsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teleexpertiseProgramsHash,
          dependencies: TeleexpertiseProgramsFamily._dependencies,
          allTransitiveDependencies:
              TeleexpertiseProgramsFamily._allTransitiveDependencies,
          status: status,
        );

  TeleexpertiseProgramsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  ProgramsState runNotifierBuild(
    covariant TeleexpertisePrograms notifier,
  ) {
    return notifier.build(
      status: status,
    );
  }

  @override
  Override overrideWith(TeleexpertisePrograms Function() create) {
    return ProviderOverride(
      origin: this,
      override: TeleexpertiseProgramsProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TeleexpertisePrograms, ProgramsState>
      createElement() {
    return _TeleexpertiseProgramsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeleexpertiseProgramsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeleexpertiseProgramsRef
    on AutoDisposeNotifierProviderRef<ProgramsState> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _TeleexpertiseProgramsProviderElement
    extends AutoDisposeNotifierProviderElement<TeleexpertisePrograms,
        ProgramsState> with TeleexpertiseProgramsRef {
  _TeleexpertiseProgramsProviderElement(super.provider);

  @override
  String? get status => (origin as TeleexpertiseProgramsProvider).status;
}

String _$depistageProgramsHash() => r'4e83ddee468d199ca0c595adc08d3831759d8d64';

abstract class _$DepistagePrograms
    extends BuildlessAutoDisposeNotifier<ProgramsState> {
  late final String? status;

  ProgramsState build({
    String? status,
  });
}

/// See also [DepistagePrograms].
@ProviderFor(DepistagePrograms)
const depistageProgramsProvider = DepistageProgramsFamily();

/// See also [DepistagePrograms].
class DepistageProgramsFamily extends Family<ProgramsState> {
  /// See also [DepistagePrograms].
  const DepistageProgramsFamily();

  /// See also [DepistagePrograms].
  DepistageProgramsProvider call({
    String? status,
  }) {
    return DepistageProgramsProvider(
      status: status,
    );
  }

  @override
  DepistageProgramsProvider getProviderOverride(
    covariant DepistageProgramsProvider provider,
  ) {
    return call(
      status: provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'depistageProgramsProvider';
}

/// See also [DepistagePrograms].
class DepistageProgramsProvider
    extends AutoDisposeNotifierProviderImpl<DepistagePrograms, ProgramsState> {
  /// See also [DepistagePrograms].
  DepistageProgramsProvider({
    String? status,
  }) : this._internal(
          () => DepistagePrograms()..status = status,
          from: depistageProgramsProvider,
          name: r'depistageProgramsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$depistageProgramsHash,
          dependencies: DepistageProgramsFamily._dependencies,
          allTransitiveDependencies:
              DepistageProgramsFamily._allTransitiveDependencies,
          status: status,
        );

  DepistageProgramsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  ProgramsState runNotifierBuild(
    covariant DepistagePrograms notifier,
  ) {
    return notifier.build(
      status: status,
    );
  }

  @override
  Override overrideWith(DepistagePrograms Function() create) {
    return ProviderOverride(
      origin: this,
      override: DepistageProgramsProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DepistagePrograms, ProgramsState>
      createElement() {
    return _DepistageProgramsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DepistageProgramsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DepistageProgramsRef on AutoDisposeNotifierProviderRef<ProgramsState> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _DepistageProgramsProviderElement
    extends AutoDisposeNotifierProviderElement<DepistagePrograms, ProgramsState>
    with DepistageProgramsRef {
  _DepistageProgramsProviderElement(super.provider);

  @override
  String? get status => (origin as DepistageProgramsProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
