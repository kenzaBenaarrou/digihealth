import 'package:digihealth/features/programs/data/datasource/depistage_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/depistage_repository.dart';
import '../models/depistage_response.dart';
final depistageRepositoryProvider = Provider<DepistageRepository>((ref) {
  return DepistageRepositoryImpl(
    remoteDataSource: ref.read(depistageRemoteDatasourceProvider),
  );
});
class DepistageRepositoryImpl implements DepistageRepository {
  final DepistageRemoteDatasource _remoteDataSource;

  DepistageRepositoryImpl({required DepistageRemoteDatasource remoteDataSource}) : _remoteDataSource = remoteDataSource;
  @override
  Future<DepistageResponse> getDepistageData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  }) async {
    try {
      final response = await _remoteDataSource.getDepistageData(
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