import 'package:stocktrack_pro/domain/entities/catalog/product.dart';
import 'package:stocktrack_pro/domain/usecases/catalog/product/product_usecases.dart';
import 'package:stocktrack_pro/presentation/catalog/product/mock_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_state.dart';

class ProductViewModel extends StateNotifier<ProductState> {
  final ProductUseCases useCases;

  ProductViewModel(this.useCases) : super(ProductState()) {
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await useCases.getAll.call(null);
      res.fold(
            (err) => state = state.copyWith(
          isLoading: false,
          error: err.toString(),
          products: mockProducts, // fallback
        ),
            (products) => state = state.copyWith(
          isLoading: false,
          products: products.isNotEmpty ? products : mockProducts,
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        products: mockProducts,
      );
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await fetchAllProducts();
      return;
    }

    state = state.copyWith(isLoading: true, searchQuery: query, error: null);
    try {
      final res = await useCases.search.call(query);
      res.fold(
            (err) => state = state.copyWith(
          isLoading: false,
          error: err.toString(),
        ),
            (products) => state = state.copyWith(
          isLoading: false,
          products: products,
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addProduct(Product product) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await useCases.create.call(product);
      res.fold(
            (err) => state = state.copyWith(isLoading: false, error: err.toString()),
            (_) async {
          await fetchAllProducts(); // refresh
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProduct(Product product) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await useCases.update.call(product);
      res.fold(
            (err) => state = state.copyWith(isLoading: false, error: err.toString()),
            (_) async {
          await fetchAllProducts();
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteProduct(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await useCases.delete.call(id);
      res.fold(
            (err) => state = state.copyWith(isLoading: false, error: err.toString()),
            (_) async {
          await fetchAllProducts();
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSearch(String value) {
    if (value.isEmpty) {
      fetchAllProducts();
    } else {
      searchProducts(value);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
