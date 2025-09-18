
import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/order/purchase_order.dart';
import 'package:stocktrack_pro/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart';

class ApprovePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  ApprovePurchaseOrderUseCase(this.repository);

  Future<Either<Failure,PurchaseOrder>> call(String id,String userId) {
    return repository.approvePurchaseOrder(id ,userId);
  }
}
