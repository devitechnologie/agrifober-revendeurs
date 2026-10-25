import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/account/data/models/index.dart';

part 'account_api_service.g.dart';

@RestApi()
abstract class AccountApiService {
  factory AccountApiService(Dio dio, {String baseUrl}) = _AccountApiService;

  @GET("/v1/reseller/summary")
  Future<StandardResponse<AccountSummaryModel>> getSummary();
}
