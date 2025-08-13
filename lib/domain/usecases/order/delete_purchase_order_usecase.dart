import 'package:clean_arch_app/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart' show Failure;

class DeletePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  DeletePurchaseOrderUseCase(this.repository);

  Future<Either<Failure,void>>  call(String id) async {
    return await repository.deletePurchaseOrder(id);
  }
}
