import 'package:json_annotation/json_annotation.dart';
part 'patientper_model.g.dart';

@JsonSerializable()
class PatientPerUmmc {
  final String ummc;
  final String total;
  PatientPerUmmc({required this.ummc, required this.total});
  factory PatientPerUmmc.fromJson(Map<String, dynamic> json) =>
      _$PatientPerUmmcFromJson(json);
  Map<String, dynamic> toJson() => _$PatientPerUmmcToJson(this);
}

@JsonSerializable()
class PatientAvgPerUmmc {
  final String ummc;
  final String avg_count;
  PatientAvgPerUmmc({required this.ummc, required this.avg_count});
  factory PatientAvgPerUmmc.fromJson(Map<String, dynamic> json) =>
      _$PatientAvgPerUmmcFromJson(json);
  Map<String, dynamic> toJson() => _$PatientAvgPerUmmcToJson(this);
}

@JsonSerializable()
class PatientEvolution {
  final String date;
  final String total;
  PatientEvolution({required this.date, required this.total});
  factory PatientEvolution.fromJson(Map<String, dynamic> json) =>
      _$PatientEvolutionFromJson(json);
  Map<String, dynamic> toJson() => _$PatientEvolutionToJson(this);
}
