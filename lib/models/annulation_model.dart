
import 'package:json_annotation/json_annotation.dart';
part 'annulation_model.g.dart';

@JsonSerializable()
class AnnulationPerUmmc {
  final String ummc;
  final String cancelled;
  AnnulationPerUmmc({required this.ummc, required this.cancelled});
  factory AnnulationPerUmmc.fromJson(Map<String, dynamic> json) => _$AnnulationPerUmmcFromJson(json);
  Map<String, dynamic> toJson() => _$AnnulationPerUmmcToJson(this);
}