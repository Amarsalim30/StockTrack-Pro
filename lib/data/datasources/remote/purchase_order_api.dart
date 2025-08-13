import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:clean_arch_app/data/models/order/purchase_order_model.dart';

part 'purchase_order_api.g.dart';

@RestApi()
abstract class PurchaseOrderApi {
  factory PurchaseOrderApi(Dio dio, {String baseUrl}) = _PurchaseOrderApi;

  @POST('/purchase-orders')
  Future<void> createPurchaseOrder(@Body() PurchaseOrderModel order);

  @PUT('/purchase-orders/{id}')
  Future<void> updatePurchaseOrder(
      @Path("id") String id,
      @Body() PurchaseOrderModel order,
      );

  @DELETE('/purchase-orders/{id}')
  Future<void> deletePurchaseOrder(@Path("id") String id);

  @GET('/purchase-orders/{id}')
  Future<PurchaseOrderModel?> getPurchaseOrderById(@Path("id") String id);

  @GET('/purchase-orders')
  Future<List<PurchaseOrderModel>> getAllPurchaseOrders();

  @POST('/purchase-orders/{id}/approve')
  Future<PurchaseOrderModel> approvePurchaseOrder(
      @Path("id") String id,
      @Field("approvedByUserId") String approverUserId,
      );

  @POST('/purchase-orders/{id}/cancel')
  Future<PurchaseOrderModel> cancelPurchaseOrder(
      @Path("id") String id,
      @Field("reason") String reason,
      );

  @GET('/purchase-orders')
  Future<List<PurchaseOrderModel>> filterPurchaseOrders(
      @Query("status") String? status,
      @Query("supplierId") String? supplierId,
      );
}
