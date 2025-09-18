import 'package:stocktrack_pro/domain/entities/catalog/supplier.dart';
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';
import 'package:dartz/dartz.dart';


class GetAllSuppliersUseCase {
  final SupplierRepository repository;
  GetAllSuppliersUseCase(this.repository);

  Future<Either<Exception, List<Supplier>>> call() => repository.getAllSuppliers();
}
