import 'package:json_annotation/json_annotation.dart';
part 'teleexpertise_model.g.dart';

@JsonSerializable()
class TeleExpertisePerRegion {
  final String region;
  final String SUM;
  final String? color;
  TeleExpertisePerRegion({
    required this.region,
    required this.SUM,
    this.color,
  });
  factory TeleExpertisePerRegion.fromJson(Map<String, dynamic> json) =>
      _$TeleExpertisePerRegionFromJson(json);
  Map<String, dynamic> toJson() => _$TeleExpertisePerRegionToJson(this);
}

@JsonSerializable()
class TeleExpertisePerUmmc {
  final String ummc;
  final String SUM;
  TeleExpertisePerUmmc({required this.ummc, required this.SUM});
  factory TeleExpertisePerUmmc.fromJson(Map<String, dynamic> json) =>
      _$TeleExpertisePerUmmcFromJson(json);
  Map<String, dynamic> toJson() => _$TeleExpertisePerUmmcToJson(this);
}
