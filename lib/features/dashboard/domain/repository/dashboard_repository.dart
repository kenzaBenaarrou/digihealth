import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';

/// Abstract repository defining the contract for dashboard data operations
/// This follows clean architecture principles by separating domain from data layer
abstract class DashboardRepository {
  /// Fetches dashboard data
  /// Optional parameters: [region], [province], [ummc], [from], [to], [tranche], [isItenerance] for filtering
  /// Returns [DashboardResponse] on success
  /// Throws [Failure] on error
  Future<DashboardResponse> getDashboardData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItenerance,
  });
}
