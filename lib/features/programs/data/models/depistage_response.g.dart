// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'depistage_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepistageResponse _$DepistageResponseFromJson(Map<String, dynamic> json) =>
    DepistageResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : DepistageData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepistageResponseToJson(DepistageResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

DepistageData _$DepistageDataFromJson(Map<String, dynamic> json) =>
    DepistageData(
      depistageDiabete: json['depistagediabete'] == null
          ? null
          : SumModel.fromJson(json['depistagediabete'] as Map<String, dynamic>),
      depistageHta: json['depistagehta'] == null
          ? null
          : SumModel.fromJson(json['depistagehta'] as Map<String, dynamic>),
      depistageCancerSein: json['depistagecancersein'] == null
          ? null
          : SumModel.fromJson(
              json['depistagecancersein'] as Map<String, dynamic>),
      depistageCancerCol: json['depistagecancercol'] == null
          ? null
          : SumModel.fromJson(
              json['depistagecancercol'] as Map<String, dynamic>),
      depistageCancerColPerRegion:
          (json['depistagecancercolperregion'] as List<dynamic>?)
                  ?.map((e) => RegionData.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      depistageCancerColPerUmmc:
          (json['depistagecancercolperummc'] as List<dynamic>?)
                  ?.map((e) => UmmcData.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      depistageCancerSeinPerRegion:
          (json['depistagecancerseinperregion'] as List<dynamic>?)
                  ?.map((e) => RegionData.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      depistageCancerSeinPerUmmc:
          (json['depistagecancerseinperummc'] as List<dynamic>?)
                  ?.map((e) => UmmcData.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      depistageDiabetePerRegion:
          (json['depistagediabeteperregion'] as List<dynamic>?)
                  ?.map((e) => RegionData.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      depistageDiabetePerUmmc:
          (json['depistagediabeteperummc'] as List<dynamic>?)
                  ?.map((e) => UmmcData.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      depistageHtaPerRegion: (json['depistagehtaperregion'] as List<dynamic>?)
              ?.map((e) => RegionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      depistageHtaPerUmmc: (json['depistagehtaperummc'] as List<dynamic>?)
              ?.map((e) => UmmcData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      maxDate: json['maxDate'] == null
          ? null
          : DateModel.fromJson(json['maxDate'] as Map<String, dynamic>),
      minDate: json['minDate'] == null
          ? null
          : DateModel.fromJson(json['minDate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepistageDataToJson(DepistageData instance) =>
    <String, dynamic>{
      'depistagediabete': instance.depistageDiabete,
      'depistagehta': instance.depistageHta,
      'depistagecancersein': instance.depistageCancerSein,
      'depistagecancercol': instance.depistageCancerCol,
      'depistagecancercolperregion': instance.depistageCancerColPerRegion,
      'depistagecancercolperummc': instance.depistageCancerColPerUmmc,
      'depistagecancerseinperregion': instance.depistageCancerSeinPerRegion,
      'depistagecancerseinperummc': instance.depistageCancerSeinPerUmmc,
      'depistagediabeteperregion': instance.depistageDiabetePerRegion,
      'depistagediabeteperummc': instance.depistageDiabetePerUmmc,
      'depistagehtaperregion': instance.depistageHtaPerRegion,
      'depistagehtaperummc': instance.depistageHtaPerUmmc,
      'maxDate': instance.maxDate,
      'minDate': instance.minDate,
    };
