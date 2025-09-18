
import 'package:stocktrack_pro/domain/entities/catalog/supplier.dart';
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';

class UpdateSupplierUseCase {
  final SupplierRepository repository;
  UpdateSupplierUseCase(this.repository);

  Future<void> call(Supplier supplier) => repository.updateSupplier(supplier);
}
