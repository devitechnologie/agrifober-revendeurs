import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/features/auth/data/models/index.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST("/v1/reseller/auth/login")
  Future<AuthUserModel> login(@Body() Map<String, dynamic> body);

  @POST("/v1/reseller/auth/refresh")
  Future<AuthUserModel> refreshToken(@Body() Map<String, dynamic> body);

  @POST("/v1/reseller/auth/logout")
  Future<void> logout(@Body() Map<String, dynamic> body);
}
