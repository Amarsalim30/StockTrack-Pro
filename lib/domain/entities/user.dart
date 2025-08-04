import 'package:equatable/equatable.dart';
import 'permission.dart';

// UserRole is now defined in permission.dart to avoid circular dependency
export 'permission.dart' show UserRole;

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phoneNumber;
  final String? department;
  final List<PermissionType> permissions;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.department,
    List<PermissionType>? permissions,
    this.isActive = true,
    this.lastLogin,
    required this.createdAt,
    this.updatedAt,
  }) : permissions = permissions ?? const [];

  // Role-based getters
  bool get isAdmin => role == UserRole.admin;

  bool get isManager => role == UserRole.manager;

  bool get isSupervisor => role == UserRole.supervisor;

  bool get isStaff => role == UserRole.staff;

  bool get isViewer => role == UserRole.viewer;

  // Permission helpers
  bool hasPermission(PermissionType permission) {
    // Admin has all permissions by default
    if (isAdmin) return true;

    // Check if user has specific permission
    if (permissions.contains(permission)) return true;

    // Check if role has default permission
    final defaultPermissions = Permission.getDefaultPermissionsForRole(role);
    return defaultPermissions.contains(permission);
  }

  // Common permission checks
  bool get canViewProducts => hasPermission(PermissionType.viewProducts);

  bool get canCreateProduct => hasPermission(PermissionType.createProduct);

  bool get canEditProduct => hasPermission(PermissionType.editProduct);

  bool get canDeleteProduct => hasPermission(PermissionType.deleteProduct);

  bool get canAdjustStock => hasPermission(PermissionType.adjustStock);

  bool get canViewUsers => hasPermission(PermissionType.viewUsers);

  bool get canCreateUser => hasPermission(PermissionType.createUser);

  bool get canEditUser => hasPermission(PermissionType.editUser);

  bool get canDeleteUser => hasPermission(PermissionType.deleteUser);

  bool get canManageRoles => hasPermission(PermissionType.manageRoles);

  bool get canViewSuppliers => hasPermission(PermissionType.viewSuppliers);

  bool get canCreateSupplier => hasPermission(PermissionType.createSupplier);

  bool get canEditSupplier => hasPermission(PermissionType.editSupplier);

  bool get canDeleteSupplier => hasPermission(PermissionType.deleteSupplier);

  bool get canViewReports => hasPermission(PermissionType.viewReports);

  bool get canGenerateReports => hasPermission(PermissionType.generateReports);

  bool get canExportReports => hasPermission(PermissionType.exportReports);

  bool get canViewActivityLog => hasPermission(PermissionType.viewActivityLog);

  bool get canViewAllActivities =>
      hasPermission(PermissionType.viewAllActivities);

  bool get canManageSettings => hasPermission(PermissionType.manageSettings);

  // Legacy compatibility
  bool get canEdit => canEditProduct || canEditUser || canEditSupplier;

  bool get canDelete => canDeleteProduct || canDeleteUser || canDeleteSupplier;

  bool get canManageUsers =>
      canCreateUser || canEditUser || canDeleteUser || canManageRoles;

  // Get all effective permissions (role defaults + custom)
  List<PermissionType> get effectivePermissions {
    if (isAdmin) return PermissionType.values;

    final defaultPermissions = Permission.getDefaultPermissionsForRole(role);
    final allPermissions = {...defaultPermissions, ...permissions};
    return allPermissions.toList();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    phoneNumber,
    department,
    permissions,
    isActive,
    lastLogin,
    createdAt,
    updatedAt,
  ];
}
