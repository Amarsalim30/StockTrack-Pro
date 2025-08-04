import '../../../core/network/api_client.dart';
import '../../models/catalog/product_model.dart';

abstract class ProductApi {
  Future<List<ProductModel>> getAllProducts();

  Future<ProductModel> getProductById(String id);

  Future<ProductModel> createProduct(ProductModel product);

  Future<ProductModel> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);

  Future<List<ProductModel>> searchProducts(String query);

  Future<List<ProductModel>> getProductsByCategory(String category);

  Future<List<ProductModel>> getProductsBySupplierId(String supplierId);

  Future<List<ProductModel>> getLowStockProducts();

  Future<List<ProductModel>> getOutOfStockProducts();
}

class ProductApiImpl implements ProductApi {
  final ApiClient _apiClient;

  ProductApiImpl(this._apiClient);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _apiClient.get<List<dynamic>>('/products');
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/products/$id',
    );
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/products',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/products/${product.id}',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _apiClient.delete('/products/$id');
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/products/search',
      queryParameters: {'q': query},
    );
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/products',
      queryParameters: {'category': category},
    );
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getProductsBySupplierId(String supplierId) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/products',
      queryParameters: {'supplierId': supplierId},
    );
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getLowStockProducts() async {
    final response = await _apiClient.get<List<dynamic>>('/products/low-stock');
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getOutOfStockProducts() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/products/out-of-stock',
    );
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }
}
