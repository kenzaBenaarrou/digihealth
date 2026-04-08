import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? login;
  final String? avatar;
  final int? tenantId;
  final String? role;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.tenantId,
    this.login,
    this.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? login,
    String? avatar,
    int? tenantId,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      login: login ?? this.login,
      avatar: avatar ?? this.avatar,
      tenantId: tenantId ?? this.tenantId,
      role: role ?? this.role,
    );
  }
}
