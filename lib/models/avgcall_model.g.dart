// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avgcall_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvgCallDurationPerSpecialiste _$AvgCallDurationPerSpecialisteFromJson(
        Map<String, dynamic> json) =>
    AvgCallDurationPerSpecialiste(
      specialiste: json['specialiste'] as String,
      avg_duration: json['avg_duration'] as String,
    );

Map<String, dynamic> _$AvgCallDurationPerSpecialisteToJson(
        AvgCallDurationPerSpecialiste instance) =>
    <String, dynamic>{
      'specialiste': instance.specialiste,
      'avg_duration': instance.avg_duration,
    };

AvgCallDurationPerUmmc _$AvgCallDurationPerUmmcFromJson(
        Map<String, dynamic> json) =>
    AvgCallDurationPerUmmc(
      ummc: json['ummc'] as String,
      avg_duration: json['avg_duration'] as String,
    );

Map<String, dynamic> _$AvgCallDurationPerUmmcToJson(
        AvgCallDurationPerUmmc instance) =>
    <String, dynamic>{
      'ummc': instance.ummc,
      'avg_duration': instance.avg_duration,
    };
