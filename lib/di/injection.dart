import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocktrack_pro/core/network/network_info.dart';
import 'package:stocktrack_pro/data/datasources/remote/notification_api.dart';
import 'package:stocktrack_pro/data/datasources/remote/catalog/product_firebase_data_source.dart';
import 'package:stocktrack_pro/data/datasources/remote/purchase_order_api.dart';
import 'package:stocktrack_pro/data/datasources/remote/stock_take_api.dart';
import 'package:stocktrack_pro/data/repositories_impl/notification_repository_impl.dart';
import 'package:stocktrack_pro/data/repositories_impl/purchase_order_repository_impl.dart';
import 'package:stocktrack_pro/data/repositories_impl/stock_take_repository_impl.dart';
import 'package:stocktrack_pro/data/repositories_impl/supplier_repository_impl.dart';
import 'package:stocktrack_pro/domain/repositories/notification_repository.dart';
import 'package:stocktrack_pro/domain/repositories/purchase_order_repository.dart';
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/product/product_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/product/product_usecases.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/create_supplier_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/delete_supplier_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/get_active_suppliers.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/get_all_suppliers_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/get_supplier_by_id_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/search_suppliers_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/supplier_usecases.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/supplier/update_supplier_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/general/notification/notification_usecases.dart';
import 'package:stocktrack_pro/domain/usecases/order/approve_purchase_order_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/cancel_purchase_order_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/create_purchase_order_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/delete_purchase_order_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/filter_purchase_orders_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/get_all_purchase_orders_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/get_purchase_order_by_id_usecase.dart';
import 'package:stocktrack_pro/domain/usecases/order/purchase_order_usecases.dart';
import 'package:stocktrack_pro/domain/usecases/order/update_purchase_order_usecase.dart';
import 'package:stocktrack_pro/presentation/auth/auth_state.dart';
import 'package:stocktrack_pro/presentation/auth/auth_view_model.dart';
import 'package:stocktrack_pro/presentation/catalog/product/product_state.dart';
import 'package:stocktrack_pro/presentation/catalog/product/product_view_model.dart';
import 'package:stocktrack_pro/presentation/notification/notification_state.dart';
import 'package:stocktrack_pro/presentation/notification/notification_view_model.dart';
import 'package:stocktrack_pro/presentation/purchase_order/purchase_order_view_model.dart';
import 'package:stocktrack_pro/presentation/stocktake/stock_state.dart';
import 'package:stocktrack_pro/presentation/suppliers/supplier_state.dart';
import 'package:stocktrack_pro/data/datasources/remote/category_api.dart';
import 'package:stocktrack_pro/data/datasources/remote/unit_api.dart';
import 'package:stocktrack_pro/data/repositories_impl/category_repository_impl.dart';
import 'package:stocktrack_pro/data/repositories_impl/unit_repository_impl.dart';
import 'package:stocktrack_pro/domain/repositories/category_repository.dart';
import 'package:stocktrack_pro/domain/repositories/unit_repository.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/category/category_usecases.dart';
import 'package:stocktrack_pro/domain/usecases/general/unit/unit_usecases.dart';
import 'package:stocktrack_pro/presentation/catalog/category/category_state.dart';
import 'package:stocktrack_pro/presentation/catalog/category/category_view_model.dart';
import 'package:stocktrack_pro/presentation/catalog/unit/unit_state.dart';
import 'package:stocktrack_pro/presentation/catalog/unit/unit_view_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import '../data/repositories_impl/catalog/product_repository_impl.dart';
import '../data/repositories_impl/stock_repository_impl.dart';
import '../data/repositories_impl/user_repository_impl.dart';

// Repositories (Interfaces)
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/product_repository.dart' show ProductRepository;
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
import '../presentation/purchase_order/purchase_order_state.dart'
    show PurchaseOrderState;
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
// Provider for Connectivity
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.read(connectivityProvider));
});
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

final stockTakeApiProvider = Provider<StockTakeApi>((ref) {
  final dio = ref.watch(dioProvider);
  return StockTakeApi(dio); // assuming you have a Retrofit/Dio StockTakeApi
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

final purchaseOrderRepositoryProvider = Provider<PurchaseOrderRepository>((
    ref) {
  final api = ref.watch(purchaseOrderApiProvider);
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
  final purchaseUseCases = ref.watch(purchaseOrderUseCasesProvider);
  // final authRepo = ref.watch(authRepositoryProvider);
  return PurchaseOrderViewModel(
    purchaseOrderUseCases: purchaseUseCases,
    authRepository: ref.watch(authRepositoryProvider),
  );
});

final notificationViewModelProvider =
StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  final usecases = ref.read(notificationUseCasesProvider);
  return NotificationViewModel(notificationUseCases: usecases);
});

