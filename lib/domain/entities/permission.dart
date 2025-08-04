import 'package:equatable/equatable.dart';

enum PermissionType {
  // Product permissions
  viewProducts,
  createProduct,
  editProduct,
  deleteProduct,
  adjustStock,

  // Supplier permissions
  viewSuppliers,
  createSupplier,
  editSupplier,
  deleteSupplier,

  // User permissions
  viewUsers,
  createUser,
  editUser,
  deleteUser,
  manageRoles,

  // Stock take permissions
  viewStockTakes,
  createStockTake,
  performStockTake,
  approveStockTake,

  // Report permissions
  viewReports,
  generateReports,
  exportReports,

  // Activity permissions
  viewActivityLog,
  viewAllActivities,

  // System permissions
  manageSettings,
  backupData,
  restoreData,
  systemMaintenance,
}

class Permission extends Equatable {
  final String id;
  final PermissionType type;
  final String name;
  final String description;
  final String category;

  const Permission({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.category,
  });

  static Permission fromType(PermissionType type) {
    switch (type) {
      // Product permissions
      case PermissionType.viewProducts:
        return Permission(
          id: 'view_products',
          type: type,
          name: 'View Products',
          description: 'Can view product listings and details',
          category: 'Products',
        );
      case PermissionType.createProduct:
        return Permission(
          id: 'create_product',
          type: type,
          name: 'Create Product',
          description: 'Can add new products to the system',
          category: 'Products',
        );
      case PermissionType.editProduct:
        return Permission(
          id: 'edit_product',
          type: type,
          name: 'Edit Product',
          description: 'Can modify existing product information',
          category: 'Products',
        );
      case PermissionType.deleteProduct:
        return Permission(
          id: 'delete_product',
          type: type,
          name: 'Delete Product',
          description: 'Can remove products from the system',
          category: 'Products',
        );
      case PermissionType.adjustStock:
        return Permission(
          id: 'adjust_stock',
          type: type,
          name: 'Adjust Stock',
          description: 'Can modify product stock levels',
          category: 'Products',
        );

      // Supplier permissions
      case PermissionType.viewSuppliers:
        return Permission(
          id: 'view_suppliers',
          type: type,
          name: 'View Suppliers',
          description: 'Can view supplier listings and details',
          category: 'Suppliers',
        );
      case PermissionType.createSupplier:
        return Permission(
          id: 'create_supplier',
          type: type,
          name: 'Create Supplier',
          description: 'Can add new suppliers to the system',
          category: 'Suppliers',
        );
      case PermissionType.editSupplier:
        return Permission(
          id: 'edit_supplier',
          type: type,
          name: 'Edit Supplier',
          description: 'Can modify existing supplier information',
          category: 'Suppliers',
        );
      case PermissionType.deleteSupplier:
        return Permission(
          id: 'delete_supplier',
          type: type,
          name: 'Delete Supplier',
          description: 'Can remove suppliers from the system',
          category: 'Suppliers',
        );

      // User permissions
      case PermissionType.viewUsers:
        return Permission(
          id: 'view_users',
          type: type,
          name: 'View Users',
          description: 'Can view user listings and profiles',
          category: 'Users',
        );
      case PermissionType.createUser:
        return Permission(
          id: 'create_user',
          type: type,
          name: 'Create User',
          description: 'Can add new users to the system',
          category: 'Users',
        );
      case PermissionType.editUser:
        return Permission(
          id: 'edit_user',
          type: type,
          name: 'Edit User',
          description: 'Can modify existing user information',
          category: 'Users',
        );
      case PermissionType.deleteUser:
        return Permission(
          id: 'delete_user',
          type: type,
          name: 'Delete User',
          description: 'Can remove users from the system',
          category: 'Users',
        );
      case PermissionType.manageRoles:
        return Permission(
          id: 'manage_roles',
          type: type,
          name: 'Manage Roles',
          description: 'Can assign and modify user roles',
          category: 'Users',
        );

      // Stock take permissions
      case PermissionType.viewStockTakes:
        return Permission(
          id: 'view_stock_takes',
          type: type,
          name: 'View Stock Takes',
          description: 'Can view stock take history and details',
          category: 'Stock Takes',
        );
      case PermissionType.createStockTake:
        return Permission(
          id: 'create_stock_take',
          type: type,
          name: 'Create Stock Take',
          description: 'Can initiate new stock takes',
          category: 'Stock Takes',
        );
      case PermissionType.performStockTake:
        return Permission(
          id: 'perform_stock_take',
          type: type,
          name: 'Perform Stock Take',
          description: 'Can count and update stock during stock takes',
          category: 'Stock Takes',
        );
      case PermissionType.approveStockTake:
        return Permission(
          id: 'approve_stock_take',
          type: type,
          name: 'Approve Stock Take',
          description: 'Can approve and finalize stock take results',
          category: 'Stock Takes',
        );

      // Report permissions
      case PermissionType.viewReports:
        return Permission(
          id: 'view_reports',
          type: type,
          name: 'View Reports',
          description: 'Can view generated reports',
          category: 'Reports',
        );
      case PermissionType.generateReports:
        return Permission(
          id: 'generate_reports',
          type: type,
          name: 'Generate Reports',
          description: 'Can create new reports',
          category: 'Reports',
        );
      case PermissionType.exportReports:
        return Permission(
          id: 'export_reports',
          type: type,
          name: 'Export Reports',
          description: 'Can export reports to external formats',
          category: 'Reports',
        );

      // Activity permissions
      case PermissionType.viewActivityLog:
        return Permission(
          id: 'view_activity_log',
          type: type,
          name: 'View Activity Log',
          description: 'Can view own activity history',
          category: 'Activities',
        );
      case PermissionType.viewAllActivities:
        return Permission(
          id: 'view_all_activities',
          type: type,
          name: 'View All Activities',
          description: 'Can view all user activities',
          category: 'Activities',
        );

      // System permissions
      case PermissionType.manageSettings:
        return Permission(
          id: 'manage_settings',
          type: type,
          name: 'Manage Settings',
          description: 'Can modify system settings',
          category: 'System',
        );
      case PermissionType.backupData:
        return Permission(
          id: 'backup_data',
          type: type,
          name: 'Backup Data',
          description: 'Can create system backups',
          category: 'System',
        );
      case PermissionType.restoreData:
        return Permission(
          id: 'restore_data',
          type: type,
          name: 'Restore Data',
          description: 'Can restore system from backups',
          category: 'System',
        );
      case PermissionType.systemMaintenance:
        return Permission(
          id: 'system_maintenance',
          type: type,
          name: 'System Maintenance',
          description: 'Can perform system maintenance tasks',
          category: 'System',
        );
    }
  }

