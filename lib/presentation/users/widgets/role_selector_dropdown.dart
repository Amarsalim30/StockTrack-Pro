import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';

class RoleSelectorDropdown extends StatelessWidget {
  final UserRole? selectedRole;
  final Function(UserRole?) onRoleChanged;

  const RoleSelectorDropdown({
    Key? key,
    required this.selectedRole,
    required this.onRoleChanged,
  }) : super(key: key);

  // Define available roles with their permissions
  static const List<UserRole> availableRoles = UserRole.values;

  static const Map<UserRole, List<String>> rolePermissions = {
    UserRole.admin: [
      'Create Users',
      'Edit Users',
      'Delete Users',
      'View All Data',
      'Manage Inventory',
      'Generate Reports',
      'System Settings',
    ],
    UserRole.manager: [
      'View Users',
      'View All Data',
      'Manage Inventory',
      'Generate Reports',
      'Approve Orders',
    ],
    UserRole.supervisor: [
      'View Users',
      'View Department Data',
      'Manage Department Inventory',
      'Generate Department Reports',
    ],
    UserRole.staff: ['View Own Data', 'Create Orders', 'Update Inventory'],
    UserRole.viewer: ['View Own Data', 'View Reports'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<UserRole>(
          value: selectedRole,
          decoration: InputDecoration(
            labelText: 'Role',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: availableRoles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Row(
                children: [
                  Icon(
                    _getRoleIcon(role),
                    size: 20,
                    color: _getRoleColor(role),
                  ),
                  SizedBox(width: 8),
                  Text(_getRoleName(role)),
                ],
              ),
            );
          }).toList(),
          onChanged: onRoleChanged,
        ),
        if (selectedRole != null) ...[
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getRoleColor(selectedRole!).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getRoleColor(selectedRole!).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Permissions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                ...rolePermissions[selectedRole]!.map((permission) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: _getRoleColor(selectedRole!),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            permission,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.manager:
        return Icons.manage_accounts;
      case UserRole.supervisor:
        return Icons.supervisor_account;
      case UserRole.staff:
        return Icons.person;
      case UserRole.viewer:
        return Icons.visibility;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.purple;
      case UserRole.manager:
        return Colors.blue;
      case UserRole.supervisor:
        return Colors.green;
      case UserRole.staff:
        return Colors.orange;
      case UserRole.viewer:
        return Colors.grey;
    }
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.staff:
        return 'Staff';
      case UserRole.viewer:
        return 'Viewer';
    }
  }
}
