
import 'package:clean_arch_app/domain/entities/catalog/supplier.dart';
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';
import 'package:dartz/dartz.dart';

class GetSupplierByIdUseCase {
  final SupplierRepository repository;
  GetSupplierByIdUseCase(this.repository);

  Future<Either<Exception, Supplier>> call(String id) => repository.getSupplierById(id);
}
