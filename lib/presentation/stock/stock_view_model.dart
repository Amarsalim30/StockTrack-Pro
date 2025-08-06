import 'package:clean_arch_app/di/injection.dart';
import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/presentation/stock/mock_stock_data.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../core/enums/stock_status.dart';
import '../../data/models/stock/stock_model.dart';
import '../../data/models/auth/user_model.dart';
import '../../domain/entities/auth/permission_type.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/repositories/auth_repository.dart';

class StockViewModel extends StateNotifier<StockState> {
  final StockRepository _stockRepository;
  final AuthRepository _authRepository;

  // Getters
  List<Stock> get stocks => state.filteredStocks;

  Set<String> get selectedStockIds => state.selectedStockIds;

  bool get isLoading => state.isLoading;

  bool get isBulkSelectionMode => state.isBulkSelectionMode;

  String get searchQuery => state.searchQuery;

  StockStatus? get filterStatus => state.filterStatus;

  SortBy get sortBy => state.sortBy;

  SortOrder get sortOrder => state.sortOrder;

  String? get error => state.errorMessage;

  bool get hasSelectedItems => state.selectedStockIds.isNotEmpty;

  int get selectedCount => state.selectedStockIds.length;

  User? get currentUser => state.currentUser;

  StockViewModel({
    required StockRepository stockRepository,
    required AuthRepository authRepository,
  }) : _stockRepository = stockRepository,
       _authRepository = authRepository,
        super(StockState(stocks: mockStocks)) {
    // _loadCurrentUser();
    loadStocks();
  }

  // Permission checks
  bool hasPermission(PermissionType permission) {
    return state.currentUser?.hasPermission(permission) ?? false;
  }

  bool get canCreateStock => hasPermission(PermissionType.createProduct);

  bool get canEditStock => hasPermission(PermissionType.editProduct);

  bool get canDeleteStock => hasPermission(PermissionType.deleteProduct);

  bool get canAdjustStock => hasPermission(PermissionType.adjustStock);

  bool get canViewStockReports => hasPermission(PermissionType.viewReports);

  // Load current user
  Future<void> _loadCurrentUser() async {
    try {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (failure) => print('Error loading current user: $failure'),
        (user) =>
        state = state.copyWith(currentUser: user),
      );
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  // Load stocks
  Future<void> loadStocks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _stockRepository.getStocks();
      final stocks = result.isEmpty ? mockStocks : result;

      state = state.copyWith(stocks: stocks);
      _applyFiltersAndSort();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  // Search functionality
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }

  // Filter functionality
  void setFilterStatus(StockStatus? status) {
    state = state.copyWith(filterStatus: status);
    _applyFiltersAndSort();
  }

  // Sort functionality
  void setSortBy(SortBy sortBy) {
    if (state.sortBy == sortBy) {
      state = state.copyWith(
        sortOrder: state.sortOrder == SortOrder.ascending
            ? SortOrder.descending
            : SortOrder.ascending,
      );
    } else {
      state = state.copyWith(sortBy: sortBy, sortOrder: SortOrder.ascending);
    }
    _applyFiltersAndSort();
  }

