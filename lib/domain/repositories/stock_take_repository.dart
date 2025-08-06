import 'package:clean_arch_app/domain/entities/stock/stock_take_item.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/stock/stock_take.dart';

abstract class StockTakeRepository {
  // Stock Take Session Operations
  Future<Either<Failure, List<StockTake>>> getAllStockTakes();

  Future<Either<Failure, StockTake>> getStockTakeById(String id);

  Future<Either<Failure, StockTake>> createStockTake({
    required String name,
    String? description,
    String? locationId,
    List<String>? categoryFilters,
    List<String>? assignedTo,
  });

  Future<Either<Failure, StockTake>> updateStockTakeStatus({
    required String id,
    required StockTakeStatus status,
  });

  Future<Either<Failure, void>> deleteStockTake(String id);

  // Stock Take Item Operations
  Future<Either<Failure, List<StockTakeItem>>> getStockTakeItems(
    String stockTakeId,
  );

  Future<Either<Failure, StockTakeItem>> updateItemCount({
    required String itemId,
    required int countedQuantity,
    required CountMethod countMethod,
    String? notes,
    List<String>? photoUrls,
  });

  Future<Either<Failure, StockTakeItem>> getItemByBarcode({
    required String stockTakeId,
    required String barcode,
  });

  // Reporting
  Future<Either<Failure, Map<String, dynamic>>> generateDiscrepancyReport(
    String stockTakeId,
  );

  Future<Either<Failure, List<StockTake>>> getActiveStockTakes();

  Future<Either<Failure, List<StockTake>>> getStockTakesByUser(String userId);

  // Photo Management
  Future<Either<Failure, String>> uploadStockTakePhoto({
    required String stockTakeId,
    required String itemId,
    required String photoPath,
  });
}
