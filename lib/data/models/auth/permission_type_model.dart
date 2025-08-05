import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth/permission_type.dart';

/// Mirrors the PermissionType enum in domain layer.
@JsonEnum(alwaysCreate: true)
enum PermissionTypeModel {
  @JsonValue('createOrder')
  createOrder,
  @JsonValue('approveOrder')
  approveOrder,
  @JsonValue('receiveStock')
  receiveStock,
  @JsonValue('adjustStock')
  adjustStock,
  @JsonValue('viewReports')
  viewReports,
  @JsonValue('processReturns')
  processReturns,
  @JsonValue('createProduct')
  createProduct,
  @JsonValue('editProduct')
  editProduct,
  @JsonValue('deleteProduct')
  deleteProduct,
  // Add additional permissions here...
}

extension PermissionTypeModelExtension on PermissionTypeModel {
  /// Convert to domain enum
  PermissionType toDomain(PermissionTypeModel permissionModel) =>
      PermissionType.values.byName(name);

  static PermissionTypeModel fromDomain(PermissionType permission) =>
      PermissionTypeModel.values.byName(permission.name);
}
