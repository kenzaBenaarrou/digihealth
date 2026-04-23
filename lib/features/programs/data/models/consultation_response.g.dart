// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationResponse _$ConsultationResponseFromJson(
        Map<String, dynamic> json) =>
    ConsultationResponse(
      evacuationAvg: json['evacuation_avg'] == null
          ? null
          : AvgModel.fromJson(json['evacuation_avg'] as Map<String, dynamic>),
      acteSoins: json['acte_soins'] == null
          ? null
          : SumModel.fromJson(json['acte_soins'] as Map<String, dynamic>),
      acteSoinsAvg: json['acte_soins_avg'] == null
          ? null
          : AvgModel.fromJson(json['acte_soins_avg'] as Map<String, dynamic>),
      ages: json['ages'] == null
          ? null
          : AgesModel.fromJson(json['ages'] as Map<String, dynamic>),
      consultationGenerale: json['consultation_generale'] == null
          ? null
          : SumModel.fromJson(
              json['consultation_generale'] as Map<String, dynamic>),
      consultationGeneraleAvg: json['consultation_generale_avg'] == null
          ? null
          : AvgModel.fromJson(
              json['consultation_generale_avg'] as Map<String, dynamic>),
      consultationPerRegion: (json['consultationperregion'] as List<dynamic>?)
              ?.map((e) => RegionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      consultationPerUmmc: (json['consultationperummc'] as List<dynamic>?)
              ?.map((e) => UmmcData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      depistageCancerCol: json['depistagecancercol'] == null
          ? null
          : SumModel.fromJson(
              json['depistagecancercol'] as Map<String, dynamic>),
      depistageCancerSein: json['depistagecancersein'] == null
          ? null
          : SumModel.fromJson(
              json['depistagecancersein'] as Map<String, dynamic>),
      depistageDiabete: json['depistagediabete'] == null
          ? null
          : SumModel.fromJson(json['depistagediabete'] as Map<String, dynamic>),
      depistageHta: json['depistagehta'] == null
          ? null
          : SumModel.fromJson(json['depistagehta'] as Map<String, dynamic>),
      evacuation: json['evacuation'] == null
          ? null
          : SumModel.fromJson(json['evacuation'] as Map<String, dynamic>),
      evacuationPerRegion: (json['evacuationperregion'] as List<dynamic>?)
              ?.map((e) => RegionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evacuationPerUmmc: (json['evacuationperummc'] as List<dynamic>?)
              ?.map((e) => UmmcData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionConsultations: (json['evolutionconsultations'] as List<dynamic>?)
              ?.map((e) => EvolutionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionConsultationsAvg: (json['evolutionconsultationsavg']
                  as List<dynamic>?)
              ?.map((e) => EvolutionAvgData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionEvacuations: (json['evolutionevacuations'] as List<dynamic>?)
              ?.map((e) => EvolutionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionEvacuationsAvg: (json['evolutionevacuationsavg']
                  as List<dynamic>?)
              ?.map((e) => EvolutionAvgData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      maxDate: json['maxDate'] == null
          ? null
          : DateModel.fromJson(json['maxDate'] as Map<String, dynamic>),
      minDate: json['minDate'] == null
          ? null
          : DateModel.fromJson(json['minDate'] as Map<String, dynamic>),
      pathologies: (json['pathologies'] as List<dynamic>?)
              ?.map((e) => PathologyData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pathologiesPareto: (json['pathologiespareto'] as List<dynamic>?)
              ?.map((e) => PathologyData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      referencement: json['referencement'] == null
          ? null
          : SumModel.fromJson(json['referencement'] as Map<String, dynamic>),
      referencementAvg: json['referencement_avg'] == null
          ? null
          : AvgModel.fromJson(
              json['referencement_avg'] as Map<String, dynamic>),
      specialities: (json['specialities'] as List<dynamic>?)
              ?.map((e) => SpecialityData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      teleexpertise: json['teleexpertise'] == null
          ? null
          : SumModel.fromJson(json['teleexpertise'] as Map<String, dynamic>),
      totalPriseEnCharge: json['total_prise_en_charge'] == null
          ? null
          : SumModel.fromJson(
              json['total_prise_en_charge'] as Map<String, dynamic>),
      totalPriseEnChargeAvg: json['total_prise_en_charge_avg'] == null
          ? null
          : AvgModel.fromJson(
              json['total_prise_en_charge_avg'] as Map<String, dynamic>),
      vaccination: json['vaccination'] == null
          ? null
          : SumModel.fromJson(json['vaccination'] as Map<String, dynamic>),
      vaccinationAvg: json['vaccination_avg'] == null
          ? null
          : AvgModel.fromJson(json['vaccination_avg'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConsultationResponseToJson(
        ConsultationResponse instance) =>
    <String, dynamic>{
      'evacuation_avg': instance.evacuationAvg,
      'acte_soins': instance.acteSoins,
      'acte_soins_avg': instance.acteSoinsAvg,
      'ages': instance.ages,
      'consultation_generale': instance.consultationGenerale,
      'consultation_generale_avg': instance.consultationGeneraleAvg,
      'consultationperregion': instance.consultationPerRegion,
      'consultationperummc': instance.consultationPerUmmc,
      'depistagecancercol': instance.depistageCancerCol,
      'depistagecancersein': instance.depistageCancerSein,
      'depistagediabete': instance.depistageDiabete,
      'depistagehta': instance.depistageHta,
      'evacuation': instance.evacuation,
      'evacuationperregion': instance.evacuationPerRegion,
      'evacuationperummc': instance.evacuationPerUmmc,
      'evolutionconsultations': instance.evolutionConsultations,
      'evolutionconsultationsavg': instance.evolutionConsultationsAvg,
      'evolutionevacuations': instance.evolutionEvacuations,
      'evolutionevacuationsavg': instance.evolutionEvacuationsAvg,
      'maxDate': instance.maxDate,
      'minDate': instance.minDate,
      'pathologies': instance.pathologies,
      'pathologiespareto': instance.pathologiesPareto,
      'referencement': instance.referencement,
      'referencement_avg': instance.referencementAvg,
      'specialities': instance.specialities,
      'teleexpertise': instance.teleexpertise,
      'total_prise_en_charge': instance.totalPriseEnCharge,
      'total_prise_en_charge_avg': instance.totalPriseEnChargeAvg,
      'vaccination': instance.vaccination,
      'vaccination_avg': instance.vaccinationAvg,
    };

SumModel _$SumModelFromJson(Map<String, dynamic> json) => SumModel(
      sum: json['SUM'] as String,
    );

Map<String, dynamic> _$SumModelToJson(SumModel instance) => <String, dynamic>{
      'SUM': instance.sum,
    };

AvgModel _$AvgModelFromJson(Map<String, dynamic> json) => AvgModel(
      avg: json['AVG'] as String,
    );

Map<String, dynamic> _$AvgModelToJson(AvgModel instance) => <String, dynamic>{
      'AVG': instance.avg,
    };

AgesModel _$AgesModelFromJson(Map<String, dynamic> json) => AgesModel(
      femme: json['femme'] as String?,
      homme: json['homme'] as String?,
      ageOne: json['age_one'] as String?,
      ageTwo: json['age_two'] as String?,
      ageThree: json['age_three'] as String?,
      ageFour: json['age_four'] as String?,
      ageFive: json['age_five'] as String?,
      ageSix: json['age_six'] as String?,
      ageSeven: json['age_seven'] as String?,
    );

Map<String, dynamic> _$AgesModelToJson(AgesModel instance) => <String, dynamic>{
      'femme': instance.femme,
      'homme': instance.homme,
      'age_one': instance.ageOne,
      'age_two': instance.ageTwo,
      'age_three': instance.ageThree,
      'age_four': instance.ageFour,
      'age_five': instance.ageFive,
      'age_six': instance.ageSix,
      'age_seven': instance.ageSeven,
    };

RegionData _$RegionDataFromJson(Map<String, dynamic> json) => RegionData(
      region: json['region'] as String,
      sum: json['SUM'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$RegionDataToJson(RegionData instance) =>
    <String, dynamic>{
      'region': instance.region,
      'SUM': instance.sum,
      'color': instance.color,
    };

UmmcData _$UmmcDataFromJson(Map<String, dynamic> json) => UmmcData(
      ummc: json['ummc'] as String,
      sum: json['SUM'] as String,
    );

Map<String, dynamic> _$UmmcDataToJson(UmmcData instance) => <String, dynamic>{
      'ummc': instance.ummc,
      'SUM': instance.sum,
    };

EvolutionData _$EvolutionDataFromJson(Map<String, dynamic> json) =>
    EvolutionData(
      dateActivite: json['date_activite'] as String,
      sum: json['SUM'] as String,
    );

Map<String, dynamic> _$EvolutionDataToJson(EvolutionData instance) =>
    <String, dynamic>{
      'date_activite': instance.dateActivite,
      'SUM': instance.sum,
    };

EvolutionAvgData _$EvolutionAvgDataFromJson(Map<String, dynamic> json) =>
    EvolutionAvgData(
      dateActivite: json['date_activite'] as String,
      avg: json['AVG'] as String,
    );

Map<String, dynamic> _$EvolutionAvgDataToJson(EvolutionAvgData instance) =>
    <String, dynamic>{
      'date_activite': instance.dateActivite,
      'AVG': instance.avg,
    };

DateModel _$DateModelFromJson(Map<String, dynamic> json) => DateModel(
      dateActivite: json['date_activite'] as String,
    );

Map<String, dynamic> _$DateModelToJson(DateModel instance) => <String, dynamic>{
      'date_activite': instance.dateActivite,
    };

PathologyData _$PathologyDataFromJson(Map<String, dynamic> json) =>
    PathologyData(
      pathology: json['pathology'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$PathologyDataToJson(PathologyData instance) =>
    <String, dynamic>{
      'pathology': instance.pathology,
      'count': instance.count,
    };

SpecialityData _$SpecialityDataFromJson(Map<String, dynamic> json) =>
    SpecialityData(
      specialite: json['specialite'] as String,
      count: (json['COUNT'] as num).toInt(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$SpecialityDataToJson(SpecialityData instance) =>
    <String, dynamic>{
      'specialite': instance.specialite,
      'COUNT': instance.count,
      'color': instance.color,
    };
