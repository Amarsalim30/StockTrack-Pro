
import 'package:clean_arch_app/domain/repositories/supplier_repository.dart';

class DeleteSupplierUseCase {
  final SupplierRepository repository;
  DeleteSupplierUseCase(this.repository);

  Future<void> call(String id) => repository.deleteSupplier(id);
}
