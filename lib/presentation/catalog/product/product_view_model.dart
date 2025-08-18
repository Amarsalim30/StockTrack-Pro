import 'package:clean_arch_app/domain/entities/catalog/product.dart';
import 'package:clean_arch_app/domain/usecases/catalog/product/product_usecases.dart';
import 'package:clean_arch_app/presentation/catalog/product/mock_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_state.dart';


class ProductViewModel extends StateNotifier<ProductState> {
  final ProductUseCases useCases;

  ProductViewModel(this.useCases) : super(ProductState()) {
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    state = state.copyWith(isLoading: true);
    final res = mockProducts;
    // await useCases.getAll.call(null);
    // res.fold(
    //       (err) => state = state.copyWith(isLoading: false),
    //       (products) => state = state.copyWith(isLoading: false, products: products),
    // );
  }

  Future<void> searchProducts(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query);
    final res = await useCases.search.call(query);
    res.fold(
          (err) => state = state.copyWith(isLoading: false),
          (products) => state = state.copyWith(isLoading: false, products: products),
    );
  }

  Future<void> addProduct(Product product) async {
    final res = await useCases.create.call(product);
    res.fold(
          (_) {},
          (_) => fetchAllProducts(),
    );
  }

  Future<void> updateProduct(Product product) async {
    final res = await useCases.update.call(product);
    res.fold(
          (_) {},
          (_) => fetchAllProducts(),
    );
  }

  Future<void> deleteProduct(String id) async {
    final res = await useCases.delete.call(id);
    res.fold(
          (_) {},
          (_) => fetchAllProducts(),
    );
  }

  void updateSearch(String value) {
  }
}
