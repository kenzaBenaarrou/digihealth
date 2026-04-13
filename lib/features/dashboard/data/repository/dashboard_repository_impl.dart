import 'package:digihealth/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';
import 'package:digihealth/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DashboardRepository
/// This is used for dependency injection throughout the app
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    ref.read(dashboardRemoteDataSourceProvider),
  );
});

/// Implementation of [DashboardRepository]
/// Acts as a mediator between the domain layer and data sources
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardResponse> getDashboardData() async {
    try {
      // Delegate to remote data source
      // In the future, you can add caching logic here
      final response = await _remoteDataSource.getDashboardData();
      return response;
    } catch (e) {
      // Re-throw the error to be handled by the provider layer
      rethrow;
    }
  }
}
