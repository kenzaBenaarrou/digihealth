import 'package:freezed_annotation/freezed_annotation.dart';

part 'speciality_model.g.dart';

@JsonSerializable()
class Speciality {
  final String specialite;
  @JsonKey(fromJson: _stringToInt)
  final int COUNT;
  final String? color;

  Speciality({
    required this.specialite,
    required this.COUNT,
    this.color,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) =>
      _$SpecialityFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialityToJson(this);

  static int _stringToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
