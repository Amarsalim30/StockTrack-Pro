import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/order/purchase_order.dart';
import 'package:stocktrack_pro/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart';

class UpdatePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  UpdatePurchaseOrderUseCase(this.repository);

  Future<Either<Failure,void>> call(PurchaseOrder order) async {
    return await repository.updatePurchaseOrder(order);
  }
}