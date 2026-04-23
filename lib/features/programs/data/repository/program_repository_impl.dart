import 'package:digihealth/features/programs/data/datasource/program_remote_datasource.dart';
import 'package:digihealth/features/programs/data/models/program_model.dart';
import 'package:digihealth/features/programs/domain/repository/program_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ProgramRepository
final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  return ProgramRepositoryImpl(
    ref.read(programRemoteDataSourceProvider),
  );
});

/// Implementation of [ProgramRepository]
class ProgramRepositoryImpl implements ProgramRepository {
  final ProgramRemoteDataSource _remoteDataSource;

  ProgramRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProgramsResponse> getPrograms({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // Delegate to remote data source
      final response = await _remoteDataSource.getPrograms(
        category: category,
        status: status,
        region: region,
        province: province,
        ummc: ummc,
        page: page,
        pageSize: pageSize,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProgramModel> getProgramById(String id) async {
    try {
      final response = await _remoteDataSource.getProgramById(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
