import 'package:dartz/dartz.dart';
import '../entities/catalog/supplier.dart';

abstract class SupplierRepository {
  Future<Either<Exception, List<Supplier>>> getAllSuppliers();

  Future<Either<Exception, Supplier>> getSupplierById(String id);

  Future<Either<Exception, Supplier>> createSupplier(Supplier supplier);

  Future<Either<Exception, Supplier>> updateSupplier(Supplier supplier);

  Future<Either<Exception, void>> deleteSupplier(String id);

  Future<Either<Exception, List<Supplier>>> searchSuppliers(String query);

  Future<Either<Exception, List<Supplier>>> getActiveSuppliers();
}
