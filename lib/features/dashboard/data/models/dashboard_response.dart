import 'package:digihealth/models/age_model.dart';
import 'package:digihealth/models/annulation_model.dart';
import 'package:digihealth/models/avgcall_model.dart';
import 'package:digihealth/models/date_model.dart';
import 'package:digihealth/models/evolution_model.dart';
import 'package:digihealth/models/patientper_model.dart';
import 'package:digihealth/models/speciality_model.dart';
import 'package:digihealth/models/sum_model.dart';
import 'package:digihealth/models/teleexpertise_model.dart';
import 'package:digihealth/models/total_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_response.g.dart';

@JsonSerializable()
class DashboardResponse {
  final SumModel? acte_soins;
  final AgeModel? ages;
  @JsonKey(defaultValue: [])
  final List<AnnulationPerUmmc>? annulationperummc;
  @JsonKey(defaultValue: [])
  final List<AvgCallDurationPerSpecialiste>? avgcalldurationperspecialiste;
  @JsonKey(defaultValue: [])
  final List<AvgCallDurationPerSpecialiste>? avgcalldurationperspecialite;
  @JsonKey(defaultValue: [])
  final List<AvgCallDurationPerUmmc>? avgcalldurationperummc;
  final SumModel? cancelled_rdv;
  final SumModel? closed_rdv;
  @JsonKey(name: 'consultation_generale')
  final SumModel? consultationGenerale;
  final SumModel? depistagecancercol;
  final SumModel? depistagecancersein;
  final SumModel? depistagediabete;
  final SumModel? depistagehta;
  final SumModel? evacuation;
  @JsonKey(defaultValue: [])
  final List<EvolutionAnnulation>? evolutionannulation;
  @JsonKey(defaultValue: [])
  final List<EvolutionBySpecialite>? evolutionbyspecialite;
  @JsonKey(defaultValue: [])
  final List<EvolutionCallDuration>? evolutioncallduration;
  @JsonKey(defaultValue: [])
  final List<EvolutionTeleExpertise>? evolutionteleexpertise;
  @JsonKey(defaultValue: [])
  final List<EvolutionTeleExpertiseAvg>? evolutionteleexpertiseavg;
  final SumModel? honored_rdv;
  final DateInfo? maxDate;
  final DateInfo? minDate;
  @JsonKey(defaultValue: [])
  final List<PatientAvgPerUmmc>? patientavgperummc;
  @JsonKey(defaultValue: [])
  final List<PatientEvolution>? patientevolution;
  @JsonKey(defaultValue: [])
  final List<PatientPerUmmc>? patientperummc;
  final TotalModel? patienttotal;
  final SumModel? reserved_rdv;
  @JsonKey(defaultValue: [])
  final List<Speciality>? specialities;
  final SumModel? teleexpertise;
  @JsonKey(defaultValue: [])
  final List<TeleExpertisePerRegion>? teleexpertiseperregion;
  @JsonKey(defaultValue: [])
  final List<TeleExpertisePerUmmc>? teleexpertiseperummc;
  final SumModel? total_prise_en_charge;
  final SumModel? vaccination;

  DashboardResponse({
    this.acte_soins,
    this.ages,
    this.annulationperummc,
    this.avgcalldurationperspecialiste,
    this.avgcalldurationperspecialite,
    this.avgcalldurationperummc,
    this.cancelled_rdv,
    this.closed_rdv,
    this.consultationGenerale,
    this.depistagecancercol,
    this.depistagecancersein,
    this.depistagediabete,
    this.depistagehta,
    this.evacuation,
    this.evolutionannulation,
    this.evolutionbyspecialite,
    this.evolutioncallduration,
    this.evolutionteleexpertise,
    this.evolutionteleexpertiseavg,
    this.honored_rdv,
    this.maxDate,
    this.minDate,
    this.patientavgperummc,
    this.patientevolution,
    this.patientperummc,
    this.patienttotal,
    this.reserved_rdv,
    this.specialities,
    this.teleexpertise,
    this.teleexpertiseperregion,
    this.teleexpertiseperummc,
    this.total_prise_en_charge,
    this.vaccination,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);
}
