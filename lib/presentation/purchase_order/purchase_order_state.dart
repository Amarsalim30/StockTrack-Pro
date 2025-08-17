// purchase_order_state.dart
import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:clean_arch_app/core/enums/purchase_order_status.dart';

enum PurchaseOrderSortBy { orderDate, deliveryDate, totalAmount }
enum PurchaseOrderSortOrder { ascending, descending }
enum PurchaseOrderStateStatus { initial, loading, success, error }

class PurchaseOrderState {
  final List<PurchaseOrder> purchaseOrders;
  final User? currentUser;

  final bool isLoading;
  final bool isBulkSelectionMode;
  final PurchaseOrderStateStatus status;
  final Set<String> selectedPurchaseOrderIds;
  final String searchQuery;
  final PurchaseOrderStatus? filterStatus;
  final PurchaseOrderSortBy sortBy;
  final PurchaseOrderSortOrder sortOrder;
  final String? errorMessage;

  const PurchaseOrderState({
    this.purchaseOrders = const [],
    this.currentUser,
    this.status = PurchaseOrderStateStatus.initial,
    this.selectedPurchaseOrderIds = const {},
    this.searchQuery = '',
    this.filterStatus,
    this.sortBy = PurchaseOrderSortBy.orderDate,
    this.sortOrder = PurchaseOrderSortOrder.descending,
    this.errorMessage,
    this.isLoading = false,
    this.isBulkSelectionMode = false,
  });

  factory PurchaseOrderState.initial() => const PurchaseOrderState();

  PurchaseOrderState copyWith({
    List<PurchaseOrder>? purchaseOrders,
    User? currentUser,
    PurchaseOrderStateStatus? status,
    Set<String>? selectedPurchaseOrderIds,
    String? searchQuery,
    PurchaseOrderStatus? filterStatus,
    PurchaseOrderSortBy? sortBy,
    PurchaseOrderSortOrder? sortOrder,
    String? errorMessage,
    bool? isLoading,
    bool? isBulkSelectionMode,
  }) {
    return PurchaseOrderState(
      purchaseOrders: purchaseOrders ?? this.purchaseOrders,
      currentUser: currentUser ?? this.currentUser,
      status: status ?? this.status,
      selectedPurchaseOrderIds: selectedPurchaseOrderIds ?? this.selectedPurchaseOrderIds,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isBulkSelectionMode: isBulkSelectionMode ?? this.isBulkSelectionMode,
    );
  }

  bool get hasSelection => selectedPurchaseOrderIds.isNotEmpty;
  int get selectedCount => selectedPurchaseOrderIds.length;
  bool get allSelected => purchaseOrders.isNotEmpty && selectedPurchaseOrderIds.length == purchaseOrders.length;

  List<PurchaseOrder> get filteredPurchaseOrders {
    var list = List<PurchaseOrder>.from(purchaseOrders);

    if (searchQuery.isNotEmpty) {
      list = list.where((order) =>
          order.id.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    if (filterStatus != null) {
      list = list.where((order) => order.status == filterStatus!.name).toList();
    }

    list.sort((a, b) {
      int cmp = 0;
      switch (sortBy) {
        case PurchaseOrderSortBy.orderDate:
          cmp = a.createdAt.compareTo(b.createdAt);
          break;
        case PurchaseOrderSortBy.deliveryDate:
          cmp = (a.expectedDeliveryDate ?? DateTime(0)).compareTo(b.expectedDeliveryDate ?? DateTime(0));
          break;
        case PurchaseOrderSortBy.totalAmount:
          cmp = a.totalAmount.compareTo(b.totalAmount);
          break;
      }
      return sortOrder == PurchaseOrderSortOrder.ascending ? cmp : -cmp;
    });

    return list;
  }
}
