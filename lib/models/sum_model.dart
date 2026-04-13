import 'package:json_annotation/json_annotation.dart';
part 'sum_model.g.dart';

@JsonSerializable()
class SumModel {
  @JsonKey(name: 'SUM', fromJson: _stringToInt)
  final int sum;

  SumModel({required this.sum});

  factory SumModel.fromJson(Map<String, dynamic> json) =>
      _$SumModelFromJson(json);
  Map<String, dynamic> toJson() => _$SumModelToJson(this);

  static int _stringToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
