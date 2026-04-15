// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvolutionBySpecialite _$EvolutionBySpecialiteFromJson(
        Map<String, dynamic> json) =>
    EvolutionBySpecialite(
      date_activite: json['date_activite'] as String,
      specialite: json['specialite'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$EvolutionBySpecialiteToJson(
        EvolutionBySpecialite instance) =>
    <String, dynamic>{
      'date_activite': instance.date_activite,
      'specialite': instance.specialite,
      'count': instance.count,
    };

EvolutionBySpecialiste _$EvolutionBySpecialisteFromJson(
        Map<String, dynamic> json) =>
    EvolutionBySpecialiste(
      date_activite: json['date_activite'] as String,
      specialite: json['specialite'] as String,
      specialisteN: json['specialisteN'] as String?,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$EvolutionBySpecialisteToJson(
        EvolutionBySpecialiste instance) =>
    <String, dynamic>{
      'date_activite': instance.date_activite,
      'specialite': instance.specialite,
      'specialisteN': instance.specialisteN,
      'count': instance.count,
    };

EvolutionCallDuration _$EvolutionCallDurationFromJson(
        Map<String, dynamic> json) =>
    EvolutionCallDuration(
      date_activite: json['date_activite'] as String,
      avg_duration: json['avg_duration'] as String,
    );

Map<String, dynamic> _$EvolutionCallDurationToJson(
        EvolutionCallDuration instance) =>
    <String, dynamic>{
      'date_activite': instance.date_activite,
      'avg_duration': instance.avg_duration,
    };

EvolutionTeleExpertise _$EvolutionTeleExpertiseFromJson(
        Map<String, dynamic> json) =>
    EvolutionTeleExpertise(
      date_activite: json['date_activite'] as String,
      SUM: json['SUM'] as String,
    );

Map<String, dynamic> _$EvolutionTeleExpertiseToJson(
        EvolutionTeleExpertise instance) =>
    <String, dynamic>{
      'date_activite': instance.date_activite,
      'SUM': instance.SUM,
    };

EvolutionTeleExpertiseAvg _$EvolutionTeleExpertiseAvgFromJson(
        Map<String, dynamic> json) =>
    EvolutionTeleExpertiseAvg(
      date_activite: json['date_activite'] as String,
      AVG: json['AVG'] as String,
    );

Map<String, dynamic> _$EvolutionTeleExpertiseAvgToJson(
        EvolutionTeleExpertiseAvg instance) =>
    <String, dynamic>{
      'date_activite': instance.date_activite,
      'AVG': instance.AVG,
    };

EvolutionAnnulation _$EvolutionAnnulationFromJson(Map<String, dynamic> json) =>
    EvolutionAnnulation(
      date: json['date'] as String,
      cancelled: json['cancelled'] as String,
    );

Map<String, dynamic> _$EvolutionAnnulationToJson(
        EvolutionAnnulation instance) =>
    <String, dynamic>{
      'date': instance.date,
      'cancelled': instance.cancelled,
    };
