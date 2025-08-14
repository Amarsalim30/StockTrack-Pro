import 'package:clean_arch_app/domain/usecases/catalog/supplier/create_supplier_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/delete_supplier_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/get_active_suppliers.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/get_all_suppliers_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/get_supplier_by_id_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/search_suppliers_usecase.dart';
import 'package:clean_arch_app/domain/usecases/catalog/supplier/update_supplier_usecase.dart';


class SupplierUseCases {
  final GetAllSuppliersUseCase getAllSuppliers;
  final GetSupplierByIdUseCase getSupplierById;
  final CreateSupplierUseCase createSupplier;
  final UpdateSupplierUseCase  updateSupplier;
  final DeleteSupplierUseCase deleteSupplier;
  final SearchSuppliersUseCase searchSuppliers;
  final GetActiveSuppliersUseCase getActiveSuppliers;

  SupplierUseCases({
    required this.getAllSuppliers,
    required this.getSupplierById,
    required this.createSupplier,
    required this.updateSupplier,
    required this.deleteSupplier,
    required this.searchSuppliers,
    required this.getActiveSuppliers,
  });
}
