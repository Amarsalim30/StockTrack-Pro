import 'package:stocktrack_pro/domain/entities/catalog/supplier.dart';
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';
import 'package:dartz/dartz.dart';

class GetActiveSuppliersUseCase {
  final SupplierRepository repository;

  GetActiveSuppliersUseCase(this.repository);
  Future<Either<Exception, List<Supplier>>> call() => repository.getActiveSuppliers();
}