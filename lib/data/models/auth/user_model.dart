import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/auth/user.dart';
import '../../../domain/entities/auth/permission_type.dart';
import 'permission_type_model.dart';
import 'role_model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final List<RoleModel>? roles;
  final bool isActive;
  final bool? isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.roles,
    this.isActive = true,
    this.isEmailVerified,
    this.createdAt,
    this.lastLoginAt,
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
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Convert to domain User entity
  User toDomain() => User(
    id: id,
    username: username,
    email: email,
    roles: roles?.map((r) => r.toDomain()).toList() ?? [],
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

  bool hasPermission(PermissionType permission) {
    if (roles == null) return false;
    final permissionModel = PermissionTypeModelExtension.fromDomain(permission);
    return roles!.any((role) => role.permissions.contains(permissionModel));
  }

  @override
  List<Object?> get props => [id, username, email, roles, isActive, isEmailVerified, createdAt, lastLoginAt];
}
