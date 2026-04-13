// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speciality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Speciality _$SpecialityFromJson(Map<String, dynamic> json) => Speciality(
      specialite: json['specialite'] as String,
      COUNT: Speciality._stringToInt(json['COUNT']),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$SpecialityToJson(Speciality instance) =>
    <String, dynamic>{
      'specialite': instance.specialite,
      'COUNT': instance.COUNT,
      'color': instance.color,
    };
