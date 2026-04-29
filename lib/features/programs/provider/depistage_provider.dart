import 'package:digihealth/core/error/failure.dart';
import 'package:digihealth/features/programs/data/models/depistage_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repository/depistage_repository_impl.dart';
part 'depistage_provider.g.dart';

class DepistageState{
 final DepistageResponse? data;
  final String? errorMessage;
  final DepistageStatus status;

  DepistageState({
    this.data,
    this.errorMessage,
    this.status = DepistageStatus.initial,
  });

  DepistageState copyWith({
    DepistageResponse? data,
    String? errorMessage,
    DepistageStatus? status,
  }) {
    return DepistageState(
      data: data ?? this.data,
      errorMessage: errorMessage,
      status: status ?? this.status,
    );
  }
}
enum DepistageStatus{
 initial,
  loading,
  success,
  error,
}
@riverpod
class Depistage extends _$Depistage{
  @override
  DepistageState build() {
    return DepistageState();
  }
  
  Future<void> fetchDepistageData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    try {
      state = state.copyWith(status: DepistageStatus.loading);

      final response = await ref.read(depistageRepositoryProvider).getDepistageData(
        region: region,
        province: province,
        ummc: ummc,
        from: from,
        to: to,
        tranche: tranche,
        isItinerance: isItinerance,
      );

      state = state.copyWith(data: response, status: DepistageStatus.success);
    } on Failure catch (failure) {
      state = state.copyWith(
        status: DepistageStatus.error,
        errorMessage: failure.message,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), status: DepistageStatus.error);
    }
  }
  Future<void> refresh({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
try {
      final response = await ref.read(depistageRepositoryProvider).getDepistageData(
        region: region,
        province: province,
        ummc: ummc,
        from: from,
        to: to,
        tranche: tranche,
        isItinerance: isItinerance,
      );

      state = state.copyWith(data: response, status: DepistageStatus.success);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), status: DepistageStatus.error);
    }
  }
    void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: DepistageStatus.initial,
    );
  }
}
@riverpod
bool isDepistageLoading(IsDepistageLoadingRef ref) {
  final depistageState = ref.watch(depistageProvider);
  return depistageState.status == DepistageStatus.loading;
}

@riverpod
String? depistageError(DepistageErrorRef ref) {
  final depistageState = ref.watch(depistageProvider);
  return depistageState.status == DepistageStatus.error
      ? depistageState.errorMessage
      : null;
}

@riverpod
DepistageResponse? depistageData(DepistageDataRef ref) {
  final depistageState = ref.watch(depistageProvider);
  return depistageState.status == DepistageStatus.success
      ? depistageState.data
      : null;
}