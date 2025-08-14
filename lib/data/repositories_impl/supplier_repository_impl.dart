import 'package:clean_arch_app/data/datasources/remote/supplier_api.dart';
import 'package:clean_arch_app/data/mappers/catalog/supplier_mapper.dart';
import 'package:clean_arch_app/domain/entities/catalog/supplier.dart';
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';
import 'package:dartz/dartz.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierApi api;

  SupplierRepositoryImpl(this.api);

  @override
  Future<Either<Exception, List<Supplier>>> getAllSuppliers() async {
    try {
      final supplierModels = await api.getAllSuppliers();
      final suppliers = supplierModels
          .map(SupplierMapper.toEntity)
          .toList();
      return Right(suppliers);
    } catch (e) {
      return Left(Exception('Failed to fetch suppliers: $e'));
    }
  }

  @override
  Future<Either<Exception, Supplier>> createSupplier(Supplier supplier) async {
    try {
      final model = SupplierMapper.fromEntity(supplier);
      final createdModel = await api.createSupplier(model);
      return Right(SupplierMapper.toEntity(createdModel));
    } catch (e) {
      return Left(Exception('Failed to create supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteSupplier(String id) async {
    try {
      await api.deleteSupplier(id);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Supplier>>> getActiveSuppliers() async {
    try {
      final supplierModels = await api.getActiveSuppliers();
      final suppliers = supplierModels
          .map(SupplierMapper.toEntity)
          .toList();
      return Right(suppliers);
    } catch (e) {
      return Left(Exception('Failed to fetch active suppliers: $e'));
    }
  }

  @override
  Future<Either<Exception, Supplier>> getSupplierById(String id) async {
    try {
      final model = await api.getSupplierById(id);
      return Right(SupplierMapper.toEntity(model));
    } catch (e) {
      return Left(Exception('Failed to fetch supplier by ID: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Supplier>>> searchSuppliers(String query) async {
    try {
      final supplierModels = await api.searchSuppliers(query);
      final suppliers = supplierModels
          .map(SupplierMapper.toEntity)
          .toList();
      return Right(suppliers);
    } catch (e) {
      return Left(Exception('Failed to search suppliers: $e'));
    }
  }

  @override
  Future<Either<Exception, Supplier>> updateSupplier(Supplier supplier) async {
    try {
      final model = SupplierMapper.fromEntity(supplier);
      final updatedModel = await api.updateSupplier(model);
      return Right(SupplierMapper.toEntity(updatedModel));
    } catch (e) {
      return Left(Exception('Failed to update supplier: $e'));
    }
  }
}
