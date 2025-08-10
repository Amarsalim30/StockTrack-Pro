import 'package:clean_arch_app/core/error/unexpected_failure.dart';
import 'package:dartz/dartz.dart';
import '../../core/enums/stock_status.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/stock/stock.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/remote/stock_api.dart';
import '../models/stock/stock_model.dart';

/// Concrete data-layer implementation of [StockRepository].
/// Converts between API models and domain entities, and maps exceptions to [Failure]s.
class StockRepositoryImpl implements StockRepository {
  final StockApi api;

  StockRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<Stock>>> getStocks() async {
    return _execute<List<Stock>>(() async {
      final stockModels = await api.getStocks();
      return stockModels.map((model) => model.toEntity()).toList();
    }, 'fetch stocks');
  }

  @override
  Future<Either<Failure, Stock>> getStockById(String id) async {
    return _execute<Stock>(() async {
      final stockModel = await api.getStockById(id);
      return stockModel.toEntity();
    }, 'fetch stock by ID');
  }

  @override
  Future<Either<Failure, Stock>> createStock(Stock stock) async {
    return _execute<Stock>(() async {
      final stockModel = StockModel.fromDomain(stock);
      await api.createStock(stockModel);
      return stock;
    }, 'create stock');
  }

  @override
  Future<Either<Failure, Stock>> updateStock(Stock stock) async {
    return _execute<Stock>(() async {
      final stockModel = StockModel.fromDomain(stock);
      await api.updateStock(stock.id, stockModel);
      return stock;
    }, 'update stock');
  }

  @override
  Future<Either<Failure, void>> deleteStock(String id) async {
    return _execute<void>(() async {
      await api.deleteStock(id);
    }, 'delete stock');
  }

  @override
  Future<Either<Failure, void>> deleteStocks(List<String> ids) async {
    return _execute<void>(() async {
      await api.deleteStocks({'ids': ids});
    }, 'delete multiple stocks');
  }

  @override
  Future<Either<Failure, void>> updateStockStatus(
      String id, StockStatus status) async {
    return _execute<void>(() async {
      await api.updateStockStatus({'ids': id, 'status': status.code});
    }, 'update stock status');
  }

  @override
  Future<Either<Failure, void>> adjustStock(
      String stockId, int adjustment, String reason) async {
    return _execute<void>(() async {
      await api.adjustStock(
        stockId,
        {'adjustment': adjustment, 'reason': reason},
      );
    }, 'adjust stock');
  }

  /// Utility method to wrap API calls, handle exceptions, and map to [Failure].
  Future<Either<Failure, T>> _execute<T>(
      Future<T> Function() body,
      String actionDescription,
      ) async {
    try {
      final result = await body();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error during $actionDescription'));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Cache error during $actionDescription'));
    } catch (e, stack) {
      // Optional: Log stack trace to Crashlytics/Sentry here
      return Left(UnexpectedFailure() as Failure);
    }
  }

  @override
  Future<Either<Failure, Stock>> addStock(Stock stock) {
    // TODO: implement addStock
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Stock>>> getAllStocks() {
    // TODO: implement getAllStocks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateMultipleStockStatus(List<String> ids, StockStatus status) {
    // TODO: implement updateMultipleStockStatus
    throw UnimplementedError();
  }
}
