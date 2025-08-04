import '../../../core/network/api_client.dart';
import '../../models/catalog/supplier_model.dart';

abstract class SupplierApi {
  Future<List<SupplierModel>> getAllSuppliers();

  Future<SupplierModel> getSupplierById(String id);

  Future<SupplierModel> createSupplier(SupplierModel supplier);

  Future<SupplierModel> updateSupplier(SupplierModel supplier);

  Future<void> deleteSupplier(String id);

  Future<List<SupplierModel>> searchSuppliers(String query);

  Future<List<SupplierModel>> getActiveSuppliers();
}

class SupplierApiImpl implements SupplierApi {
  final ApiClient _apiClient;

  SupplierApiImpl(this._apiClient);

  @override
  Future<List<SupplierModel>> getAllSuppliers() async {
    final response = await _apiClient.get<List<dynamic>>('/suppliers');
    return response.map((json) => SupplierModel.fromJson(json)).toList();
  }

  @override
  Future<SupplierModel> getSupplierById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/suppliers/$id',
    );
    return SupplierModel.fromJson(response);
  }

  @override
  Future<SupplierModel> createSupplier(SupplierModel supplier) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/suppliers',
      data: supplier.toJson(),
    );
    return SupplierModel.fromJson(response);
  }

  @override
  Future<SupplierModel> updateSupplier(SupplierModel supplier) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/suppliers/${supplier.id}',
      data: supplier.toJson(),
    );
    return SupplierModel.fromJson(response);
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await _apiClient.delete('/suppliers/$id');
  }

  @override
  Future<List<SupplierModel>> searchSuppliers(String query) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/suppliers/search',
      queryParameters: {'q': query},
    );
    return response.map((json) => SupplierModel.fromJson(json)).toList();
  }

  @override
  Future<List<SupplierModel>> getActiveSuppliers() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/suppliers',
      queryParameters: {'active': true},
    );
    return response.map((json) => SupplierModel.fromJson(json)).toList();
  }
}
