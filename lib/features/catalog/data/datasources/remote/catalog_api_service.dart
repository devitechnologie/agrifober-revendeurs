import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/catalog/data/models/index.dart';

part 'catalog_api_service.g.dart';

@RestApi()
abstract class CatalogApiService {
  factory CatalogApiService(Dio dio, {String baseUrl}) = _CatalogApiService;

  @GET("/v1/reseller/catalog")
  Future<StandardResponse<CatalogModel>> getCatalog();

  /// Guest mode: same products, no price keys, no token needed.
  @GET("/v1/reseller/catalog/public")
  Future<StandardResponse<CatalogModel>> getPublicCatalog();
}
