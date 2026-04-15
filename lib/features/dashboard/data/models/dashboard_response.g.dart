// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      ages: json['ages'] == null
          ? null
          : AgeModel.fromJson(json['ages'] as Map<String, dynamic>),
      acte_soins: json['acte_soins'] == null
          ? null
          : SumModel.fromJson(json['acte_soins'] as Map<String, dynamic>),
      annulationperummc: (json['annulationperummc'] as List<dynamic>?)
              ?.map(
                  (e) => AnnulationPerUmmc.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      avgcalldurationperspecialiste:
          (json['avgcalldurationperspecialiste'] as List<dynamic>?)
                  ?.map((e) => AvgCallDurationPerSpecialiste.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              [],
      avgcalldurationperspecialite:
          (json['avgcalldurationperspecialite'] as List<dynamic>?)
                  ?.map((e) => AvgCallDurationPerSpecialite.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              [],
      avgcalldurationperummc: (json['avgcalldurationperummc'] as List<dynamic>?)
              ?.map((e) =>
                  AvgCallDurationPerUmmc.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cancelled_rdv: json['cancelled_rdv'] == null
          ? null
          : SumModel.fromJson(json['cancelled_rdv'] as Map<String, dynamic>),
      closed_rdv: json['closed_rdv'] == null
          ? null
          : SumModel.fromJson(json['closed_rdv'] as Map<String, dynamic>),
      consultationGenerale: json['consultation_generale'] == null
          ? null
          : SumModel.fromJson(
              json['consultation_generale'] as Map<String, dynamic>),
      depistagecancercol: json['depistagecancercol'] == null
          ? null
          : SumModel.fromJson(
              json['depistagecancercol'] as Map<String, dynamic>),
      depistagecancersein: json['depistagecancersein'] == null
          ? null
          : SumModel.fromJson(
              json['depistagecancersein'] as Map<String, dynamic>),
      depistagediabete: json['depistagediabete'] == null
          ? null
          : SumModel.fromJson(json['depistagediabete'] as Map<String, dynamic>),
      depistagehta: json['depistagehta'] == null
          ? null
          : SumModel.fromJson(json['depistagehta'] as Map<String, dynamic>),
      evacuation: json['evacuation'] == null
          ? null
          : SumModel.fromJson(json['evacuation'] as Map<String, dynamic>),
      evolutionannulation: (json['evolutionannulation'] as List<dynamic>?)
              ?.map((e) =>
                  EvolutionAnnulation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionbyspecialite: (json['evolutionbyspecialite'] as List<dynamic>?)
              ?.map((e) =>
                  EvolutionBySpecialite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionbyspecialiste: (json['evolutionbyspecialiste'] as List<dynamic>?)
              ?.map((e) =>
                  EvolutionBySpecialiste.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutioncallduration: (json['evolutioncallduration'] as List<dynamic>?)
              ?.map((e) =>
                  EvolutionCallDuration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionteleexpertise: (json['evolutionteleexpertise'] as List<dynamic>?)
              ?.map((e) =>
                  EvolutionTeleExpertise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionteleexpertiseavg: (json['evolutionteleexpertiseavg']
                  as List<dynamic>?)
              ?.map((e) =>
                  EvolutionTeleExpertiseAvg.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      honored_rdv: json['honored_rdv'] == null
          ? null
          : SumModel.fromJson(json['honored_rdv'] as Map<String, dynamic>),
      maxDate: json['maxDate'] == null
          ? null
          : DateInfo.fromJson(json['maxDate'] as Map<String, dynamic>),
      minDate: json['minDate'] == null
          ? null
          : DateInfo.fromJson(json['minDate'] as Map<String, dynamic>),
      patientavgperummc: (json['patientavgperummc'] as List<dynamic>?)
              ?.map(
                  (e) => PatientAvgPerUmmc.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      patientevolution: (json['patientevolution'] as List<dynamic>?)
              ?.map((e) => PatientEvolution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      patientperummc: (json['patientperummc'] as List<dynamic>?)
              ?.map((e) => PatientPerUmmc.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      patienttotal: json['patienttotal'] == null
          ? null
          : TotalModel.fromJson(json['patienttotal'] as Map<String, dynamic>),
      reserved_rdv: json['reserved_rdv'] == null
          ? null
          : SumModel.fromJson(json['reserved_rdv'] as Map<String, dynamic>),
      specialities: (json['specialities'] as List<dynamic>?)
              ?.map((e) => Speciality.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      teleexpertise: json['teleexpertise'] == null
          ? null
          : SumModel.fromJson(json['teleexpertise'] as Map<String, dynamic>),
      teleexpertiseperregion: (json['teleexpertiseperregion'] as List<dynamic>?)
              ?.map((e) =>
                  TeleExpertisePerRegion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      teleexpertiseperummc: (json['teleexpertiseperummc'] as List<dynamic>?)
              ?.map((e) =>
                  TeleExpertisePerUmmc.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total_prise_en_charge: json['total_prise_en_charge'] == null
          ? null
          : SumModel.fromJson(
              json['total_prise_en_charge'] as Map<String, dynamic>),
      vaccination: json['vaccination'] == null
          ? null
          : SumModel.fromJson(json['vaccination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'acte_soins': instance.acte_soins,
      'ages': instance.ages,
      'annulationperummc': instance.annulationperummc,
      'avgcalldurationperspecialiste': instance.avgcalldurationperspecialiste,
      'avgcalldurationperspecialite': instance.avgcalldurationperspecialite,
      'avgcalldurationperummc': instance.avgcalldurationperummc,
      'cancelled_rdv': instance.cancelled_rdv,
      'closed_rdv': instance.closed_rdv,
      'consultation_generale': instance.consultationGenerale,
      'depistagecancercol': instance.depistagecancercol,
      'depistagecancersein': instance.depistagecancersein,
      'depistagediabete': instance.depistagediabete,
      'depistagehta': instance.depistagehta,
      'evacuation': instance.evacuation,
      'evolutionannulation': instance.evolutionannulation,
      'evolutionbyspecialite': instance.evolutionbyspecialite,
      'evolutionbyspecialiste': instance.evolutionbyspecialiste,
      'evolutioncallduration': instance.evolutioncallduration,
      'evolutionteleexpertise': instance.evolutionteleexpertise,
      'evolutionteleexpertiseavg': instance.evolutionteleexpertiseavg,
      'honored_rdv': instance.honored_rdv,
      'maxDate': instance.maxDate,
      'minDate': instance.minDate,
      'patientavgperummc': instance.patientavgperummc,
      'patientevolution': instance.patientevolution,
      'patientperummc': instance.patientperummc,
      'patienttotal': instance.patienttotal,
      'reserved_rdv': instance.reserved_rdv,
      'specialities': instance.specialities,
      'teleexpertise': instance.teleexpertise,
      'teleexpertiseperregion': instance.teleexpertiseperregion,
      'teleexpertiseperummc': instance.teleexpertiseperummc,
      'total_prise_en_charge': instance.total_prise_en_charge,
      'vaccination': instance.vaccination,
    };
