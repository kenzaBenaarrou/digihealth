import 'package:digihealth/features/programs/data/models/program_model.dart';

/// Abstract repository defining the contract for program data operations
abstract class ProgramRepository {
  /// Fetch programs with optional filters and pagination
  Future<ProgramsResponse> getPrograms({
    String? category,
    String? status,
    String? region,
    String? province,
    String? ummc,
    int page = 1,
    int pageSize = 20,
  });

  /// Fetch a single program by ID
  Future<ProgramModel> getProgramById(String id);
}
