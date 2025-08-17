
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:clean_arch_app/domain/repositories/purchase_order_repository.dart';
import 'package:dartz/dartz.dart';

class FilterPurchaseOrdersUseCase {
  final PurchaseOrderRepository repository;

  FilterPurchaseOrdersUseCase(this.repository);

  Future<Either<Failure,List<PurchaseOrder>>> call({String? status, String? supplierId}) {
    return repository.filterPurchaseOrders(status,  supplierId);
  }
}