  // Default permissions for each role
  static List<PermissionType> getDefaultPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return PermissionType.values; // All permissions

      case UserRole.manager:
        return [
          PermissionType.viewProducts,
          PermissionType.createProduct,
          PermissionType.editProduct,
          PermissionType.deleteProduct,
          PermissionType.adjustStock,
          PermissionType.viewSuppliers,
          PermissionType.createSupplier,
          PermissionType.editSupplier,
          PermissionType.deleteSupplier,
          PermissionType.viewUsers,
          PermissionType.createUser,
          PermissionType.editUser,
          PermissionType.viewStockTakes,
          PermissionType.createStockTake,
          PermissionType.performStockTake,
          PermissionType.approveStockTake,
          PermissionType.viewReports,
          PermissionType.generateReports,
          PermissionType.exportReports,
          PermissionType.viewActivityLog,
          PermissionType.viewAllActivities,
        ];

      case UserRole.supervisor:
        return [
          PermissionType.viewProducts,
          PermissionType.editProduct,
          PermissionType.adjustStock,
          PermissionType.viewSuppliers,
          PermissionType.editSupplier,
          PermissionType.viewUsers,
          PermissionType.viewStockTakes,
          PermissionType.createStockTake,
          PermissionType.performStockTake,
          PermissionType.viewReports,
          PermissionType.generateReports,
          PermissionType.viewActivityLog,
        ];

      case UserRole.staff:
        return [
          PermissionType.viewProducts,
          PermissionType.adjustStock,
          PermissionType.viewSuppliers,
          PermissionType.viewStockTakes,
          PermissionType.performStockTake,
          PermissionType.viewReports,
          PermissionType.viewActivityLog,
        ];

      case UserRole.viewer:
        return [
          PermissionType.viewProducts,
          PermissionType.viewSuppliers,
          PermissionType.viewStockTakes,
          PermissionType.viewReports,
          PermissionType.viewActivityLog,
        ];
    }
  }

  @override
  List<Object?> get props => [id, type, name, description, category];
}

// UserRole enum moved here to avoid circular dependency
enum UserRole { admin, manager, supervisor, staff, viewer }
