// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgeModel _$AgeModelFromJson(Map<String, dynamic> json) => AgeModel(
      age_five: AgeModel._stringToInt(json['age_five']),
      age_four: AgeModel._stringToInt(json['age_four']),
      age_three: AgeModel._stringToInt(json['age_three']),
      age_two: AgeModel._stringToInt(json['age_two']),
      age_one: AgeModel._stringToInt(json['age_one']),
      femme: AgeModel._stringToInt(json['femme']),
      homme: AgeModel._stringToInt(json['homme']),
    );

Map<String, dynamic> _$AgeModelToJson(AgeModel instance) => <String, dynamic>{
      'age_five': instance.age_five,
      'age_four': instance.age_four,
      'age_three': instance.age_three,
      'age_two': instance.age_two,
      'age_one': instance.age_one,
      'femme': instance.femme,
      'homme': instance.homme,
    };
