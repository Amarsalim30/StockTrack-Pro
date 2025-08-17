import 'package:dartz/dartz.dart';
import '../entities/order/purchase_order_item.dart';

abstract class PurchaseOrderItemRepository {
  Future<Either<Exception, PurchaseOrderItem>> addItem(
      String purchaseOrderId, PurchaseOrderItem item);

  Future<Either<Exception, PurchaseOrderItem>> updateItem(
      String purchaseOrderId, PurchaseOrderItem item);

  Future<Either<Exception, void>> removeItem(
      String purchaseOrderId, String stockId);

  Future<Either<Exception, PurchaseOrderItem>> receiveItem(
      String purchaseOrderId, String stockId, int qtyReceived);

  Future<Either<Exception, PurchaseOrderItem>> markAsFullyReceived(
      String purchaseOrderId, String stockId);
}
