import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/order/purchase_order_item_model.dart';

part 'purchase_order_item_api.g.dart';

@RestApi()
abstract class PurchaseOrderItemApi {
  factory PurchaseOrderItemApi(Dio dio, {String baseUrl}) = _PurchaseOrderItemApi;

  @POST("/purchase-orders/{id}/items")
  Future<PurchaseOrderItemModel> addItem(
      @Path("id") String purchaseOrderId, @Body() PurchaseOrderItemModel item);

  @PUT("/purchase-orders/{id}/items/{stockId}")
  Future<PurchaseOrderItemModel> updateItem(
      @Path("id") String purchaseOrderId,
      @Body() PurchaseOrderItemModel item);

  @DELETE("/purchase-orders/{id}/items/{stockId}")
  Future<void> removeItem(
      @Path("id") String purchaseOrderId,
      @Path("stockId") String stockId);

  @POST("/purchase-orders/{id}/items/{stockId}/receive")
  Future<PurchaseOrderItemModel> receiveItem(
      @Path("id") String purchaseOrderId,
      @Path("stockId") String stockId,
      @Query("qty") int qtyReceived);

  @POST("/purchase-orders/{id}/items/{stockId}/mark-received")
  Future<PurchaseOrderItemModel> markAsFullyReceived(
      @Path("id") String purchaseOrderId,
      @Path("stockId") String stockId);
}
