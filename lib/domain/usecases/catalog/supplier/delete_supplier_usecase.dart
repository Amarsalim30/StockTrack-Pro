
import 'package:stocktrack_pro/domain/repositories/supplier_repository.dart';

class DeleteSupplierUseCase {
  final SupplierRepository repository;
  DeleteSupplierUseCase(this.repository);

  Future<void> call(String id) => repository.deleteSupplier(id);
}
