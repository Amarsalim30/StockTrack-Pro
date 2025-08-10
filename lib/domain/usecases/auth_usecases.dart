import 'package:clean_arch_app/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:clean_arch_app/domain/usecases/auth/login_usecase.dart';
import 'package:clean_arch_app/domain/usecases/auth/logout_usecase.dart';
import 'package:clean_arch_app/domain/usecases/auth/refresh_token_usecase.dart';
import 'package:clean_arch_app/domain/usecases/auth/register_usecase.dart';

class AuthUseCases {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;

  AuthUseCases({
    required this.getCurrentUserUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.refreshTokenUseCase,
  });
}
