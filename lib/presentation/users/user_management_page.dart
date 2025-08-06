import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth/user.dart';
import 'user_view_model.dart';
import 'widgets/user_item_card.dart';
import 'widgets/user_form_dialog.dart';

class UserManagementPage extends ConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);
    final userViewModel = ref.watch(userViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newUser = await showDialog(
                context: context,
                builder: (context) => UserFormDialog(),
              );
              if (newUser != null) {
                userViewModel.addUser(newUser);
              }
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (userState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userState.error != null) {
            return Center(child: Text('Error: ${userState.error}'));
          } else {
            final users = userState.users;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserItemCard(
                    user: users[index],
                    userViewModel: userViewModel,
                  );
                }
            );
          }
        },
      ),
    );
  }
}
