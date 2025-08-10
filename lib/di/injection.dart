import 'package:clean_arch_app/presentation/auth/auth_state.dart';
import 'package:clean_arch_app/presentation/auth/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

// Data Sources
import '../data/datasources/remote/auth_api.dart';
import '../data/datasources/remote/user_api.dart';
import '../data/datasources/remote/stock_api.dart';

// Repositories (Interfaces)
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/stock_repository.dart';
import '../domain/repositories/stock_take_repository.dart';

// Repository Implementations
import '../data/repositories_impl/auth_repository_impl.dart';
import '../data/repositories_impl/user_repository_impl.dart';
import '../data/repositories_impl/stock_repository_impl.dart';

// ViewModels
import '../presentation/dashboard/dashboard_state.dart';
import '../presentation/dashboard/dashboard_view_model.dart';
import '../presentation/stock/viewModels/stock_state.dart';
import '../presentation/stock/viewModels/stock_view_model.dart';
import '../presentation/suppliers/supplier_view_model.dart';
import '../presentation/auth/login_view_model.dart';
import '../presentation/stocktake/stocktake_view_model.dart';
import '../domain/usecases/login_user.dart';

// ─────────────────────────────────────────────
// NETWORK PROVIDERS
// ─────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) => ApiClient().dio);

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
});

// ─────────────────────────────────────────────
// DATA SOURCE PROVIDERS
// ─────────────────────────────────────────────

final authApiProvider = Provider<AuthApiImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApiImpl(apiClient);
});

final userApiProvider = Provider<UserApi>((ref) {
  final dio = ref.watch(dioProvider);
  return UserApi(dio);
});

final stockRemoteDataSourceProvider = Provider<StockApi>((ref) {
  final dio = ref.watch(dioProvider);
  return StockApi(dio);
});

// ─────────────────────────────────────────────
// REPOSITORY PROVIDERS
// ─────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(authApiProvider);
  return AuthRepositoryImpl(api);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(userApiProvider);
  return UserRepositoryImpl(api);
});

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  final remoteSource = ref.watch(stockRemoteDataSourceProvider);
  return StockRepositoryImpl(remoteSource);
});

// ─────────────────────────────────────────────
// VIEWMODEL PROVIDERS
// ─────────────────────────────────────────────

final dashboardViewModelProvider =
StateNotifierProvider<DashboardViewModel, DashboardState>(
      (ref) => DashboardViewModel(),
);

final stockViewModelProvider =
StateNotifierProvider.autoDispose<StockViewModel, StockState>((ref) {
  final stockRepo = ref.watch(stockRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return StockViewModel(

  );

});

final supplierViewModelProvider = Provider<SupplierViewModel>((ref) {
  return SupplierViewModel();
});

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final loginUseCase = LoginUser(ref.watch(authRepositoryProvider));
  return LoginViewModel(loginUseCase);
});

final authViewModelProvider =
StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});


// Mock stock take repository for now
final stockTakeRepositoryProvider = Provider<StockTakeRepository>((ref) {
  throw UnimplementedError('StockTakeRepository implementation needed');
});


// Provider definition
final stockTakeViewModelProvider =
StateNotifierProvider<StockTakeViewModel, StockTakeState>((ref) {
  final repository = ref.watch(stockTakeRepositoryProvider);
  return StockTakeViewModel(repository);
});

