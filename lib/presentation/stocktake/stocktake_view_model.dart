import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/stock/stock_take.dart';
import '../../domain/repositories/stock_take_repository.dart';

class StockTakeState {
  final bool isLoading;
  final String? error;
  final List<StockTake> stockTakes;
  final StockTake? currentSession;
  final List<StockTakeItem> items;
  final List<StockTakeItem> filteredItems;
  final String searchQuery;
  final bool showCountedOnly;
  final bool showDiscrepanciesOnly;
  final CountMethod? filterByCountMethod;

  StockTakeState({
    this.isLoading = false,
    this.error,
    this.stockTakes = const [],
    this.currentSession,
    this.items = const [],
    this.filteredItems = const [],
    this.searchQuery = '',
    this.showCountedOnly = false,
    this.showDiscrepanciesOnly = false,
    this.filterByCountMethod,
  });

  StockTakeState copyWith({
    bool? isLoading,
    String? error,
    List<StockTake>? stockTakes,
    StockTake? currentSession,
    List<StockTakeItem>? items,
    List<StockTakeItem>? filteredItems,
    String? searchQuery,
    bool? showCountedOnly,
    bool? showDiscrepanciesOnly,
    CountMethod? filterByCountMethod,
  }) {
    return StockTakeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stockTakes: stockTakes ?? this.stockTakes,
      currentSession: currentSession ?? this.currentSession,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      showCountedOnly: showCountedOnly ?? this.showCountedOnly,
      showDiscrepanciesOnly:
          showDiscrepanciesOnly ?? this.showDiscrepanciesOnly,
      filterByCountMethod: filterByCountMethod ?? this.filterByCountMethod,
    );
  }
}

class StockTakeViewModel extends StateNotifier<StockTakeState> {
  final StockTakeRepository repository;
  final ImagePicker _imagePicker = ImagePicker();

  StockTakeViewModel(this.repository) : super(StockTakeState()) {
    loadStockTakes();
  }

