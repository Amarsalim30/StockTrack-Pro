import 'package:dartz/dartz.dart';
import '../../../entities/order/purchase_order_item.dart';
import '../../../repositories/purchase_order_item_repository.dart';

class MarkItemAsFullyReceived {
  final PurchaseOrderItemRepository repository;

  MarkItemAsFullyReceived(this.repository);

  Future<Either<Exception, PurchaseOrderItem>> call(
      String purchaseOrderId, String stockId) {
    return repository.markAsFullyReceived(purchaseOrderId, stockId);
  }
}
