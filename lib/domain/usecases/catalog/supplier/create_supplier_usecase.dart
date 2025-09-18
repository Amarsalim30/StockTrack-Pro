
import 'package:stocktrack_pro/domain/entities/catalog/supplier.dart';
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';

class CreateSupplierUseCase {
  final SupplierRepository repository;
  CreateSupplierUseCase(this.repository);

  Future<void> call(Supplier supplier) => repository.createSupplier(supplier);
}
