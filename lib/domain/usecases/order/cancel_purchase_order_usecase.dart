
import 'package:stocktrack_pro/domain/repositories/purchase_order_repository.dart';

class CancelPurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  CancelPurchaseOrderUseCase(this.repository);

  Future<void> call(String id ,String userId) {
    return repository.cancelPurchaseOrder(id ,userId);
  }
}
