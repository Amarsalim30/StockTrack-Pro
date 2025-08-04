import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/stock/stock_take_model.dart';

part 'stock_take_api.g.dart';

@RestApi()
abstract class StockTakeApi {
  factory StockTakeApi(Dio dio, {String? baseUrl}) = _StockTakeApi;

  // Stock Take Session APIs
  @GET('/stock-takes')
  Future<List<StockTakeModel>> getAllStockTakes();

  @GET('/stock-takes/{id}')
  Future<StockTakeModel> getStockTakeById(@Path('id') String id);

  @POST('/stock-takes')
  Future<StockTakeModel> createStockTake(@Body() Map<String, dynamic> data);

  @PATCH('/stock-takes/{id}/status')
  Future<StockTakeModel> updateStockTakeStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/stock-takes/{id}')
  Future<void> deleteStockTake(@Path('id') String id);

  @GET('/stock-takes/active')
  Future<List<StockTakeModel>> getActiveStockTakes();

  @GET('/stock-takes/user/{userId}')
  Future<List<StockTakeModel>> getStockTakesByUser(
    @Path('userId') String userId,
  );

  // Stock Take Item APIs
  @GET('/stock-takes/{stockTakeId}/items')
  Future<List<StockTakeItemModel>> getStockTakeItems(
    @Path('stockTakeId') String stockTakeId,
  );

  @PATCH('/stock-takes/items/{itemId}')
  Future<StockTakeItemModel> updateItemCount(
    @Path('itemId') String itemId,
    @Body() Map<String, dynamic> data,
  );

  @GET('/stock-takes/{stockTakeId}/items/barcode/{barcode}')
  Future<StockTakeItemModel> getItemByBarcode(
    @Path('stockTakeId') String stockTakeId,
    @Path('barcode') String barcode,
  );

  // Reporting APIs
  @GET('/stock-takes/{stockTakeId}/report/discrepancy')
  Future<Map<String, dynamic>> generateDiscrepancyReport(
    @Path('stockTakeId') String stockTakeId,
  );

  // Photo Upload
  @POST('/stock-takes/{stockTakeId}/items/{itemId}/photo')
  @MultiPart()
  Future<Map<String, dynamic>> uploadStockTakePhoto(
    @Path('stockTakeId') String stockTakeId,
    @Path('itemId') String itemId,
    @Part(name: 'photo') File photo,
  );
}
