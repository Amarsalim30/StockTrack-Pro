
import 'package:clean_arch_app/domain/entities/catalog/supplier.dart';
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';

class UpdateSupplierUseCase {
  final SupplierRepository repository;
  UpdateSupplierUseCase(this.repository);

  Future<void> call(Supplier supplier) => repository.updateSupplier(supplier);
}
