import 'package:clean_arch_app/data/models/auth/permission_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/auth/role.dart';

part 'role_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RoleModel extends Equatable {
  final String id;
  final String name;

  @JsonKey(fromJson: _permissionsFromJson, toJson: _permissionsToJson)
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
    permissions: permissions.map((p) => p.toDomain(p)).toList(),
  );

  /// Convert from domain Role entity
  static RoleModel fromDomain(Role role) => RoleModel(
    id: role.id,
    name: role.name,
    permissions: role.permissions
        .map(PermissionTypeModelExtension.fromDomain)
        .toList(),
  );

  /// Handle JSON enum conversion manually
  static List<PermissionTypeModel> _permissionsFromJson(List<dynamic> list) =>
      list.map((e) => PermissionTypeModel.values.byName(e as String)).toList();

  static List<String> _permissionsToJson(List<PermissionTypeModel> list) =>
      list.map((e) => e.name).toList();

  @override
  List<Object?> get props => [id, name, permissions];
}
