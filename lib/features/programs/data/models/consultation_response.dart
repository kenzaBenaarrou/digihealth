import 'package:json_annotation/json_annotation.dart';

part 'consultation_response.g.dart';

@JsonSerializable()
class ConsultationResponse {
  @JsonKey(name: 'evacuation_avg')
  final AvgModel? evacuationAvg;

  @JsonKey(name: 'acte_soins')
  final SumModel? acteSoins;

  @JsonKey(name: 'acte_soins_avg')
  final AvgModel? acteSoinsAvg;

  final AgesModel? ages;

  @JsonKey(name: 'consultation_generale')
  final SumModel? consultationGenerale;

  @JsonKey(name: 'consultation_generale_avg')
  final AvgModel? consultationGeneraleAvg;

  @JsonKey(name: 'consultationperregion', defaultValue: [])
  final List<RegionData>? consultationPerRegion;

  @JsonKey(name: 'consultationperummc', defaultValue: [])
  final List<UmmcData>? consultationPerUmmc;

  @JsonKey(name: 'depistagecancercol')
  final SumModel? depistageCancerCol;

  @JsonKey(name: 'depistagecancersein')
  final SumModel? depistageCancerSein;

  @JsonKey(name: 'depistagediabete')
  final SumModel? depistageDiabete;

  @JsonKey(name: 'depistagehta')
  final SumModel? depistageHta;

  final SumModel? evacuation;

  @JsonKey(name: 'evacuationperregion', defaultValue: [])
  final List<RegionData>? evacuationPerRegion;

  @JsonKey(name: 'evacuationperummc', defaultValue: [])
  final List<UmmcData>? evacuationPerUmmc;

  @JsonKey(name: 'evolutionconsultations', defaultValue: [])
  final List<EvolutionData>? evolutionConsultations;

  @JsonKey(name: 'evolutionconsultationsavg', defaultValue: [])
  final List<EvolutionAvgData>? evolutionConsultationsAvg;

  @JsonKey(name: 'evolutionevacuations', defaultValue: [])
  final List<EvolutionData>? evolutionEvacuations;

  @JsonKey(name: 'evolutionevacuationsavg', defaultValue: [])
  final List<EvolutionAvgData>? evolutionEvacuationsAvg;

  @JsonKey(name: 'maxDate')
  final DateModel? maxDate;

  @JsonKey(name: 'minDate')
  final DateModel? minDate;

  @JsonKey(defaultValue: [])
  final List<PathologyData>? pathologies;

  @JsonKey(name: 'pathologiespareto', defaultValue: [])
  final List<PathologyData>? pathologiesPareto;

  final SumModel? referencement;

  @JsonKey(name: 'referencement_avg')
  final AvgModel? referencementAvg;

  @JsonKey(defaultValue: [])
  final List<SpecialityData>? specialities;

  final SumModel? teleexpertise;

  @JsonKey(name: 'total_prise_en_charge')
  final SumModel? totalPriseEnCharge;

  @JsonKey(name: 'total_prise_en_charge_avg')
  final AvgModel? totalPriseEnChargeAvg;

  final SumModel? vaccination;

  @JsonKey(name: 'vaccination_avg')
  final AvgModel? vaccinationAvg;

  ConsultationResponse({
    this.evacuationAvg,
    this.acteSoins,
    this.acteSoinsAvg,
    this.ages,
    this.consultationGenerale,
    this.consultationGeneraleAvg,
    this.consultationPerRegion,
    this.consultationPerUmmc,
    this.depistageCancerCol,
    this.depistageCancerSein,
    this.depistageDiabete,
    this.depistageHta,
    this.evacuation,
    this.evacuationPerRegion,
    this.evacuationPerUmmc,
    this.evolutionConsultations,
    this.evolutionConsultationsAvg,
    this.evolutionEvacuations,
    this.evolutionEvacuationsAvg,
    this.maxDate,
    this.minDate,
    this.pathologies,
    this.pathologiesPareto,
    this.referencement,
    this.referencementAvg,
    this.specialities,
    this.teleexpertise,
    this.totalPriseEnCharge,
    this.totalPriseEnChargeAvg,
    this.vaccination,
    this.vaccinationAvg,
  });

  factory ConsultationResponse.fromJson(Map<String, dynamic> json) =>
      _$ConsultationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationResponseToJson(this);
}

@JsonSerializable()
class SumModel {
  @JsonKey(name: 'SUM')
  final String sum;

  SumModel({required this.sum});

