// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataModel _$FilterDataModelFromJson(Map<String, dynamic> json) =>
    FilterDataModel(
      regions:
          (json['regions'] as List<dynamic>).map((e) => e as String).toList(),
      provinces:
          (json['provinces'] as List<dynamic>).map((e) => e as String).toList(),
      ummcs: (json['ummcs'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FilterDataModelToJson(FilterDataModel instance) =>
    <String, dynamic>{
      'regions': instance.regions,
      'provinces': instance.provinces,
      'ummcs': instance.ummcs,
    };
