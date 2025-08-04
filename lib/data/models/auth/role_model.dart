import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/auth/role.dart';
import 'permission_type_model.dart';

part 'role_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RoleModel extends Equatable {
  final String id;
  final String name;
  final List<PermissionTypeModel> permissions;

  const RoleModel({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  RoleModel copyWith({
    String? id,
    String? name,
    List<PermissionTypeModel>? permissions,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
    );
  }

  /// Convert to domain Role entity
  Role toDomain() => Role(
    id: id,
    name: name,
    permissions: permissions.map((p) => p.toDomain()).toList(),
  );

  static RoleModel fromDomain(Role role) => RoleModel(
    id: role.id,
    name: role.name,
    permissions: role.permissions.map(PermissionTypeModel.fromDomain).toList(),
  );

  @override
  List<Object?> get props => [id, name, permissions];
}
