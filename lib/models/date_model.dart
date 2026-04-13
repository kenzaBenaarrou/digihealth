import 'package:json_annotation/json_annotation.dart';
part 'date_model.g.dart';

@JsonSerializable()
class DateInfo {
  final String date_activite;
  DateInfo({required this.date_activite});
  factory DateInfo.fromJson(Map<String, dynamic> json) =>
      _$DateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DateInfoToJson(this);
}
