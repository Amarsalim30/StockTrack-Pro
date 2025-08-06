import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/login_user.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final User? user;

  LoginState({this.isLoading = false, this.error, this.user});

  LoginState copyWith({bool? isLoading, String? error, User? user}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUser _loginUser;

  LoginViewModel(this._loginUser) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUser(email, password);

    result.fold(
      (exception) {
        state = state.copyWith(isLoading: false, error: exception.toString());
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider definition would go in injection.dart
// final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
//   final loginUser = ref.watch(loginUserProvider);
//   return LoginViewModel(loginUser);
// });
