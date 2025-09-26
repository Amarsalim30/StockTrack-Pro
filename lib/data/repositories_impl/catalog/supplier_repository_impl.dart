import 'package:dartz/dartz.dart';
import '../../../domain/entities/catalog/supplier.dart';
import '../../../domain/repositories/supplier_repository.dart';
import '../../datasources/remote/catalog/supplier_firebase_data_source.dart';
import '../../mappers/catalog/supplier_mapper.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierFirebaseDataSource _firebaseDataSource;

  SupplierRepositoryImpl(this._firebaseDataSource);

  @override
  Future<Either<Exception, List<Supplier>>> getAllSuppliers() async {
    final result = await _firebaseDataSource.getAllSuppliers();
    return result.map((models) => models.map(SupplierMapper.toEntity).toList());
  }

  @override
  Future<Either<Exception, Supplier>> getSupplierById(String id) async {
    final result = await _firebaseDataSource.getSupplierById(id);
    return result.map(SupplierMapper.toEntity);
  }

  @override
  Future<Either<Exception, Supplier>> createSupplier(Supplier supplier) async {
    final model = SupplierMapper.fromEntity(supplier);
    final result = await _firebaseDataSource.createSupplier(model);
    return result.map(SupplierMapper.toEntity);
  }

  @override
  Future<Either<Exception, Supplier>> updateSupplier(Supplier supplier) async {
    final model = SupplierMapper.fromEntity(supplier);
    final result = await _firebaseDataSource.updateSupplier(model);
    return result.map(SupplierMapper.toEntity);
  }

  @override
  Future<Either<Exception, void>> deleteSupplier(String id) async {
    return await _firebaseDataSource.deleteSupplier(id);
  }

  @override
  Future<Either<Exception, List<Supplier>>> getActiveSuppliers() async {
    final result = await _firebaseDataSource.getActiveSuppliers();
    return result.map((models) => models.map(SupplierMapper.toEntity).toList());
  }

  @override
  Future<Either<Exception, List<Supplier>>> searchSuppliers(String query) async {
    final result = await _firebaseDataSource.searchSuppliers(query);
    return result.map((models) => models.map(SupplierMapper.toEntity).toList());
  }
}