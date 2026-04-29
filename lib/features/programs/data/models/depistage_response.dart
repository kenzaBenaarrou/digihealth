import 'package:json_annotation/json_annotation.dart';
import 'consultation_response.dart';

part 'depistage_response.g.dart';

@JsonSerializable()
class DepistageResponse {
  final String status;
  final DepistageData? data;

  DepistageResponse({
    required this.status,
    this.data,
  });

  factory DepistageResponse.fromJson(Map<String, dynamic> json) =>
      _$DepistageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepistageResponseToJson(this);
}

@JsonSerializable()
class DepistageData {
  @JsonKey(name: 'depistagediabete')
  final SumModel? depistageDiabete;

  @JsonKey(name: 'depistagehta')
  final SumModel? depistageHta;

  @JsonKey(name: 'depistagecancersein')
  final SumModel? depistageCancerSein;

  @JsonKey(name: 'depistagecancercol')
  final SumModel? depistageCancerCol;

  @JsonKey(name: 'depistagecancercolperregion', defaultValue: [])
  final List<RegionData>? depistageCancerColPerRegion;

  @JsonKey(name: 'depistagecancercolperummc', defaultValue: [])
  final List<UmmcData>? depistageCancerColPerUmmc;

  @JsonKey(name: 'depistagecancerseinperregion', defaultValue: [])
  final List<RegionData>? depistageCancerSeinPerRegion;

  @JsonKey(name: 'depistagecancerseinperummc', defaultValue: [])
  final List<UmmcData>? depistageCancerSeinPerUmmc;

  @JsonKey(name: 'depistagediabeteperregion', defaultValue: [])
  final List<RegionData>? depistageDiabetePerRegion;

  @JsonKey(name: 'depistagediabeteperummc', defaultValue: [])
  final List<UmmcData>? depistageDiabetePerUmmc;

  @JsonKey(name: 'depistagehtaperregion', defaultValue: [])
  final List<RegionData>? depistageHtaPerRegion;

  @JsonKey(name: 'depistagehtaperummc', defaultValue: [])
  final List<UmmcData>? depistageHtaPerUmmc;

  @JsonKey(name: 'maxDate')
  final DateModel? maxDate;

  @JsonKey(name: 'minDate')
  final DateModel? minDate;

  DepistageData({
    this.depistageDiabete,
    this.depistageHta,
    this.depistageCancerSein,
    this.depistageCancerCol,
    this.depistageCancerColPerRegion,
    this.depistageCancerColPerUmmc,
    this.depistageCancerSeinPerRegion,
    this.depistageCancerSeinPerUmmc,
    this.depistageDiabetePerRegion,
    this.depistageDiabetePerUmmc,
    this.depistageHtaPerRegion,
    this.depistageHtaPerUmmc,
    this.maxDate,
    this.minDate,
  });

  factory DepistageData.fromJson(Map<String, dynamic> json) =>
      _$DepistageDataFromJson(json);

  Map<String, dynamic> toJson() => _$DepistageDataToJson(this);
}