  // Load all stock takes
  Future<void> loadStockTakes() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getAllStockTakes();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (stockTakes) =>
          state = state.copyWith(isLoading: false, stockTakes: stockTakes),
    );
  }

  // Start a new stock take session
  Future<void> startNewSession({
    required String name,
    String? description,
    String? locationId,
    List<String>? categoryFilters,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.createStockTake(
      name: name,
      description: description,
      locationId: locationId,
      categoryFilters: categoryFilters,
    );

    await result.fold(
      (failure) async =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (newSession) async {
        state = state.copyWith(
          isLoading: false,
          currentSession: newSession,
          stockTakes: [...state.stockTakes, newSession],
        );
        await loadSessionItems(newSession.id);
      },
    );
  }

  // Load items for current session
  Future<void> loadSessionItems(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getStockTakeItems(sessionId);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (items) {
        state = state.copyWith(
          isLoading: false,
          items: items,
          filteredItems: items,
        );
        _applyFilters();
      },
    );
  }

  // Resume a paused session
  Future<void> resumeSession(String sessionId) async {
    final session = state.stockTakes.firstWhere((s) => s.id == sessionId);

    if (session.status != StockTakeStatus.paused) {
      state = state.copyWith(error: 'Session is not paused');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement API call to resume session
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, currentSession: session);

      await loadSessionItems(sessionId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Pause current session
  Future<void> pauseSession() async {
    if (state.currentSession == null) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.updateStockTakeStatus(
      id: state.currentSession!.id,
      status: StockTakeStatus.paused,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (updatedSession) {
        state = state.copyWith(
          isLoading: false,
          currentSession: null,
          stockTakes: state.stockTakes
              .map((s) => s.id == updatedSession.id ? updatedSession : s)
              .toList(),
        );
      },
    );
  }

  // Complete current session
  Future<void> completeSession() async {
    if (state.currentSession == null) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.updateStockTakeStatus(
      id: state.currentSession!.id,
      status: StockTakeStatus.completed,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (updatedSession) {
        state = state.copyWith(
          isLoading: false,
          currentSession: null,
          stockTakes: state.stockTakes
              .map((s) => s.id == updatedSession.id ? updatedSession : s)
              .toList(),
        );
      },
    );
  }

  // Update item count manually
  Future<void> updateItemCount({
    required String itemId,
    required int count,
    String? notes,
  }) async {
    final itemIndex = state.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement API call to update count
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedItem = StockTakeItem(
        id: state.items[itemIndex].id,
        stockTakeId: state.items[itemIndex].stockTakeId,
        productId: state.items[itemIndex].productId,
        productName: state.items[itemIndex].productName,
        productCode: state.items[itemIndex].productCode,
        systemQuantity: state.items[itemIndex].systemQuantity,
        countedQuantity: count,
        countMethod: CountMethod.manual,
        countedBy: 'current_user',
        // TODO: Get from auth
        countedAt: DateTime.now(),
        notes: notes,
        photoUrls: state.items[itemIndex].photoUrls,
      );

      final updatedItems = [...state.items];
      updatedItems[itemIndex] = updatedItem;

      state = state.copyWith(isLoading: false, items: updatedItems);

      _applyFilters();
      _updateSessionProgress();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Update item count by barcode
  Future<void> updateItemByBarcode({
    required String barcode,
    required int count,
  }) async {
    // Find item by barcode (product code)
    final itemIndex = state.items.indexWhere(
      (item) => item.productCode == barcode,
    );

    if (itemIndex == -1) {
      state = state.copyWith(error: 'Product not found: $barcode');
      return;
    }

    final item = state.items[itemIndex];

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement API call to update count
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedItem = StockTakeItem(
        id: item.id,
        stockTakeId: item.stockTakeId,
        productId: item.productId,
        productName: item.productName,
        productCode: item.productCode,
        systemQuantity: item.systemQuantity,
        countedQuantity: count,
        countMethod: CountMethod.barcode,
        countedBy: 'current_user',
        // TODO: Get from auth
        countedAt: DateTime.now(),
        notes: item.notes,
        photoUrls: item.photoUrls,
      );

      final updatedItems = [...state.items];
      updatedItems[itemIndex] = updatedItem;

      state = state.copyWith(isLoading: false, items: updatedItems);

      _applyFilters();
      _updateSessionProgress();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Update item count with photo
  Future<void> updateItemWithPhoto({
    required String itemId,
    required int count,
    required XFile photo,
    String? notes,
  }) async {
    final itemIndex = state.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Upload photo and get URL
      await Future.delayed(const Duration(seconds: 1));
      final photoUrl =
          'https://example.com/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final item = state.items[itemIndex];
      final updatedItem = StockTakeItem(
        id: item.id,
        stockTakeId: item.stockTakeId,
        productId: item.productId,
        productName: item.productName,
        productCode: item.productCode,
        systemQuantity: item.systemQuantity,
        countedQuantity: count,
        countMethod: CountMethod.photo,
        countedBy: 'current_user',
        // TODO: Get from auth
        countedAt: DateTime.now(),
        notes: notes,
        photoUrls: [...(item.photoUrls ?? []), photoUrl],
      );

      final updatedItems = [...state.items];
      updatedItems[itemIndex] = updatedItem;

      state = state.copyWith(isLoading: false, items: updatedItems);

      _applyFilters();
      _updateSessionProgress();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Search functionality
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  // Filter toggles
  void toggleShowCountedOnly() {
    state = state.copyWith(showCountedOnly: !state.showCountedOnly);
    _applyFilters();
  }

  void toggleShowDiscrepanciesOnly() {
    state = state.copyWith(showDiscrepanciesOnly: !state.showDiscrepanciesOnly);
    _applyFilters();
  }

  void setCountMethodFilter(CountMethod? method) {
    state = state.copyWith(filterByCountMethod: method);
    _applyFilters();
  }

  // Apply filters to items
  void _applyFilters() {
    var filtered = state.items;

    // Search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (item) =>
                item.productName.toLowerCase().contains(query) ||
                item.productCode.toLowerCase().contains(query),
          )
          .toList();
    }

    // Counted only filter
    if (state.showCountedOnly) {
      filtered = filtered.where((item) => item.isCounted).toList();
    }

    // Discrepancies only filter
    if (state.showDiscrepanciesOnly) {
      filtered = filtered.where((item) => item.hasDiscrepancy).toList();
    }

    // Count method filter
    if (state.filterByCountMethod != null) {
      filtered = filtered
          .where((item) => item.countMethod == state.filterByCountMethod)
          .toList();
    }

    state = state.copyWith(filteredItems: filtered);
  }

  // Update session progress
  void _updateSessionProgress() {
    if (state.currentSession == null) return;

    final countedItems = state.items.where((item) => item.isCounted).length;
    final discrepancies = state.items
        .where((item) => item.hasDiscrepancy)
        .length;

    final updatedSession = StockTake(
      id: state.currentSession!.id,
      name: state.currentSession!.name,
      description: state.currentSession!.description,
      startDate: state.currentSession!.startDate,
      status: state.currentSession!.status,
      createdBy: state.currentSession!.createdBy,
      assignedTo: state.currentSession!.assignedTo,
      locationId: state.currentSession!.locationId,
      categoryFilters: state.currentSession!.categoryFilters,
      totalItems: state.items.length,
      countedItems: countedItems,
      discrepancies: discrepancies,
      createdAt: state.currentSession!.createdAt,
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(currentSession: updatedSession);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Generate discrepancy report
  Future<Map<String, dynamic>> generateDiscrepancyReport() async {
    final discrepancyItems = state.items
        .where((item) => item.hasDiscrepancy)
        .toList();

    final totalDiscrepancyValue = discrepancyItems.fold<double>(
      0,
      (sum, item) => sum + (item.discrepancy * 10), // TODO: Get actual price
    );

    return {
      'sessionId': state.currentSession?.id,
      'sessionName': state.currentSession?.name,
      'totalItems': state.items.length,
      'countedItems': state.items.where((item) => item.isCounted).length,
      'discrepancyCount': discrepancyItems.length,
      'totalDiscrepancyValue': totalDiscrepancyValue,
      'discrepancyItems': discrepancyItems
          .map(
            (item) => {
              'productId': item.productId,
              'productName': item.productName,
              'productCode': item.productCode,
              'systemQuantity': item.systemQuantity,
              'countedQuantity': item.countedQuantity,
              'discrepancy': item.discrepancy,
              'countMethod': item.countMethod?.toString(),
              'countedBy': item.countedBy,
              'countedAt': item.countedAt?.toIso8601String(),
              'notes': item.notes,
            },
          )
          .toList(),
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }
}

// Provider for repository
final stockTakeRepositoryProvider = Provider<StockTakeRepository>((ref) {
  throw UnimplementedError('Stock take repository provider must be overridden');
});

// Provider definition
final stockTakeViewModelProvider =
    StateNotifierProvider<StockTakeViewModel, StockTakeState>((ref) {
      final repository = ref.watch(stockTakeRepositoryProvider);
      return StockTakeViewModel(repository);
    });
