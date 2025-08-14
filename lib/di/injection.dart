import 'package:clean_arch_app/data/datasources/remote/notification_api.dart';
import 'package:clean_arch_app/data/datasources/remote/purchase_order_api.dart';
import 'package:clean_arch_app/data/repositories_impl/notification_repository_impl.dart';
import 'package:clean_arch_app/data/repositories_impl/purchase_order_repository_impl.dart';
import 'package:clean_arch_app/data/repositories_impl/supplier_repository_impl.dart';
import 'package:clean_arch_app/domain/repositories/notification_repository.dart';
import 'package:clean_arch_app/domain/repositories/purchase_order_repository.dart';
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/create_supplier_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/delete_supplier_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/get_active_suppliers.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/get_all_suppliers_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/get_supplier_by_id_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/search_suppliers_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/supplier_usecases.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/update_supplier_usecase.dart';
import 'package:clean_arch_app/domain/usecases/general/notification/notification_usecases.dart';
import 'package:clean_arch_app/domain/usecases/order/approve_purchase_order_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/cancel_purchase_order_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/create_purchase_order_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/delete_purchase_order_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/filter_purchase_orders_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/get_all_purchase_orders_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/get_purchase_order_by_id_usecase.dart';
import 'package:clean_arch_app/domain/usecases/order/purchase_order_usecases.dart';
import 'package:clean_arch_app/domain/usecases/order/update_purchase_order_usecase.dart';
import 'package:clean_arch_app/presentation/auth/auth_state.dart';
import 'package:clean_arch_app/presentation/auth/auth_view_model.dart';
import 'package:clean_arch_app/presentation/notification/notification_state.dart';
import 'package:clean_arch_app/presentation/notification/notification_view_model.dart';
import 'package:clean_arch_app/presentation/purchase_order/purchase_order_view_model.dart';
import 'package:clean_arch_app/presentation/suppliers/supplier_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
// Data Sources
import '../data/datasources/remote/auth_api.dart';
import '../data/datasources/remote/stock_api.dart';
import '../data/datasources/remote/supplier_api.dart';
import '../data/datasources/remote/user_api.dart';
// Repository Implementations
import '../data/repositories_impl/auth_repository_impl.dart';
import '../data/repositories_impl/stock_repository_impl.dart';
import '../data/repositories_impl/user_repository_impl.dart';
// Repositories (Interfaces)
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/stock_repository.dart';
import '../domain/repositories/stock_take_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/login_user.dart';
// ViewModels
import '../domain/usecases/stock/add_stock_usecase.dart';
import '../domain/usecases/stock/adjust_stock_usecase.dart';
import '../domain/usecases/stock/delete_multiple_stocks_usecase.dart';
import '../domain/usecases/stock/delete_stock_usecase.dart';
import '../domain/usecases/stock/filter_stocks_usecase.dart';
import '../domain/usecases/stock/get_all_stocks_usecase.dart';
import '../domain/usecases/stock/get_stock_by_id_usecase.dart';
import '../domain/usecases/stock/search_stocks_usecase.dart';
import '../domain/usecases/stock/sort_stocks_usecase.dart';
import '../domain/usecases/stock/stock_usecases.dart';
import '../domain/usecases/stock/toggle_stock_selection_usecase.dart';
import '../domain/usecases/stock/update_multiple_stock_status.dart';
import '../domain/usecases/stock/update_stock_status_usecase.dart';
import '../domain/usecases/stock/update_stock_usecase.dart';
import '../presentation/auth/login_view_model.dart';
import '../presentation/dashboard/dashboard_state.dart';
import '../presentation/dashboard/dashboard_view_model.dart';
import '../presentation/purchase_order/purchase_order_state.dart' show PurchaseOrderState;
import '../presentation/stock/stock_state.dart';
import '../presentation/stock/stock_view_model.dart';
import '../presentation/stocktake/stocktake_view_model.dart';
import '../presentation/suppliers/supplier_view_model.dart';

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
// Provide the generated Retrofit API
final notificationApiProvider = Provider<NotificationApi>((ref) {
  final dio = ref.read(dioProvider);
  return NotificationApi(dio, baseUrl: dio.options.baseUrl);
});
final purchaseOrderApiProvider = Provider<PurchaseOrderApi>((ref) {
  final dio = ref.read(dioProvider);
  return PurchaseOrderApi(dio);
});

// Provide the concrete repository implementation
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final api = ref.read(notificationApiProvider);
  return NotificationRepositoryImpl(api);
});

