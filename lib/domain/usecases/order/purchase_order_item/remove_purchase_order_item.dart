import 'package:dartz/dartz.dart';
import '../../../repositories/purchase_order_item_repository.dart';

class RemovePurchaseOrderItem {
  final PurchaseOrderItemRepository repository;

  RemovePurchaseOrderItem(this.repository);

  Future<Either<Exception, void>> call(
      String purchaseOrderId, String stockId) {
    return repository.removeItem(purchaseOrderId, stockId);
  }
}
