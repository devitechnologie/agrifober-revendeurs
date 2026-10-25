import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/data/datasources/index.dart';
import 'package:agrifober_resellers/features/auth/data/models/index.dart';
import 'package:agrifober_resellers/features/auth/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl({required AuthApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<User>> login({
    required PhoneNumber phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.login({
        "country_code": phone.countryCode,
        "phone": phone.number,
        "password": password,
      });

      return DataState.success(data: response.toEntity());
    } on DioException catch (e) {
      final failure = handleDioError(e);
      return DataState.failure(error: failure);
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<User>> refreshToken({required String refreshToken}) async {
    try {
      final response = await _apiService.refreshToken({
        "refresh_token": refreshToken,
      });

      return DataState.success(data: response.toEntity());
    } on DioException catch (e) {
      final failure = handleDioError(e);
      return DataState.failure(error: failure);
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<Unit>> logout({required String refreshToken}) async {
    try {
      await _apiService.logout({"refresh_token": refreshToken});
      return DataState.success(data: unit);
    } on DioException catch (e) {
      final failure = handleDioError(e);
      return DataState.failure(error: failure);
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
