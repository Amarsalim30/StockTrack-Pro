import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/order/purchase_order.dart';
import 'package:stocktrack_pro/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart';

class GetPurchaseOrderByIdUseCase {
  final PurchaseOrderRepository repository;

  GetPurchaseOrderByIdUseCase(this.repository);

  Future<Either<Failure,PurchaseOrder?>> call(String id) async {
    return await repository.getPurchaseOrderById(id);
  }
}
