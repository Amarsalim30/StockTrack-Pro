import 'package:dartz/dartz.dart';
import '../../../entities/order/purchase_order_item.dart';
import '../../../repositories/purchase_order_item_repository.dart';

class ReceivePurchaseOrderItem {
  final PurchaseOrderItemRepository repository;

  ReceivePurchaseOrderItem(this.repository);

  Future<Either<Exception, PurchaseOrderItem>> call(
      String purchaseOrderId, String stockId, int qtyReceived, int qtyOrdered) {
    // Business rule: Cannot receive more than ordered
    if (qtyReceived <= 0) {
      return Future.value(
          Left(Exception("Received quantity must be greater than 0")));
    }
    if (qtyReceived > qtyOrdered) {
      return Future.value(
          Left(Exception("Cannot receive more than ordered quantity")));
    }
    return repository.receiveItem(purchaseOrderId, stockId, qtyReceived);
  }
}
