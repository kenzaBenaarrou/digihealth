import 'package:json_annotation/json_annotation.dart';
part 'age_model.g.dart';

@JsonSerializable()
class AgeModel {
  @JsonKey(fromJson: _stringToInt)
  final int? age_five;
  @JsonKey(fromJson: _stringToInt)
  final int? age_four;
  @JsonKey(fromJson: _stringToInt)
  final int? age_three;
  @JsonKey(fromJson: _stringToInt)
  final int? age_two;
  @JsonKey(fromJson: _stringToInt)
  final int? age_one;
  @JsonKey(fromJson: _stringToInt)
  final int? femme;
  @JsonKey(fromJson: _stringToInt)
  final int? homme;

  AgeModel({
    this.age_five,
    this.age_four,
    this.age_three,
    this.age_two,
    this.age_one,
    this.femme,
    this.homme,
  });

  factory AgeModel.fromJson(Map<String, dynamic> json) =>
      _$AgeModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgeModelToJson(this);

  static int? _stringToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
