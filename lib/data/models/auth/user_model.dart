import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/auth/user.dart';
import 'role_model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final List<RoleModel> roles;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    List<RoleModel>? roles,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convert to domain User entity
  User toDomain() => User(
    id: id,
    username: username,
    email: email,
    roles: roles.map((r) => r.toDomain()).toList(),
    isActive: isActive,
  );

  User toEntity() => toDomain();

  static UserModel fromDomain(User user) => UserModel(
    id: user.id,
    username: user.username,
    email: user.email,
    roles: user.roles.map((r) => RoleModel.fromDomain(r)).toList(),
    isActive: user.isActive,
  );

  static UserModel fromEntity(User user) => fromDomain(user);

  @override
  List<Object?> get props => [id, username, email, roles, isActive];
}
