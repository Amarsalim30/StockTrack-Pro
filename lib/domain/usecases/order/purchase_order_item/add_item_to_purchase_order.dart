import 'package:dartz/dartz.dart';
import '../../../entities/order/purchase_order_item.dart';
import '../../../repositories/purchase_order_item_repository.dart';

class AddItemToPurchaseOrder {
  final PurchaseOrderItemRepository repository;

  AddItemToPurchaseOrder(this.repository);

  Future<Either<Exception, PurchaseOrderItem>> call(
      String purchaseOrderId, PurchaseOrderItem item) {
    // Business rule: Must be valid quantity and cost
    if (item.quantityOrdered <= 0 || item.unitCost! <= 0) {
      return Future.value(
          Left(Exception("Quantity and cost must be greater than 0")));
    }
    return repository.addItem(purchaseOrderId, item);
  }
}
