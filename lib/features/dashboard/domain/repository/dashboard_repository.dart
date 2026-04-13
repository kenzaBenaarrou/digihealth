import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';

/// Abstract repository defining the contract for dashboard data operations
/// This follows clean architecture principles by separating domain from data layer
abstract class DashboardRepository {
  /// Fetches dashboard data
  /// Returns [DashboardResponse] on success
  /// Throws [Failure] on error
  Future<DashboardResponse> getDashboardData();
}
