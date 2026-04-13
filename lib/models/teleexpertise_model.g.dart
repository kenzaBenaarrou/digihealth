// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teleexpertise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeleExpertisePerRegion _$TeleExpertisePerRegionFromJson(
        Map<String, dynamic> json) =>
    TeleExpertisePerRegion(
      region: json['region'] as String,
      SUM: json['SUM'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$TeleExpertisePerRegionToJson(
        TeleExpertisePerRegion instance) =>
    <String, dynamic>{
      'region': instance.region,
      'SUM': instance.SUM,
      'color': instance.color,
    };

TeleExpertisePerUmmc _$TeleExpertisePerUmmcFromJson(
        Map<String, dynamic> json) =>
    TeleExpertisePerUmmc(
      ummc: json['ummc'] as String,
      SUM: json['SUM'] as String,
    );

Map<String, dynamic> _$TeleExpertisePerUmmcToJson(
        TeleExpertisePerUmmc instance) =>
    <String, dynamic>{
      'ummc': instance.ummc,
      'SUM': instance.SUM,
    };