// ---------- usecases provider ----------
final notificationUseCasesProvider = Provider<NotificationUseCases>((ref) {
  final repo = ref.read(notificationRepositoryProvider);
  return NotificationUseCases.fromRepository(repo);
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

final purchaseOrderRepositoryProvider = Provider<PurchaseOrderRepository>((ref) {
  final api = ref.read(purchaseOrderApiProvider);
  return PurchaseOrderRepositoryImpl(api);
});

final purchaseOrderUseCasesProvider = Provider((ref) {
  final purchaseRepo = ref.watch(purchaseOrderRepositoryProvider);
  return PurchaseOrderUseCases(
    createPurchaseOrder: CreatePurchaseOrderUseCase(purchaseRepo),
    updatePurchaseOrder: UpdatePurchaseOrderUseCase(purchaseRepo),
    deletePurchaseOrder: DeletePurchaseOrderUseCase(purchaseRepo),
    getPurchaseOrderById: GetPurchaseOrderByIdUseCase(purchaseRepo),
    getAllPurchaseOrders: GetAllPurchaseOrdersUseCase(purchaseRepo),
    approvePurchaseOrder: ApprovePurchaseOrderUseCase(purchaseRepo),
    cancelPurchaseOrder: CancelPurchaseOrderUseCase(purchaseRepo),
    filterPurchaseOrders: FilterPurchaseOrdersUseCase(purchaseRepo),
  );
});


final purchaseOrderViewModelProvider =
    StateNotifierProvider<PurchaseOrderViewModel, PurchaseOrderState>((ref) {
      final PurchasUseCases = ref.watch(purchaseOrderUseCasesProvider);
      final authRepo = ref.watch(authRepositoryProvider);
      return PurchaseOrderViewModel(
        purchaseOrderUseCases: PurchasUseCases,
        authRepository: authRepo,
      );
    });
//
// final stockViewModelProvider =
//     StateNotifierProvider.autoDispose<StockViewModel, StockState>((ref) {
//       final stockRepo = ref.watch(stockRepositoryProvider);
//       final authRepo = ref.watch(authRepositoryProvider);
//       return StockViewModel(
//         stockRepository: stockRepo,
//         authRepository: authRepo,
//       );
//     });

final notificationViewModelProvider =
StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  final usecases = ref.read(notificationUseCasesProvider);
  return NotificationViewModel(notificationUseCases: usecases);
});

final stockUsecasesProvider = Provider((ref) {
  final stockRepo = ref.watch(stockRepositoryProvider);
  return StockUseCases(
    addStock: AddStockUseCase(stockRepo),
    adjustStock: AdjustStockUseCase(stockRepo),
    deleteMultipleStocks: DeleteMultipleStocksUseCase(stockRepo),
    deleteStock: DeleteStockUseCase(stockRepo),
    filterStocks: FilterStocksUseCase(),
    getAllStocks: GetAllStocksUseCase(stockRepo),
    getStockById: GetStockByIdUseCase(stockRepo),
    searchStocks: SearchStocksUseCase(),
    sortStocks: SortStocksUseCase(),
    toggleStockSelection: ToggleStockSelectionUseCase(),
    updateMultipleStockStatus:
        UpdateMultipleStockStatusUseCase(stockRepo),
    updateStockStatus: UpdateStockStatusUseCase(stockRepo),
    updateStock: UpdateStockUseCase(stockRepo),
  );
});
final stockViewModelProvider =
StateNotifierProvider.autoDispose<StockViewModel, StockState>((ref) {
  final stockUseCases =ref.watch(stockUsecasesProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return StockViewModel(
    stockUseCases: stockUseCases,
    authRepository: authRepo,
  );
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


final supplierApiProvider = Provider<SupplierApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SupplierApiImpl(apiClient);
});

// ─────────────────────────────────────────────
// SUPPLIER REPOSITORY PROVIDER
// ─────────────────────────────────────────────

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  final api = ref.watch(supplierApiProvider);
  return SupplierRepositoryImpl(api);
});

// ─────────────────────────────────────────────
// SUPPLIER USECASES PROVIDER
// ─────────────────────────────────────────────

final supplierUseCasesProvider = Provider<SupplierUseCases>((ref) {
  final repo = ref.watch(supplierRepositoryProvider);
  return SupplierUseCases(
    getAllSuppliers: GetAllSuppliersUseCase(repo),
    getSupplierById: GetSupplierByIdUseCase(repo),
    createSupplier: CreateSupplierUseCase(repo),
    updateSupplier: UpdateSupplierUseCase(repo),
    deleteSupplier: DeleteSupplierUseCase(repo),
    searchSuppliers: SearchSuppliersUseCase(repo),
    getActiveSuppliers: GetActiveSuppliersUseCase(repo),
  );
});

// ─────────────────────────────────────────────
// SUPPLIER VIEWMODEL PROVIDER
// ─────────────────────────────────────────────

final supplierViewModelProvider =
StateNotifierProvider<SupplierViewModel, SupplierState>((ref) {
  final usecases = ref.watch(supplierUseCasesProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return SupplierViewModel(
    useCases: usecases,
    // authRepository: authRepo, useCases: null,
  );
});