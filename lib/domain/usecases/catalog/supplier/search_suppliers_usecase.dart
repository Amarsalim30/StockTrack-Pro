import 'package:stocktrack_pro/domain/entities/catalog/supplier.dart';
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';
import 'package:dartz/dartz.dart';

class SearchSuppliersUseCase {
  final SupplierRepository repository;

  SearchSuppliersUseCase(this.repository);
  Future<Either<Exception, List<Supplier>>> call(String query) => repository.searchSuppliers(query);

}