// Firebase Data Source Provider
final productFirebaseDataSourceProvider = Provider<ProductFirebaseDataSource>((ref) {
  return ProductFirebaseDataSourceImpl(FirebaseFirestore.instance);
});

// Repository Provider using Firebase
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final firebaseDataSource = ref.watch(productFirebaseDataSourceProvider);
  return ProductRepositoryImpl(firebaseDataSource);
});

// Use Cases Provider
final productUsecasesProvider = Provider<ProductUseCases>((ref) {
  final productRepo = ref.watch(productRepositoryProvider);
  return ProductUseCases(
    getAll: GetAllProductsUseCase(productRepo),
    getById: GetProductByIdUseCase(productRepo),
    create: CreateProductUseCase(productRepo),
    update: UpdateProductUseCase(productRepo),
    delete: DeleteProductUseCase(productRepo),
    search: SearchProductsUseCase(productRepo),
    getByCategory: GetProductsByCategoryUseCase(productRepo),
    getBySupplier: GetProductsBySupplierUseCase(productRepo),
    getByUnit: GetProductsByUnitUseCase(productRepo),
    getByPriceRange: GetProductsByPriceRangeUseCase(productRepo),
    getActive: GetActiveProductsUseCase(productRepo),
    getInactive: GetInactiveProductsUseCase(productRepo),
    getLowStock: GetLowStockProductsUseCase(productRepo),
    getOutOfStock: GetOutOfStockProductsUseCase(productRepo),
    isSkuExists: IsSkuExistsUseCase(productRepo),
    createMultiple: CreateMultipleProductsUseCase(productRepo),
    deleteMultiple: DeleteMultipleProductsUseCase(productRepo),
  );
});

final productViewModelProvider =
StateNotifierProvider<ProductViewModel, ProductState>((ref) {
  final usecases = ref.read(productUsecasesProvider);
  return ProductViewModel(usecases);
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
    final stockUseCases = ref.watch(stockUsecasesProvider);
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


  final stockTakeRepositoryProvider = Provider<StockTakeRepository>((ref) {
    final api = ref.watch(stockTakeApiProvider);
    final networkInfo = ref.watch(networkInfoProvider);
    return StockTakeRepositoryImpl(stockTakeApi: api, networkInfo: networkInfo);
    // you probably want to pass real NetworkInfo instead of null
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

final categoryApiProvider = Provider<CategoryApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryApi(dio);
});

final unitApiProvider = Provider<UnitApi>((ref) {
  final dio = ref.watch(dioProvider);
  return UnitApi(dio);
});

// ─────────────────────────────────────────────
// CATALOG REPOSITORY PROVIDERS
// ─────────────────────────────────────────────

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  final api = ref.watch(supplierApiProvider);
  return SupplierRepositoryImpl(api);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final api = ref.watch(categoryApiProvider);
  return CategoryRepositoryImpl(api);
});

final unitRepositoryProvider = Provider<UnitRepository>((ref) {
  final api = ref.watch(unitApiProvider);
  return UnitRepositoryImpl(api);
});

// ─────────────────────────────────────────────
// CATALOG USECASES PROVIDERS
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

final categoryUseCasesProvider = Provider<CategoryUseCases>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return CategoryUseCases.fromRepository(repo);
});

final unitUseCasesProvider = Provider<UnitUseCases>((ref) {
  final repo = ref.watch(unitRepositoryProvider);
  return UnitUseCases.fromRepository(repo);
});

// ─────────────────────────────────────────────
// CATALOG VIEWMODEL PROVIDERS
// ─────────────────────────────────────────────

final supplierViewModelProvider =
StateNotifierProvider<SupplierViewModel, SupplierState>((ref) {
  final usecases = ref.watch(supplierUseCasesProvider);
  return SupplierViewModel(useCases: usecases);
});

final categoryViewModelProvider =
StateNotifierProvider<CategoryViewModel, CategoryState>((ref) {
  final usecases = ref.watch(categoryUseCasesProvider);
  return CategoryViewModel(usecases);
});

final unitViewModelProvider =
StateNotifierProvider<UnitViewModel, UnitState>((ref) {
  final usecases = ref.watch(unitUseCasesProvider);
  return UnitViewModel(usecases);
});