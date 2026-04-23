import 'package:digihealth/features/programs/data/models/consultation_response.dart';

/// Abstract repository defining the contract for consultation data operations
abstract class ConsultationRepository {
  /// Fetch consultation statistics with optional filters
  Future<ConsultationResponse> getConsultationData({
    String? region,
    String? province,
    String? ummc,
    String? from,
    String? to,
    int? tranche,
    bool? isItinerance,
  });
}
