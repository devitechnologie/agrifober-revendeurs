import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/credit/data/models/index.dart';

part 'credit_api_service.g.dart';

@RestApi()
abstract class CreditApiService {
  factory CreditApiService(Dio dio, {String baseUrl}) = _CreditApiService;

  @GET("/v1/reseller/credit")
  Future<StandardResponse<CreditStatementModel>> getStatement();
}
