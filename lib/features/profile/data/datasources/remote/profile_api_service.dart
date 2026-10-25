import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/data/models/index.dart';
import 'package:agrifober_resellers/features/profile/data/models/index.dart';

part 'profile_api_service.g.dart';

@RestApi()
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio, {String baseUrl}) = _ProfileApiService;

  @GET("/v1/reseller/me")
  Future<StandardResponse<ProfileModel>> getProfile();

  /// Answers like login: the profile plus a new token pair.
  @POST("/v1/reseller/auth/password")
  Future<AuthUserModel> changePassword(@Body() Map<String, dynamic> body);

  /// Deletes the app account (access only — Agrifober keeps the records).
  @POST("/v1/reseller/account/delete")
  Future<void> deleteAccount(@Body() Map<String, dynamic> body);
}
