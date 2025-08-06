import 'package:clean_arch_app/di/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth/user.dart';
import '../../data/models/auth/user_model.dart';
import '../../domain/repositories/user_repository.dart';

// 📦 State class
class UserState {
  final List<UserModel> users;
  final bool isLoading;
  final String? error;

  const UserState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// 🚀 ViewModel
class UserViewModel extends StateNotifier<UserState> {
  final UserRepository _userRepository;

  UserViewModel({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState());

  // 🔁 Fetch from backend
  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _userRepository.getAllUsers();
      result.fold(
            (failure) {
          state = state.copyWith(error: failure.toString(), isLoading: false);
        },
            (users) {
          final mapped = users.map(UserModel.fromEntity).toList();
          state = state.copyWith(users: mapped, isLoading: false);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch users: ${e.toString()}',
      );
    }
  }

  void addUser(UserModel user) {
    state = state.copyWith(users: [...state.users, user]);
  }

  void updateUser(User user) {
    UserModel updatedUser = UserModel.fromEntity(user);
    final index = state.users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      final updatedUsers = [...state.users];
      updatedUsers[index] = updatedUser;
      state = state.copyWith(users: updatedUsers);
    }
  }

  void deleteUser(String id) {
    final updated = state.users.where((u) => u.id != id).toList();
    state = state.copyWith(users: updated);
  }

  void toggleUserActivation(String id) {
    final index = state.users.indexWhere((user) => user.id == id);
    if (index != -1) {
      final user = state.users[index];
      final updatedUser = user.copyWith(
        isActive: !user.isActive,
        updatedAt: DateTime.now(),
      );
      final updatedUsers = [...state.users];
      updatedUsers[index] = updatedUser;
      state = state.copyWith(users: updatedUsers);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 🧠 Riverpod Provider
final userViewModelProvider =
StateNotifierProvider<UserViewModel, UserState>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return UserViewModel(userRepository: userRepo);
});
