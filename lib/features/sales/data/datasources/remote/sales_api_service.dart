import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/data/models/index.dart';

part 'sales_api_service.g.dart';

@RestApi()
abstract class SalesApiService {
  factory SalesApiService(Dio dio, {String baseUrl}) = _SalesApiService;

  @GET("/v1/reseller/sales")
  Future<PaginationResponse<SaleModel>> getSales({
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  });

  @GET("/v1/reseller/sales/{id}")
  Future<StandardResponse<SaleModel>> getSale(@Path("id") String id);
}
