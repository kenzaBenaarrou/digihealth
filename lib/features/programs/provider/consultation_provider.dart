import 'package:digihealth/core/error/failure.dart';
import 'package:digihealth/features/programs/data/models/consultation_response.dart';
import 'package:digihealth/features/programs/data/repository/consultation_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consultation_provider.g.dart';

/// State for consultation data
class ConsultationState {
  final ConsultationResponse? data;
  final String? errorMessage;
  final ConsultationStatus status;

  ConsultationState({
    this.data,
    this.errorMessage,
    this.status = ConsultationStatus.initial,
  });

  ConsultationState copyWith({
    ConsultationResponse? data,
    String? errorMessage,
    ConsultationStatus? status,
  }) {
    return ConsultationState(
      data: data ?? this.data,
      errorMessage: errorMessage,
      status: status ?? this.status,
    );
  }
}

enum ConsultationStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider for consultation statistics
@riverpod
class Consultation extends _$Consultation {
  @override
  ConsultationState build() {
    return ConsultationState();
  }

  /// Fetch consultation data with filters
  Future<void> fetchConsultationData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    try {
      state = state.copyWith(status: ConsultationStatus.loading);

      final response =
          await ref.read(consultationRepositoryProvider).getConsultationData(
                region: region,
                province: province,
                ummc: ummc,
                from: from,
                to: to,
                tranche: tranche,
                isItinerance: isItinerance,
              );

      state = state.copyWith(
        status: ConsultationStatus.success,
        data: response,
        errorMessage: null,
      );
    } on Failure catch (failure) {
      state = state.copyWith(
        status: ConsultationStatus.error,
        errorMessage: failure.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: ConsultationStatus.error,
        errorMessage:
            'An unexpected error occurred while loading consultation data',
      );
    }
  }

  /// Refresh consultation data
  Future<void> refresh({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    await fetchConsultationData(
      region: region,
      province: province,
      ummc: ummc,
      from: from,
      to: to,
      tranche: tranche,
      isItinerance: isItinerance,
    );
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: ConsultationStatus.initial,
    );
  }
}

/// Convenience providers for accessing specific parts of consultation data
@riverpod
bool isConsultationLoading(IsConsultationLoadingRef ref) {
  final consultationState = ref.watch(consultationProvider);
  return consultationState.status == ConsultationStatus.loading;
}

@riverpod
String? consultationError(ConsultationErrorRef ref) {
  final consultationState = ref.watch(consultationProvider);
  return consultationState.status == ConsultationStatus.error
      ? consultationState.errorMessage
      : null;
}

@riverpod
ConsultationResponse? consultationData(ConsultationDataRef ref) {
  final consultationState = ref.watch(consultationProvider);
  return consultationState.status == ConsultationStatus.success
      ? consultationState.data
      : null;
}
