import 'package:digihealth/core/error/failure.dart';
import 'package:digihealth/features/programs/data/models/program_model.dart';
import 'package:digihealth/features/programs/data/repository/program_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'program_provider.g.dart';

/// State for programs with pagination support
class ProgramsState {
  final List<ProgramModel> programs;
  final String? errorMessage;
  final ProgramsStatus status;
  final int currentPage;
  final bool hasMore;
  final int total;

  ProgramsState({
    this.programs = const [],
    this.errorMessage,
    this.status = ProgramsStatus.initial,
    this.currentPage = 1,
    this.hasMore = true,
    this.total = 0,
  });

  ProgramsState copyWith({
    List<ProgramModel>? programs,
    String? errorMessage,
    ProgramsStatus? status,
    int? currentPage,
    bool? hasMore,
    int? total,
  }) {
    return ProgramsState(
      programs: programs ?? this.programs,
      errorMessage: errorMessage,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
    );
  }
}

enum ProgramsStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
}

/// Provider for programs with category and status filters
@riverpod
class Programs extends _$Programs {
  String? _category;
  String? _status;
  String? _region;
  String? _province;
  String? _ummc;

  @override
  ProgramsState build({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
  }) {
    _category = category;
    _status = status;
    _region = region;
    _province = province;
    _ummc = ummc;
    return ProgramsState();
  }

  /// Fetch initial programs (first page)
  Future<void> fetchPrograms({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
  }) async {
    try {
      // Update filters if provided
      _category = category ?? _category;
      _status = status ?? _status;
      _region = region ?? _region;
      _province = province ?? _province;
      _ummc = ummc ?? _ummc;

      state = state.copyWith(
        status: ProgramsStatus.loading,
        currentPage: 1,
      );

      final response = await ref.read(programRepositoryProvider).getPrograms(
            category: _category,
            status: _status,
            region: _region,
            province: _province,
            ummc: _ummc,
            page: 1,
            pageSize: 20,
          );

      state = state.copyWith(
        status: ProgramsStatus.success,
        programs: response.programs,
        currentPage: 1,
        hasMore: response.hasMore,
        total: response.total,
        errorMessage: null,
      );
    } on Failure catch (failure) {
      state = state.copyWith(
        status: ProgramsStatus.error,
        errorMessage: failure.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProgramsStatus.error,
        errorMessage: 'An unexpected error occurred while loading programs',
      );
    }
  }

  /// Load more programs (pagination)
  Future<void> loadMore() async {
    // Don't load if already loading or no more data
    if (state.status == ProgramsStatus.loadingMore ||
        !state.hasMore ||
        state.status == ProgramsStatus.loading) {
      return;
    }

    try {
      final nextPage = state.currentPage + 1;

      state = state.copyWith(status: ProgramsStatus.loadingMore);

      final response = await ref.read(programRepositoryProvider).getPrograms(
            category: _category,
            status: _status,
            region: _region,
            province: _province,
            ummc: _ummc,
            page: nextPage,
            pageSize: 20,
          );

      state = state.copyWith(
        status: ProgramsStatus.success,
        programs: [...state.programs, ...response.programs],
        currentPage: nextPage,
        hasMore: response.hasMore,
        total: response.total,
        errorMessage: null,
      );
    } on Failure catch (failure) {
      state = state.copyWith(
        status: ProgramsStatus.error,
        errorMessage: failure.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProgramsStatus.error,
        errorMessage:
            'An unexpected error occurred while loading more programs',
      );
    }
  }

  /// Refresh programs (pull to refresh)
  Future<void> refresh() async {
    await fetchPrograms(
      category: _category,
      status: _status,
      region: _region,
      province: _province,
      ummc: _ummc,
    );
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: ProgramsStatus.initial,
    );
  }
}

/// Provider for a single program detail
@riverpod
class ProgramDetail extends _$ProgramDetail {
  @override
  Future<ProgramModel> build(String programId) async {
    return await ref.read(programRepositoryProvider).getProgramById(programId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(programRepositoryProvider)
          .getProgramById(programId);
    });
  }
}

/// Convenience providers for specific program categories
@riverpod
class ConsultationPrograms extends _$ConsultationPrograms {
  @override
  ProgramsState build({String? status}) {
    return ProgramsState();
  }

  Future<void> fetch() async {
    await ref
        .read(
            programsProvider(category: 'consultation', status: status).notifier)
        .fetchPrograms(category: 'consultation', status: status);
  }

  Future<void> loadMore() async {
    await ref
        .read(
            programsProvider(category: 'consultation', status: status).notifier)
        .loadMore();
  }
}

@riverpod
class TeleexpertisePrograms extends _$TeleexpertisePrograms {
  @override
  ProgramsState build({String? status}) {
    return ProgramsState();
  }

  Future<void> fetch() async {
    await ref
        .read(programsProvider(category: 'teleexpertise', status: status)
            .notifier)
        .fetchPrograms(category: 'teleexpertise', status: status);
  }

  Future<void> loadMore() async {
    await ref
        .read(programsProvider(category: 'teleexpertise', status: status)
            .notifier)
        .loadMore();
  }
}

@riverpod
class DepistagePrograms extends _$DepistagePrograms {
  @override
  ProgramsState build({String? status}) {
    return ProgramsState();
  }

  Future<void> fetch() async {
    await ref
        .read(programsProvider(category: 'depistage', status: status).notifier)
        .fetchPrograms(category: 'depistage', status: status);
  }

  Future<void> loadMore() async {
    await ref
        .read(programsProvider(category: 'depistage', status: status).notifier)
        .loadMore();
  }
}
