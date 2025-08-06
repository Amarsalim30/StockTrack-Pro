import 'package:flutter/material.dart';
import '../../../domain/entities/auth/role.dart';

class RoleSelectorDropdown extends StatelessWidget {
  final Role? selectedRole;
  final Function(Role?) onRoleChanged;

  const RoleSelectorDropdown({
    Key? key,
    required this.selectedRole,
    required this.onRoleChanged,
  }) : super(key: key);

  // Define available roles with their permissions
  static const List<String> availableRoleNames = [
    'Admin',
    'Manager',
    'Supervisor',
    'Staff',
    'Viewer'
  ];

  static const Map<String, List<String>> rolePermissions = {
    'Admin': [
      'Create Users',
      'Edit Users',
      'Delete Users',
      'View All Data',
      'Manage Inventory',
      'Generate Reports',
      'System Settings',
    ],
    'Manager': [
      'View Users',
      'View All Data',
      'Manage Inventory',
      'Generate Reports',
      'Approve Orders',
    ],
    'Supervisor': [
      'View Users',
      'View Department Data',
      'Manage Department Inventory',
      'Generate Department Reports',
    ],
    'Staff': ['View Own Data', 'Create Orders', 'Update Inventory'],
    'Viewer': ['View Own Data', 'View Reports'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [DropdownButtonFormField<Role>(
          value: selectedRole,
          decoration: InputDecoration(
            labelText: 'Role',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        items: availableRoleNames.map((roleName) {
          final role = Role(
            id: roleName.toLowerCase(),
            name: roleName,
            permissions: [],
          );
            return DropdownMenuItem(
              value: role,
              child: Row(
                children: [
                  Icon(
                    _getRoleIcon(roleName),
                    size: 20,
                    color: _getRoleColor(roleName),
                  ),
                  SizedBox(width: 8),
                  Text(roleName),
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
              color: _getRoleColor(selectedRole.toString()).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getRoleColor(selectedRole.toString()).withOpacity(0.3),
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
                ...rolePermissions[selectedRole!.name]!.map((permission) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: _getRoleColor(selectedRole!.name),
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

  IconData _getRoleIcon(String roleName) {
    switch (roleName) {
      case 'Admin':
        return Icons.admin_panel_settings;
      case 'Manager':
        return Icons.manage_accounts;
      case 'Supervisor':
        return Icons.supervisor_account;
      case 'Staff':
        return Icons.person;
      case 'Viewer':
        return Icons.visibility;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String roleName) {
    switch (roleName) {
      case 'Admin':
        return Colors.purple;
      case 'Manager':
        return Colors.blue;
      case 'Supervisor':
        return Colors.green;
      case 'Staff':
        return Colors.orange;
      case 'Viewer':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
