// lib/domain/usecases/purchase_order/purchase_order_usecases.dart

import 'create_purchase_order_usecase.dart';
import 'update_purchase_order_usecase.dart';
import 'delete_purchase_order_usecase.dart';
import 'get_purchase_order_by_id_usecase.dart';
import 'get_all_purchase_orders_usecase.dart';
import 'approve_purchase_order_usecase.dart';
import 'cancel_purchase_order_usecase.dart';
import 'filter_purchase_orders_usecase.dart';

class PurchaseOrderUseCases {
  final CreatePurchaseOrderUseCase createPurchaseOrder;
  final UpdatePurchaseOrderUseCase updatePurchaseOrder;
  final DeletePurchaseOrderUseCase deletePurchaseOrder;
  final GetPurchaseOrderByIdUseCase getPurchaseOrderById;
  final GetAllPurchaseOrdersUseCase getAllPurchaseOrders;
  final ApprovePurchaseOrderUseCase approvePurchaseOrder;
  final CancelPurchaseOrderUseCase cancelPurchaseOrder;
  final FilterPurchaseOrdersUseCase filterPurchaseOrders;

  PurchaseOrderUseCases({
    required this.createPurchaseOrder,
    required this.updatePurchaseOrder,
    required this.deletePurchaseOrder,
    required this.getPurchaseOrderById,
    required this.getAllPurchaseOrders,
    required this.approvePurchaseOrder,
    required this.cancelPurchaseOrder,
    required this.filterPurchaseOrders,
  });
}
