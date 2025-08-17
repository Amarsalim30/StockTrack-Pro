import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/stock/stock_model.dart';

part 'stock_api.g.dart';

@RestApi()
abstract class StockApi {
  factory StockApi(Dio dio, {String baseUrl}) = _StockApi;

  @GET("/stocks")
  Future<List<StockModel>> getStocks();

  @GET("/stocks/{id}")
  Future<StockModel> getStockById(@Path("id") String id);

  @POST("/stocks/add")
  Future<void> addStock(@Body() StockModel stock);

  @PUT("/stocks/{id}")
  Future<void> updateStock(@Path("id") String id, @Body() StockModel stock);

  @DELETE("/stocks/{id}")
  Future<void> deleteStock(@Path("id") String id);

  @POST("/stocks/bulk-delete")
  Future<void> deleteStocks(@Body() Map<String, dynamic> body); // {'ids': []}

  @POST("/stocks/bulk-update-status")
  Future<void> updateStockStatus(@Body() Map<String, dynamic> body); // {'ids': [], 'status': 1}

  @POST("/stocks/{id}/adjust")
  Future<void> adjustStock(@Path("id") String stockId,
      @Body() Map<String, dynamic> body, // {adjustment, reason}
      );
}
