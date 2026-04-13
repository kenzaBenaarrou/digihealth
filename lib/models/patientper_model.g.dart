// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patientper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientPerUmmc _$PatientPerUmmcFromJson(Map<String, dynamic> json) =>
    PatientPerUmmc(
      ummc: json['ummc'] as String,
      total: json['total'] as String,
    );

Map<String, dynamic> _$PatientPerUmmcToJson(PatientPerUmmc instance) =>
    <String, dynamic>{
      'ummc': instance.ummc,
      'total': instance.total,
    };

PatientAvgPerUmmc _$PatientAvgPerUmmcFromJson(Map<String, dynamic> json) =>
    PatientAvgPerUmmc(
      ummc: json['ummc'] as String,
      avg_count: json['avg_count'] as String,
    );

Map<String, dynamic> _$PatientAvgPerUmmcToJson(PatientAvgPerUmmc instance) =>
    <String, dynamic>{
      'ummc': instance.ummc,
      'avg_count': instance.avg_count,
    };

PatientEvolution _$PatientEvolutionFromJson(Map<String, dynamic> json) =>
    PatientEvolution(
      date: json['date'] as String,
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PatientEvolutionToJson(PatientEvolution instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total': instance.total,
    };