  // Apply filters and sort
  void _applyFiltersAndSort() {
    var filtered = [...state.stocks];

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered = filtered.where((stock) {
        return stock.name.toLowerCase().contains(q) ||
            stock.sku.toLowerCase().contains(q) ||
            (stock.description?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    if (state.filterStatus != null) {
      filtered = filtered
          .where((stock) => stock.status == state.filterStatus)
          .toList();
    }

    filtered.sort((a, b) {
      int cmp;
      switch (state.sortBy) {
        case SortBy.name:
          cmp = a.name.compareTo(b.name);
          break;
        case SortBy.sku:
          cmp = a.sku.compareTo(b.sku);
          break;
        case SortBy.quantity:
          cmp = a.quantity.compareTo(b.quantity);
          break;
        case SortBy.lastUpdated:
          cmp = a.updatedAt.compareTo(b.updatedAt);
          break;
      }
      return state.sortOrder == SortOrder.ascending ? cmp : -cmp;
    });

    state = state.copyWith(filteredStocks: filtered);
  }

  // Bulk selection
  void toggleBulkSelectionMode() {
    final newMode = !state.isBulkSelectionMode;
    if (!newMode) {
      state = state.copyWith(
        isBulkSelectionMode: newMode,
        selectedStockIds: {},
      );
    } else {
      state = state.copyWith(isBulkSelectionMode: newMode);
    }
  }

  void toggleSortOrder(SortBy selectedSortBy) {
    final isSameSort = state.sortBy == selectedSortBy;

    final newOrder = isSameSort
        ? (state.sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending)
        : SortOrder.ascending;

    final newSortBy = selectedSortBy;

    final sortedStocks = [...state.stocks]
      ..sort((a, b) {
        int result = 0;
        switch (newSortBy) {
          case SortBy.name:
            result = a.name.compareTo(b.name);
            break;
          case SortBy.sku:
            result = a.sku.compareTo(b.sku);
            break;
          case SortBy.quantity:
            result = a.quantity.compareTo(b.quantity);
            break;
          case SortBy.lastUpdated:
            result = a.updatedAt.compareTo(b.updatedAt);
            break;
        }

        return newOrder == SortOrder.ascending ? result : -result;
      });

    state = state.copyWith(
      stocks: sortedStocks,
      sortBy: newSortBy,
      sortOrder: newOrder,
    );
  }

  void toggleStockSelection(String stockId) {
    final newSet = Set<String>.from(state.selectedStockIds);
    if (newSet.contains(stockId)) {
      newSet.remove(stockId);
    } else {
      newSet.add(stockId);
    }
    state = state.copyWith(selectedStockIds: newSet);
  }

  void selectAll() {
    final allIds = state.filteredStocks.map((stock) => stock.id).toSet();
    state = state.copyWith(selectedStockIds: allIds);
  }

  void clearSelection() {
    state = state.copyWith(selectedStockIds: {});
  } // CRUD Operations
  Future<void> createStock(Stock stock) async {
    if (!canCreateStock) {
      state = state.copyWith(
        errorMessage: 'You do not have permission to create stock items',
      );
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _stockRepository.createStock(_stockToStockModel(stock));
      await loadStocks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> updateStock(Stock stock) async {
    if (!canEditStock) {
      state = state.copyWith(
        errorMessage: 'You do not have permission to edit stock items',
      );
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _stockRepository.updateStock(_stockToStockModel(stock));
      await loadStocks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteStock(String stockId) async {
    if (!canDeleteStock) {
      state = state.copyWith(
        errorMessage: 'You do not have permission to delete stock items',
      );
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _stockRepository.deleteStock(stockId);
      final updatedStocks = state.stocks
          .where((stock) => stock.id != stockId)
          .toList();
      final updatedSelectedIds = Set<String>.from(state.selectedStockIds)
        ..remove(stockId);
      state = state.copyWith(
        stocks: updatedStocks,
        selectedStockIds: updatedSelectedIds,
      );
      _applyFiltersAndSort();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> bulkDelete() async {
    if (!canDeleteStock) {
      state = state.copyWith(
        errorMessage: 'You do not have permission to delete stock items',
      );
      return;
    }

    if (state.selectedStockIds.isEmpty) return;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.wait(
        state.selectedStockIds.map((id) => _stockRepository.deleteStock(id)),
      );
      final updatedStocks = state.stocks
          .where((stock) => !state.selectedStockIds.contains(stock.id))
          .toList();
      state = state.copyWith(
        stocks: updatedStocks,
        selectedStockIds: {},
        isBulkSelectionMode: false,
      );
      _applyFiltersAndSort();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> adjustStock(
    String stockId,
    int adjustment,
    String reason,
  ) async {
    if (!canAdjustStock) {
      state = state.copyWith(
        errorMessage: 'You do not have permission to adjust stock quantities',
      );
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _stockRepository.adjustStock(stockId, adjustment, reason);
      await loadStocks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> bulkUpdateStatus(StockStatus status) async {
    if (!canEditStock) {
      state = state.copyWith(
        errorMessage: 'You do not have permission to edit stock items',
      );
      return;
    }

    if (state.selectedStockIds.isEmpty) return;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final selectedStocks = state.stocks
          .where((stock) => state.selectedStockIds.contains(stock.id))
          .toList();

      await Future.wait(
        selectedStocks.map(
          (stock) => _stockRepository.updateStock(
            _stockToStockModel(stock).copyWith(status: status),
          ),
        ),
      );

      await loadStocks();
      state = state.copyWith(selectedStockIds: {}, isBulkSelectionMode: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  } // Get stock by ID
  Stock? getStockById(String id) {
    return state.stocks.firstWhereOrNull((stock) => stock.id == id);
  }

  // Refresh
  Future<void> refresh() async {
    await loadStocks();
  }

  // Clear errorvoid clearError() {
  state

  =

  state.copyWith

  (

  errorMessage

      :

  null

  );
} // Helper method to convert Stock entity to StockModel

StockModel _stockToStockModel(Stock stock) {
  return StockModel(
    id: stock.id,
    name: stock.name,
    sku: stock.sku,
    quantity: stock.quantity,
    status: stock.status,
    durabilityType: stock.durabilityType,
    description: stock.description,
    categoryId: stock.categoryId,
    supplierId: stock.supplierId,
    unit: stock.unit,
    location: stock.location,
    minimumStock: stock.minimumStock,
    maximumStock: stock.maximumStock,
    averageDailyUsage: stock.averageDailyUsage,
    leadTimeDays: stock.leadTimeDays,
    safetyStock: stock.safetyStock,
    reorderPoint: stock.reorderPoint,
    preferredReorderQuantity: stock.preferredReorderQuantity,
    price: stock.price,
    costPrice: stock.costPrice,
    createdAt: stock.createdAt,
    updatedAt: stock.updatedAt,
    expiryDate: stock.expiryDate,
    lastSoldDate: stock.lastSoldDate,
    deadstockThreshold: stock.deadstockThreshold,
    warehouseStock: stock.warehouseStock,
    movementHistory: stock.movementHistory,
    tags: stock.tags,
  );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final stockViewModelProvider =
StateNotifierProvider.autoDispose<StockViewModel, StockState>((ref) {
  final stockRepo = ref.watch(stockRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return StockViewModel(
    stockRepository: stockRepo,
    authRepository: authRepo,
  );
});
