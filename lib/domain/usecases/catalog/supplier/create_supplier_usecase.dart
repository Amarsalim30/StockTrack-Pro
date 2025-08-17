
import 'package:clean_arch_app/domain/entities/catalog/supplier.dart';
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';

class CreateSupplierUseCase {
  final SupplierRepository repository;
  CreateSupplierUseCase(this.repository);

  Future<void> call(Supplier supplier) => repository.createSupplier(supplier);
}
