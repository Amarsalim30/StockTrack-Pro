
import 'package:clean_arch_app/domain/entities/catalog/product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String searchQuery;

  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.searchQuery = '',
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? searchQuery,
  }) =>
      ProductState(
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}