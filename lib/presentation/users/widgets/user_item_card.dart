import 'package:flutter/material.dart';
import '../../../domain/entities/auth/user.dart';
import '../user_view_model.dart';
import 'user_form_dialog.dart';

class UserItemCard extends StatelessWidget {
  final User user;
  final UserViewModel? userViewModel;

  const UserItemCard({Key? key, required this.user, this.userViewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(leading: CircleAvatar(
        backgroundColor: _getRoleColor(
            user.roles.isNotEmpty ? user.roles.first.name : 'Viewer'),
          child: Text(
            user.username.substring(0, 1).toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
      ), title: Text(
        user.username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: user.isActive ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            SizedBox(height: 4),
            Row(
              children: [Chip(
                  label: Text(
                      user.roles.isNotEmpty ? user.roles.first.name : 'No Role',
                      style: TextStyle(fontSize: 12)),
                backgroundColor: _getRoleColor(
                    user.roles.isNotEmpty ? user.roles.first.name : 'Viewer')
                      .withOpacity(0.2),
                ),
                SizedBox(width: 8),
                if (!user.isActive)
                  Chip(
                    label: Text(
                      'Inactive',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editUser(context);
                break;
              case 'toggle':
                userViewModel?.toggleUserActivation(user.id);
                break;
              case 'delete':
                _deleteUser(context);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(user.isActive ? 'Deactivate' : 'Activate'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
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

  void _editUser(BuildContext context) async {
    final updatedUser = await showDialog<User>(
      context: context,
      builder: (context) => UserFormDialog(user: user),
    );
    if (updatedUser != null && userViewModel != null) {
      userViewModel!.updateUser(updatedUser);
    }
  }

  void _deleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              userViewModel?.deleteUser(user.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
