// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionFeatureCollection _$RegionFeatureCollectionFromJson(
        Map<String, dynamic> json) =>
    RegionFeatureCollection(
      type: json['type'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => RegionFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegionFeatureCollectionToJson(
        RegionFeatureCollection instance) =>
    <String, dynamic>{
      'type': instance.type,
      'features': instance.features,
    };

RegionFeature _$RegionFeatureFromJson(Map<String, dynamic> json) =>
    RegionFeature(
      type: json['type'] as String,
      geometry:
          RegionGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
      properties:
          RegionProperties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegionFeatureToJson(RegionFeature instance) =>
    <String, dynamic>{
      'type': instance.type,
      'geometry': instance.geometry,
      'properties': instance.properties,
    };

RegionGeometry _$RegionGeometryFromJson(Map<String, dynamic> json) =>
    RegionGeometry(
      type: json['type'] as String,
      coordinates: json['coordinates'] as List<dynamic>,
    );

Map<String, dynamic> _$RegionGeometryToJson(RegionGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

RegionProperties _$RegionPropertiesFromJson(Map<String, dynamic> json) =>
    RegionProperties(
      cartodb_id: (json['cartodb_id'] as num).toInt(),
      region: json['region'] as String,
    );

Map<String, dynamic> _$RegionPropertiesToJson(RegionProperties instance) =>
    <String, dynamic>{
      'cartodb_id': instance.cartodb_id,
      'region': instance.region,
    };
