import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';
import '../user_view_model.dart';
import 'role_selector_dropdown.dart';

class UserFormDialog extends StatefulWidget {
  final User? user;

  const UserFormDialog({Key? key, this.user}) : super(key: key);

  @override
  _UserFormDialogState createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  UserRole? _selectedRole;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _selectedRole = widget.user?.role;
    _isActive = widget.user?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            RoleSelectorDropdown(
              selectedRole: _selectedRole,
              onRoleChanged: (role) {
                setState(() {
                  _selectedRole = role;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value ?? true;
                    });
                  },
                ),
                Text('Active'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _selectedRole != null) {
              final user = User(
                id: widget.user?.id ?? UniqueKey().toString(),
                name: _nameController.text,
                email: _emailController.text,
                role: _selectedRole!,
                isActive: _isActive,
                createdAt: widget.user?.createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              );
              Navigator.pop(context, user);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
