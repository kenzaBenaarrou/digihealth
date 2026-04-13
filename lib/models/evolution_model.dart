import 'package:json_annotation/json_annotation.dart';
part 'evolution_model.g.dart';

@JsonSerializable()
class EvolutionBySpecialite {
  final String date_activite;
  final String specialite;
  final int count;
  EvolutionBySpecialite({
    required this.date_activite,
    required this.specialite,
    required this.count,
  });
  factory EvolutionBySpecialite.fromJson(Map<String, dynamic> json) =>
      _$EvolutionBySpecialiteFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionBySpecialiteToJson(this);
}

@JsonSerializable()
class EvolutionCallDuration {
  final String date_activite;
  final String avg_duration;
  EvolutionCallDuration(
      {required this.date_activite, required this.avg_duration});
  factory EvolutionCallDuration.fromJson(Map<String, dynamic> json) =>
      _$EvolutionCallDurationFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionCallDurationToJson(this);
}

@JsonSerializable()
class EvolutionTeleExpertise {
  final String date_activite;
  final String SUM;
  EvolutionTeleExpertise({required this.date_activite, required this.SUM});
  factory EvolutionTeleExpertise.fromJson(Map<String, dynamic> json) =>
      _$EvolutionTeleExpertiseFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionTeleExpertiseToJson(this);
}

@JsonSerializable()
class EvolutionTeleExpertiseAvg {
  final String date_activite;
  final String AVG;
  EvolutionTeleExpertiseAvg({required this.date_activite, required this.AVG});
  factory EvolutionTeleExpertiseAvg.fromJson(Map<String, dynamic> json) =>
      _$EvolutionTeleExpertiseAvgFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionTeleExpertiseAvgToJson(this);
}

@JsonSerializable()
class EvolutionAnnulation {
  final String date;
  final String cancelled;

  EvolutionAnnulation({
    required this.date,
    required this.cancelled,
  });
  factory EvolutionAnnulation.fromJson(Map<String, dynamic> json) =>
      _$EvolutionAnnulationFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionAnnulationToJson(this);
}
