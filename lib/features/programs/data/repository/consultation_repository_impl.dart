import 'package:digihealth/features/programs/data/datasource/consultation_remote_datasource.dart';
import 'package:digihealth/features/programs/data/models/consultation_response.dart';
import 'package:digihealth/features/programs/domain/repository/consultation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ConsultationRepository
final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  return ConsultationRepositoryImpl(
    ref.read(consultationRemoteDataSourceProvider),
  );
});

/// Implementation of [ConsultationRepository]
class ConsultationRepositoryImpl implements ConsultationRepository {
  final ConsultationRemoteDataSource _remoteDataSource;

  ConsultationRepositoryImpl(this._remoteDataSource);

  @override
  Future<ConsultationResponse> getConsultationData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    try {
      final response = await _remoteDataSource.getConsultationData(
        region: region,
        province: province,
        ummc: ummc,
        from: from,
        to: to,
        tranche: tranche,
        isItinerance: isItinerance,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
