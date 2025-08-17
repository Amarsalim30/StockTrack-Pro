import 'package:clean_arch_app/domain/entities/catalog/supplier.dart';
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';
import 'package:dartz/dartz.dart';

class GetActiveSuppliersUseCase {
  final SupplierRepository repository;

  GetActiveSuppliersUseCase(this.repository);
  Future<Either<Exception, List<Supplier>>> call() => repository.getActiveSuppliers();
}