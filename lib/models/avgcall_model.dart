import 'package:json_annotation/json_annotation.dart';
part 'avgcall_model.g.dart';

@JsonSerializable()
class AvgCallDurationPerSpecialiste {
  final String specialiste;
  final String avg_duration;
  AvgCallDurationPerSpecialiste(
      {required this.specialiste, required this.avg_duration});
  factory AvgCallDurationPerSpecialiste.fromJson(Map<String, dynamic> json) =>
      _$AvgCallDurationPerSpecialisteFromJson(json);
  Map<String, dynamic> toJson() => _$AvgCallDurationPerSpecialisteToJson(this);
}

@JsonSerializable()
class AvgCallDurationPerUmmc {
  final String ummc;
  final String avg_duration;
  AvgCallDurationPerUmmc({required this.ummc, required this.avg_duration});
  factory AvgCallDurationPerUmmc.fromJson(Map<String, dynamic> json) =>
      _$AvgCallDurationPerUmmcFromJson(json);

  Map<String, dynamic> toJson() => _$AvgCallDurationPerUmmcToJson(this);
}
@JsonSerializable()
class AvgCallDurationPerSpecialite {
  final String specialite;
  final String avg_duration;
  AvgCallDurationPerSpecialite(
      {required this.specialite, required this.avg_duration});
  factory AvgCallDurationPerSpecialite.fromJson(Map<String, dynamic> json) =>
      _$AvgCallDurationPerSpecialiteFromJson(json);
  Map<String, dynamic> toJson() => _$AvgCallDurationPerSpecialiteToJson(this);
}
