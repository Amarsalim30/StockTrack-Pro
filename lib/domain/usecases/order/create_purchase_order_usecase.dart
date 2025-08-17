import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:clean_arch_app/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart' show Either;

class CreatePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  CreatePurchaseOrderUseCase(this.repository);

  Future<Either<Failure,void>> call(PurchaseOrder order) async {
    return await repository.createPurchaseOrder(order);
  }
}
