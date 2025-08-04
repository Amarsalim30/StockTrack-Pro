import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/stock/stock_take.dart';
import '../../domain/repositories/stock_take_repository.dart';
import '../datasources/remote/stock_take_api.dart';

class StockTakeRepositoryImpl implements StockTakeRepository {
  final StockTakeApi stockTakeApi;
  final NetworkInfo networkInfo;

  StockTakeRepositoryImpl({
    required this.stockTakeApi,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StockTake>>> getAllStockTakes() async {
    if (await networkInfo.isConnected) {
      try {
        final stockTakes = await stockTakeApi.getAllStockTakes();
        return Right(stockTakes);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to get stock takes'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StockTake>> getStockTakeById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final stockTake = await stockTakeApi.getStockTakeById(id);
        return Right(stockTake);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to get stock take'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StockTake>> createStockTake({
    required String name,
    String? description,
    String? locationId,
    List<String>? categoryFilters,
    List<String>? assignedTo,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = {
          'name': name,
          'description': description,
          'locationId': locationId,
          'categoryFilters': categoryFilters,
          'assignedTo': assignedTo ?? [],
          'status': 'active',
          'startDate': DateTime.now().toIso8601String(),
        };

        final stockTake = await stockTakeApi.createStockTake(data);
        return Right(stockTake);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to create stock take'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StockTake>> updateStockTakeStatus({
    required String id,
    required StockTakeStatus status,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = {
          'status': status.toString().split('.').last,
          'endDate': status == StockTakeStatus.completed
              ? DateTime.now().toIso8601String()
              : null,
        };

        final stockTake = await stockTakeApi.updateStockTakeStatus(id, data);
        return Right(stockTake);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? 'Failed to update stock take status',
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStockTake(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await stockTakeApi.deleteStockTake(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to delete stock take'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<StockTakeItem>>> getStockTakeItems(
    String stockTakeId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await stockTakeApi.getStockTakeItems(stockTakeId);
        return Right(items);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to get stock take items'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StockTakeItem>> updateItemCount({
    required String itemId,
    required int countedQuantity,
    required CountMethod countMethod,
    String? notes,
    List<String>? photoUrls,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = {
          'countedQuantity': countedQuantity,
          'countMethod': countMethod.toString().split('.').last,
          'countedAt': DateTime.now().toIso8601String(),
          'notes': notes,
          'photoUrls': photoUrls,
        };

        final item = await stockTakeApi.updateItemCount(itemId, data);
        return Right(item);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to update item count'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StockTakeItem>> getItemByBarcode({
    required String stockTakeId,
    required String barcode,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final item = await stockTakeApi.getItemByBarcode(stockTakeId, barcode);
        return Right(item);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Product not found'));
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> generateDiscrepancyReport(
    String stockTakeId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final report = await stockTakeApi.generateDiscrepancyReport(
          stockTakeId,
        );
        return Right(report);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to generate report'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<StockTake>>> getActiveStockTakes() async {
    if (await networkInfo.isConnected) {
      try {
        final stockTakes = await stockTakeApi.getActiveStockTakes();
        return Right(stockTakes);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? 'Failed to get active stock takes',
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<StockTake>>> getStockTakesByUser(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final stockTakes = await stockTakeApi.getStockTakesByUser(userId);
        return Right(stockTakes);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to get user stock takes'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadStockTakePhoto({
    required String stockTakeId,
    required String itemId,
    required String photoPath,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final file = File(photoPath);
        final response = await stockTakeApi.uploadStockTakePhoto(
          stockTakeId,
          itemId,
          file,
        );

        final photoUrl = response['url'] as String?;
        if (photoUrl != null) {
          return Right(photoUrl);
        } else {
          return const Left(ServerFailure(message: 'Failed to upload photo'));
        }
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message ?? 'Failed to upload photo'),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
