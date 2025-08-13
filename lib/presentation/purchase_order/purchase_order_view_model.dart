// purchase_order_view_model.dart
import 'dart:async';

import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/purchase_order_status.dart';
import '../../domain/entities/auth/permission_type.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/order/purchase_order_usecases.dart';
import 'purchase_order_state.dart';

class PurchaseOrderViewModel extends StateNotifier<PurchaseOrderState> {
  final PurchaseOrderUseCases purchaseOrderUseCases;
  final AuthRepository authRepository;
  Timer? _searchDebounce;

  PurchaseOrderViewModel({
    required this.purchaseOrderUseCases,
    required this.authRepository,
  }) : super(PurchaseOrderState.initial()) {
    _init();
  }

  void _init() {
    _loadCurrentUser();
    loadPurchaseOrders();
  }

  Future<void> _loadCurrentUser() async {
    final res = await authRepository.getCurrentUser();
    res.fold(
      (failure) => state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Failed to load user'),
      (user) => state = state.copyWith(currentUser: user),
    );
  }

  bool hasPermission(PermissionType permission) =>
      state.currentUser?.hasPermission(permission) ?? false;

  bool get canCreatePurchaseOrder => hasPermission(PermissionType.createOrder);
  bool get canApprovePurchaseOrder => hasPermission(PermissionType.approveOrder);
  bool get canCancelPurchaseOrder => hasPermission(PermissionType.approveOrder);

  Future<void> loadPurchaseOrders() async {
    state = state.copyWith(status: PurchaseOrderStateStatus.loading, errorMessage: null);

    final result = await purchaseOrderUseCases.getAllPurchaseOrders();
    result.fold(
      (failure) => state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Failed to load purchase orders'),
      (orders) => state = state.copyWith(purchaseOrders: orders, status: PurchaseOrderStateStatus.success),
    );
  }

  Future<void> refresh() async => loadPurchaseOrders();

  void setSearchQuery(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(searchQuery: query);
    });
  }

  void setFilterStatus(PurchaseOrderStatus? status) {
    state = state.copyWith(filterStatus: status);
  }

  void setSortBy(PurchaseOrderSortBy sortBy) {
    if (state.sortBy == sortBy) {
      final newOrder = state.sortOrder == PurchaseOrderSortOrder.ascending
          ? PurchaseOrderSortOrder.descending
          : PurchaseOrderSortOrder.ascending;
      state = state.copyWith(sortOrder: newOrder);
    } else {
      state = state.copyWith(sortBy: sortBy, sortOrder: PurchaseOrderSortOrder.ascending);
    }
  }

  Future<void> createPurchaseOrder(PurchaseOrder order) async {
    if (!canCreatePurchaseOrder) {
      state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Permission denied');
      return;
    }
    state = state.copyWith(status: PurchaseOrderStateStatus.loading);
    final result = await purchaseOrderUseCases.createPurchaseOrder(order);
    result.fold(
      (failure) => state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Failed to create purchase order'),
      (_) => loadPurchaseOrders(),
    );
  }
  
  Future<void> approvePurchaseOrder(String orderId) async {
    if (!canApprovePurchaseOrder) {
      state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Permission denied');
      return;
    }
    state = state.copyWith(status: PurchaseOrderStateStatus.loading);
    final result = await purchaseOrderUseCases.approvePurchaseOrder(orderId, state.currentUser!.id);
    result.fold(
      (failure) => state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Failed to approve purchase order'),
      (_) => loadPurchaseOrders(),
    );
  }

  Future<void> cancelPurchaseOrder(String orderId, String reason) async {
    if (!canCancelPurchaseOrder) {
      state = state.copyWith(status: PurchaseOrderStateStatus.error, errorMessage: 'Permission denied');
      return;
    }
    state = state.copyWith(status: PurchaseOrderStateStatus.loading);
    final result = await purchaseOrderUseCases.cancelPurchaseOrder(orderId, reason);
        loadPurchaseOrders();

  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
