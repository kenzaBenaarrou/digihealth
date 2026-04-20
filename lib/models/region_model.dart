import 'package:json_annotation/json_annotation.dart';

part 'region_model.g.dart';

@JsonSerializable()
class RegionFeatureCollection {
  final String type;
  final List<RegionFeature> features;

  RegionFeatureCollection({required this.type, required this.features});

  factory RegionFeatureCollection.fromJson(Map<String, dynamic> json) =>
      _$RegionFeatureCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionFeatureCollectionToJson(this);
}

@JsonSerializable()
class RegionFeature {
  final String type;
  final RegionGeometry geometry;
  final RegionProperties properties;

  RegionFeature({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  factory RegionFeature.fromJson(Map<String, dynamic> json) =>
      _$RegionFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$RegionFeatureToJson(this);
}

@JsonSerializable()
class RegionGeometry {
  final String type;
  final List<dynamic> coordinates;   // MultiPolygon

  RegionGeometry({required this.type, required this.coordinates});

  factory RegionGeometry.fromJson(Map<String, dynamic> json) =>
      _$RegionGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$RegionGeometryToJson(this);
}

@JsonSerializable()
class RegionProperties {
  final int cartodb_id;
  final String region;

  RegionProperties({required this.cartodb_id, required this.region});

  factory RegionProperties.fromJson(Map<String, dynamic> json) =>
      _$RegionPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$RegionPropertiesToJson(this);
}