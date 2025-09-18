import 'package:stocktrack_pro/domain/entities/catalog/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final String searchQuery;

  ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.searchQuery = '',
  });

  bool get hasError => error != null && error!.isNotEmpty;

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    String? searchQuery,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
