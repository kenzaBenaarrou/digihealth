import 'package:json_annotation/json_annotation.dart';

part 'program_model.g.dart';

@JsonSerializable()
class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String? category; // consultation, teleexpertise, depistage
  final String? status; // active, upcoming, completed
  final int participants;
  final double progress;
  final String? color;
  final String? icon;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? region;
  final String? province;
  final String? ummc;
  final Map<String, dynamic>? metadata;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.status,
    required this.participants,
    required this.progress,
    this.color,
    this.icon,
    this.startDate,
    this.endDate,
    this.region,
    this.province,
    this.ummc,
    this.metadata,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramModelToJson(this);

  ProgramModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? status,
    int? participants,
    double? progress,
    String? color,
    String? icon,
    DateTime? startDate,
    DateTime? endDate,
    String? region,
    String? province,
    String? ummc,
    Map<String, dynamic>? metadata,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      progress: progress ?? this.progress,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      region: region ?? this.region,
      province: province ?? this.province,
      ummc: ummc ?? this.ummc,
      metadata: metadata ?? this.metadata,
    );
  }
}

@JsonSerializable()
class ProgramsResponse {
  final List<ProgramModel> programs;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  ProgramsResponse({
    required this.programs,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory ProgramsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProgramsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramsResponseToJson(this);
}
