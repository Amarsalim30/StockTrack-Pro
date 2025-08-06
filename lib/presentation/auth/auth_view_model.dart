import 'package:clean_arch_app/domain/repositories/auth_repository.dart';
import 'package:clean_arch_app/presentation/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthViewModel(this._repo) : super(const AuthState());

  Future<void> initialize() async {
    final token = await _repo.loadToken();
    if (token == null) return;

    final userResult = await _repo.getCurrentUser();
    userResult.fold(
          (failure) {
        state = state.copyWith(error: failure.toString());
      },
          (user) {
        state = state.copyWith(
          currentUser: user,
          isAuthenticated: true,
          error: null,
        );
      },
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.login(email, password);
    result.fold(
          (failure) {
        state = state.copyWith(
          error: failure.toString(),
          isLoading: false,
        );
      },
          (user) {
        state = state.copyWith(
          currentUser: user,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  void logout() {
    _repo.clearToken();
    state = const AuthState();
  }
}
