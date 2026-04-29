import '../../data/models/depistage_response.dart';

abstract class DepistageRepository {
  /// Fetch depistage statistics with optional filters
  Future<DepistageResponse> getDepistageData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  });
}