import 'package:dartz/dartz.dart';
import '../../domain/entities/order/purchase_order_item.dart';
import '../../domain/repositories/purchase_order_item_repository.dart';
import '../datasources/remote/purchase_order_item_api.dart';
import '../models/order/purchase_order_item_model.dart';

class PurchaseOrderItemRepositoryImpl implements PurchaseOrderItemRepository {
  final PurchaseOrderItemApi api;

  PurchaseOrderItemRepositoryImpl(this.api);

  @override
  Future<Either<Exception, PurchaseOrderItem>> addItem(
      String purchaseOrderId, PurchaseOrderItem item) async {
    try {
      final model = PurchaseOrderItemModel.fromDomain(item);
      final result = await api.addItem(purchaseOrderId, model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(Exception('Failed to add item: $e'));
    }
  }

  @override
  Future<Either<Exception, PurchaseOrderItem>> updateItem(
      String purchaseOrderId, PurchaseOrderItem item) async {
    try {
      final model = PurchaseOrderItemModel.fromDomain(item);
      final result = await api.updateItem(purchaseOrderId, model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(Exception('Failed to update item: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> removeItem(
      String purchaseOrderId, String stockId) async {
    try {
      await api.removeItem(purchaseOrderId, stockId);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to remove item: $e'));
    }
  }

  @override
  Future<Either<Exception, PurchaseOrderItem>> receiveItem(
      String purchaseOrderId, String stockId, int qtyReceived) async {
    try {
      final result = await api.receiveItem(purchaseOrderId, stockId, qtyReceived);
      return Right(result.toDomain());
    } catch (e) {
      return Left(Exception('Failed to receive item: $e'));
    }
  }

  @override
  Future<Either<Exception, PurchaseOrderItem>> markAsFullyReceived(
      String purchaseOrderId, String stockId) async {
    try {
      final result = await api.markAsFullyReceived(purchaseOrderId, stockId);
      return Right(result.toDomain());
    } catch (e) {
      return Left(Exception('Failed to mark item as fully received: $e'));
    }
  }
}
