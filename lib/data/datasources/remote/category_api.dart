import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/catalog/category_model.dart';

part 'category_api.g.dart';

@RestApi()
abstract class CategoryApi {
  factory CategoryApi(Dio dio, {String? baseUrl}) = _CategoryApi;

  @GET('/categories')
  Future<List<CategoryModel>> getAllCategories();

  @GET('/categories/{id}')
  Future<CategoryModel> getCategoryById(@Path('id') String id);

  @GET('/categories/search')
  Future<List<CategoryModel>> searchCategories(@Query('query') String query);

  @GET('/categories/parent/{parentId}')
  Future<List<CategoryModel>> getCategoriesByParent(@Path('parentId') String parentId);

  @POST('/categories')
  Future<CategoryModel> createCategory(@Body() CategoryModel category);

  @PUT('/categories/{id}')
  Future<CategoryModel> updateCategory(@Path('id') String id, @Body() CategoryModel category);

  @DELETE('/categories/{id}')
  Future<void> deleteCategory(@Path('id') String id);
}