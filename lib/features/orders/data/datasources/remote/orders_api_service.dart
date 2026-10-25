import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/data/models/index.dart';

part 'orders_api_service.g.dart';

@RestApi()
abstract class OrdersApiService {
  factory OrdersApiService(Dio dio, {String baseUrl}) = _OrdersApiService;

  @GET("/v1/reseller/orders")
  Future<PaginationResponse<OrderModel>> getOrders({
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  });

  @GET("/v1/reseller/orders/{id}")
  Future<StandardResponse<OrderModel>> getOrder(@Path("id") String id);

  @POST("/v1/reseller/orders")
  Future<StandardResponse<OrderModel>> placeOrder(
    @Body() Map<String, dynamic> body,
  );

  @POST("/v1/reseller/orders/{id}/cancel")
  Future<StandardResponse<OrderModel>> cancelOrder(@Path("id") String id);
}