  factory SumModel.fromJson(Map<String, dynamic> json) =>
      _$SumModelFromJson(json);

  Map<String, dynamic> toJson() => _$SumModelToJson(this);

  int get value => int.tryParse(sum) ?? 0;
}

@JsonSerializable()
class AvgModel {
  @JsonKey(name: 'AVG')
  final String avg;

  AvgModel({required this.avg});

  factory AvgModel.fromJson(Map<String, dynamic> json) =>
      _$AvgModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvgModelToJson(this);

  double get value => double.tryParse(avg) ?? 0.0;
}

@JsonSerializable()
class AgesModel {
  final String? femme;
  final String? homme;
  @JsonKey(name: 'age_one')
  final String? ageOne;
  @JsonKey(name: 'age_two')
  final String? ageTwo;
  @JsonKey(name: 'age_three')
  final String? ageThree;
  @JsonKey(name: 'age_four')
  final String? ageFour;
  @JsonKey(name: 'age_five')
  final String? ageFive;
  @JsonKey(name: 'age_six')
  final String? ageSix;
  @JsonKey(name: 'age_seven')
  final String? ageSeven;

  AgesModel({
    this.femme,
    this.homme,
    this.ageOne,
    this.ageTwo,
    this.ageThree,
    this.ageFour,
    this.ageFive,
    this.ageSix,
    this.ageSeven,
  });

  factory AgesModel.fromJson(Map<String, dynamic> json) =>
      _$AgesModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgesModelToJson(this);
}

@JsonSerializable()
class RegionData {
  final String region;
  @JsonKey(name: 'SUM')
  final String sum;
  final String? color;

  RegionData({
    required this.region,
    required this.sum,
    this.color,
  });

  factory RegionData.fromJson(Map<String, dynamic> json) =>
      _$RegionDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDataToJson(this);

  int get value => int.tryParse(sum) ?? 0;
}

@JsonSerializable()
class UmmcData {
  final String ummc;
  @JsonKey(name: 'SUM')
  final String sum;

  UmmcData({
    required this.ummc,
    required this.sum,
  });

  factory UmmcData.fromJson(Map<String, dynamic> json) =>
      _$UmmcDataFromJson(json);

  Map<String, dynamic> toJson() => _$UmmcDataToJson(this);

  int get value => int.tryParse(sum) ?? 0;
}

@JsonSerializable()
class EvolutionData {
  @JsonKey(name: 'date_activite')
  final String dateActivite;
  @JsonKey(name: 'SUM')
  final String sum;

  EvolutionData({
    required this.dateActivite,
    required this.sum,
  });

  factory EvolutionData.fromJson(Map<String, dynamic> json) =>
      _$EvolutionDataFromJson(json);

  Map<String, dynamic> toJson() => _$EvolutionDataToJson(this);

  int get value => int.tryParse(sum) ?? 0;
}

@JsonSerializable()
class EvolutionAvgData {
  @JsonKey(name: 'date_activite')
  final String dateActivite;
  @JsonKey(name: 'AVG')
  final String avg;

  EvolutionAvgData({
    required this.dateActivite,
    required this.avg,
  });

  factory EvolutionAvgData.fromJson(Map<String, dynamic> json) =>
      _$EvolutionAvgDataFromJson(json);

  Map<String, dynamic> toJson() => _$EvolutionAvgDataToJson(this);

  double get value => double.tryParse(avg) ?? 0.0;
}

@JsonSerializable()
class DateModel {
  @JsonKey(name: 'date_activite')
  final String dateActivite;

  DateModel({required this.dateActivite});

  factory DateModel.fromJson(Map<String, dynamic> json) =>
      _$DateModelFromJson(json);

  Map<String, dynamic> toJson() => _$DateModelToJson(this);
}

@JsonSerializable()
class PathologyData {
  final String pathology;
  final int count;

  PathologyData({
    required this.pathology,
    required this.count,
  });

  factory PathologyData.fromJson(Map<String, dynamic> json) =>
      _$PathologyDataFromJson(json);

  Map<String, dynamic> toJson() => _$PathologyDataToJson(this);
}

@JsonSerializable()
class SpecialityData {
  final String specialite;
  @JsonKey(name: 'COUNT')
  final int count;
  final String? color;

  SpecialityData({
    required this.specialite,
    required this.count,
    this.color,
  });

  factory SpecialityData.fromJson(Map<String, dynamic> json) =>
      _$SpecialityDataFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialityDataToJson(this);
}
