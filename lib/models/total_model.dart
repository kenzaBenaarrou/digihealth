import 'package:json_annotation/json_annotation.dart';
part 'total_model.g.dart';

@JsonSerializable()
class TotalModel {
  @JsonKey(fromJson: _stringToInt)
  final int? total;

  TotalModel({this.total});

  factory TotalModel.fromJson(Map<String, dynamic> json) =>
      _$TotalModelFromJson(json);
  Map<String, dynamic> toJson() => _$TotalModelToJson(this);

  static int? _stringToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
