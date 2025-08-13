import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:clean_arch_app/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart';

class GetPurchaseOrderByIdUseCase {
  final PurchaseOrderRepository repository;

  GetPurchaseOrderByIdUseCase(this.repository);

  Future<Either<Failure,PurchaseOrder?>> call(String id) async {
    return await repository.getPurchaseOrderById(id);
  }
}
