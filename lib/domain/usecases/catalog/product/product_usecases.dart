import 'product_usecase.dart';

class ProductUseCases {
  final GetAllProductsUseCase getAll;
  final GetProductByIdUseCase getById;
  final CreateProductUseCase create;
  final UpdateProductUseCase update;
  final DeleteProductUseCase delete;
  final SearchProductsUseCase search;
  final GetProductsByCategoryUseCase getByCategory;
  final GetProductsBySupplierUseCase getBySupplier;
  final GetLowStockProductsUseCase getLowStock;
  final GetOutOfStockProductsUseCase getOutOfStock;

  ProductUseCases({
    required this.getAll,
    required this.getById,
    required this.create,
    required this.update,
    required this.delete,
    required this.search,
    required this.getByCategory,
    required this.getBySupplier,
    required this.getLowStock,
    required this.getOutOfStock,
  });
}
