// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramModel _$ProgramModelFromJson(Map<String, dynamic> json) => ProgramModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      status: json['status'] as String?,
      participants: (json['participants'] as num).toInt(),
      progress: (json['progress'] as num).toDouble(),
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      region: json['region'] as String?,
      province: json['province'] as String?,
      ummc: json['ummc'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProgramModelToJson(ProgramModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'status': instance.status,
      'participants': instance.participants,
      'progress': instance.progress,
      'color': instance.color,
      'icon': instance.icon,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'region': instance.region,
      'province': instance.province,
      'ummc': instance.ummc,
      'metadata': instance.metadata,
    };

ProgramsResponse _$ProgramsResponseFromJson(Map<String, dynamic> json) =>
    ProgramsResponse(
      programs: (json['programs'] as List<dynamic>)
          .map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$ProgramsResponseToJson(ProgramsResponse instance) =>
    <String, dynamic>{
      'programs': instance.programs,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'hasMore': instance.hasMore,
    };
