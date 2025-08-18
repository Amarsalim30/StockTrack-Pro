import 'package:dartz/dartz.dart';
import '../../core/enums/stock_status.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/stock/stock.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/remote/stock_api.dart';
import '../models/stock/stock_model.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi api;

  StockRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<Stock>>> getAllStocks() async {
    try {
      final stockModels = await api.getStocks();
      final stocks = stockModels.map((model) => model.toEntity()).toList();
      return Right(stocks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch stocks: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addStock(Stock stock) async {
    try {
      final stockModel = StockModel.fromDomain(stock);
      await api.addStock(stockModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockById(String id) async {
    try {
      final stockModel = await api.getStockById(id);
      return Right(stockModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch stock: $e'));
    }
  }


  @override
  Future<Either<Failure, Stock>> updateStock(Stock stock) async {
    try {
      final stockModel = StockModel.fromDomain(stock);
      await api.updateStock(stock.id, stockModel);
      return Right(stock);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update stock: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStock(String id) async {
    try {
      await api.deleteStock(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete stock: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStocks(List<String> ids) async {
    try {
      await api.deleteStocks({'ids': ids});
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete stocks: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStockStatus(String id,
      StockStatus status) async {
    try {
      await api.updateStockStatus({'ids': id, 'status': status.code});
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update stock status: $e'));
    }
  }
  Future<Either<Failure ,void>> updateMultipleStockStatus(
      List<String> ids, StockStatus status) async {
    try {
      await api.updateStockStatus({'ids': ids, 'status': status.code});
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update stock statuses: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> adjustStock(String stockId, int adjustment,
      String reason) async {
    try {
      await api.adjustStock(
          stockId, {'adjustment': adjustment, 'reason': reason});
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to adjust stock: $e'));
    }
  }
}
