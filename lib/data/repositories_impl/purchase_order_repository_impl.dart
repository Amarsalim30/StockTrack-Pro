import 'package:dartz/dartz.dart';
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/data/datasources/remote/purchase_order_api.dart';
import 'package:clean_arch_app/data/mappers/order/purchase_order_mapper.dart';
import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:clean_arch_app/domain/repositories/purchase_order_repository.dart';

class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  final PurchaseOrderApi api;

  PurchaseOrderRepositoryImpl(this.api);

  @override
  Future<Either<Failure, void>> createPurchaseOrder(PurchaseOrder order) async {
    try {
      final model = PurchaseOrderMapper.fromEntity(order);
      await api.createPurchaseOrder(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrder>> getPurchaseOrderById(String id) async {
    try {
      final model = await api.getPurchaseOrderById(id);
      if (model != null) {
        return Right(PurchaseOrderMapper.toEntity(model));
      } else {
        return Left(ServerFailure(message: "Purchase order not found"));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseOrder>>> getAllPurchaseOrders() async {
    try {
      final models = await api.getAllPurchaseOrders();
      return Right(models.map(PurchaseOrderMapper.toEntity).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePurchaseOrder(PurchaseOrder order) async {
    try {
      final model = PurchaseOrderMapper.fromEntity(order);
      await api.updatePurchaseOrder(model.id, model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePurchaseOrder(String id) async {
    try {
      await api.deletePurchaseOrder(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrder>> approvePurchaseOrder(String id, String approverUserId) async {
    try {
      final model = await api.approvePurchaseOrder(id, approverUserId);
      return Right(PurchaseOrderMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseOrder>>> filterPurchaseOrders(String? status, String? supplierId) async {
    try {
      final models = await api.filterPurchaseOrders(status, supplierId);
      return Right(models.map(PurchaseOrderMapper.toEntity).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPurchaseOrder(String id, String reason) async {
    try {
      await api.cancelPurchaseOrder(id, reason);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
