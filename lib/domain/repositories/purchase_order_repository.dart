import 'package:dartz/dartz.dart';
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';

abstract class PurchaseOrderRepository {
  Future<Either<Failure, void>> createPurchaseOrder(PurchaseOrder order);

  Future<Either<Failure, PurchaseOrder>> getPurchaseOrderById(String id);

  Future<Either<Failure, List<PurchaseOrder>>> getAllPurchaseOrders();

  Future<Either<Failure, void>> updatePurchaseOrder(PurchaseOrder order);

  Future<Either<Failure, void>> deletePurchaseOrder(String id);

  Future<Either<Failure, PurchaseOrder>> approvePurchaseOrder(String id, String approverUserId);

  Future<Either<Failure, List<PurchaseOrder>>> filterPurchaseOrders(String? status, String? supplierId);

  Future<Either<Failure, void>> cancelPurchaseOrder(String id, String reason);
}
